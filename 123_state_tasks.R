do_state_tasks <- function(oldest_active_sites, ...) {

  split_inventory(summary_file = '1_fetch/tmp/state_splits.yml',
                  sites_info = oldest_active_sites)

  # Define task table rows
  task_names <- unique(oldest_active_sites$state_cd)

  # Define task table columns
  download_step <- create_task_step(
    step_name = 'download',
    # Make target names like "WI_data"
    target_name = function(task_name, ...) {
      sprintf("%s_data", task_name)
    },
    # Make commands that call get_site_data()
    command = function(task_name, ...) {
      inventory_file <- sprintf('1_fetch/tmp/inventory_%s.tsv', task_name)
      psprintf("get_site_data(",
               "sites_info_file = '%s'," = inventory_file,
                "parameter = parameter)")
    }
  )

  plot_step <- create_task_step(
    step_name = 'plot',
    target_name = function(task_name, ...) {
      sprintf('3_visualize/out/timeseries_%s.png', task_name)
    },
    command = function(steps, ...) {
      psprintf('plot_site_data(out_file = target_name,',
                "site_data = %s," = steps[['download']]$target_name,
                "parameter = parameter)")
    }
  )

  tally_step <- create_task_step(
    step_name = 'tally',
    target_name = function(task_name, ...) {
      sprintf("%s_tally", task_name)
    },
    command = function(steps, ...) {
      sprintf("tally_site_obs(%s)", steps[['download']]$target_name)
    }
  )


  # Return test results to the parent remake file
  # Create the task plan
  task_plan <- create_task_plan(
    task_names = task_names,
    task_steps = list(download_step, plot_step, tally_step),
    add_complete = FALSE)

  # Create the task remakefile
  create_task_makefile(
    # TODO: ADD ARGUMENTS HERE
    task_plan = task_plan,
    makefile = '123_state_tasks.yml',
    include = 'remake.yml',
    sources = c(...),
    packages = c("dataRetrieval", "tidyverse"),
    tickquote_combinee_objects = FALSE,
    finalize_funs = c())

  scmake('123_state_tasks', remake_file='123_state_tasks.yml')

  # Return nothing to the parent remake file
  return()
}

split_inventory <- function(summary_file='1_fetch/tmp/state_splits.yml',
                            sites_info=oldest_active_sites) {
  if(!dir.exists('1_fetch/tmp')) dir.create('1_fetch/tmp')
  sites_info %>%
    purrrlyr::by_row(function(x) {
      readr::write_tsv(x = x, path = file.path('1_fetch/tmp',
                                        paste0('inventory_', x$state_cd, ".tsv")))
    })
  inventories_sorted <- sites_info %>% pull(state_cd) %>%
    sprintf('1_fetch/tmp/inventory_%s.tsv', .) %>%
    sort()
  sc_indicate(ind_file = summary_file, data_file = inventories_sorted)
}
