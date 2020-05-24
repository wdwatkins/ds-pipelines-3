# compute number of observations per year
tally_site_obs <- function(site_data) {
  # pretend this operation takes some noticeable time?

  site_data %>%
    mutate(Year = lubridate::year(Date)) %>%
    # group by Site and State just to retain those columns, since we're already only looking at just one site worth of data
    group_by(Site, State, Year) %>%
    summarize(NumObs = length(which(!is.na(Value))))
}
# tally_sites_obs <- function(sites_info, sites_data) {
#   oldest_site_tallies <- purrr::map_df(sites_data$site_no, function(site) {
#     tally_site_obs(filter(sites_data, Site==site), filter(sites_info, site_no==site))
#   })
# }
