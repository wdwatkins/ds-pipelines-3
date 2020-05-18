map_sites <- function(site_info, out_file) {
  state_polys <- urbnmapr::get_urbn_map(map = "states", sf = FALSE) %>%
    filter(state_abbv %in% site_info$state_cd)
  map_sites <- filter(site_info, state_cd %in% state_polys$state_abbv)
  p <- ggplot(state_polys, aes(long, lat, group = group)) +
    geom_polygon(fill = "lightgrey", color = "#ffffff", size = 0.25) +
    geom_point(data=map_sites, aes(y=dec_lat_va, x=dec_long_va, color=begin_date), group=NA) +
    theme_minimal() +
    coord_map(projection = "albers", lat0 = 39, lat1 = 45)
  ggsave(out_file, plot=p, width=5, height=4)
}
