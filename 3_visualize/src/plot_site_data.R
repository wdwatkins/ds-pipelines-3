# plot each site indiviudally
plot_site_data <- function(site_data, out_file) {
  p <- ggplot(oldest_site_data, aes(x=Date, y=Value, color=Quality)) + geom_line() + ggtitle(Site)
  ggsave(out_file, plot=p)
}
# plot_sites_data <- function(sites_data, out_dir) {
#   for(site in unique(sites_data$site_no)) {
#     site_data <- filter(sites_data, site_no == site)
#   }
# }
