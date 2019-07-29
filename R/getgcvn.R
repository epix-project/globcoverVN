#' Get local land cover
#'
#' Retrieves a raster file containing the land cover of Vietnam.
#'
#' @examples
#' library(raster)
#' landcover <- getgcvn()
#' plot(landcover)
#' @export
getgcvn <- function() {
  get("globcoverVN")
  globcoverVN@file@name <- system.file("extdata",
                                       "globcoverVN.tif",
                                       package = "globcoverVN")
  globcoverVN
}
