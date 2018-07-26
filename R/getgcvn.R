#' sdgsdfg
#'
#' dsfgfdsg
#'
#' dsfgsdfg
#' dsfgdsfg
#' @export
getgcvn <- function() {
  get("globcoverVN")
  globcoverVN@file@name <- system.file("extdata",
                                       "globcoverVN.tif",
                                       package = "globcoverVN")
  globcoverVN
}
