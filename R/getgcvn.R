#' sdgsdfg
#'
#' dsfgfdsg
#'
#' dsfgsdfg
#' dsfgdsfg
#' @export
getgcvn <- function(x) {
  get("globcoverVN")
  globcoverVN@file@name <- system.file("extdata",
                                       "globcoverVN.tif",
                                       package = "globcoverVN")
  globcoverVN
}
