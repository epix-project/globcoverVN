#' Extract the ratio of land cover by polygons
#'
#' @param landcover RasterLayer of land cover
#' @param polygons SpatialPolygons
#' @param spatial_unit_names character string
#'
#' @examples
#' library(sf)
#' landcover <- globcoverVN::getgcvn()
#' polygons <- as_Spatial(gadmVN::gadm())
#' polygons@proj4string <- landcover@crs
#' globcoverVN:::lcsummary(landcover, polygons, "province")
#' @noRd
lcsummary <- function(landcover, polygons, spatial_unit_names) {

  if (!identical(raster::projection(landcover), raster::projection(polygons)))
    stop("'landcover' and 'polygon' should have the same projections")

  # let's extract the land cover by province:
  landcover <- setNames(raster::extract(landcover, polygons),
                      polygons[[spatial_unit_names]])

  # let's compute the tables of land cover:
  out <- lapply(landcover, table)

  # transform the outputs into data frames:
  out <- lapply(out, function(x) setNames(data.frame(as.list(x)), names(x)))

  # binds together:
  out <- dplyr::bind_rows(out, .id = spatial_unit_names)

  # replace the missing values by zeros:
  tmp <- out[, -1]
  tmp[is.na(tmp)] <- 0
  tmp <- sweep(tmp, 1, rowSums(tmp), "/")
  out[, -1] <- tmp

  # return the output:
  out
}

