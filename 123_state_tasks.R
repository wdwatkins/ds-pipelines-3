do_state_tasks <- function(oldest_active_sites, parameter, ...) {

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
      sprintf("get_site_data(sites_info = oldest_active_sites,
                    state = I('%s'),
                    parameter = parameter)", task_name)
    }
  )

  # Return test results to the parent remake file
  # Create the task plan
  task_plan <- create_task_plan(
    task_names = task_names,
    task_steps = list(download_step),
    add_complete = FALSE)

  # Create the task remakefile
  create_task_makefile(
    # TODO: ADD ARGUMENTS HERE
    task_plan = task_plan,
    makefile = '123_state_tasks.yml',
    include = 'remake.yml',
    sources = c("1_fetch/src/get_site_data.R"),
    packages = c("dataRetrieval", "tidyverse"),
    tickquote_combinee_objects = FALSE,
    finalize_funs = c())

  scmake('123_state_tasks', remake_file='123_state_tasks.yml')

  # Return nothing to the parent remake file
  return()
}
