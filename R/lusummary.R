lusummary <- function(landcover, polygons, spatial_unit_names) {

  if (!identical(projection(landcover), projection(polygons)))
    stop("'landcover' and 'polygon' should have the same projections")

  # let's extract the land use by province:
  landcover <- setNames(raster::extract(landcover, polygons),
                      polygons[[spatial_unit_names]])

  # let's compute the tables of land use:
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

# Let's try it:
#landcover <- globcoverVN::getgcvn()
#polygons <- gadmVN::gadm()
#polygons@proj4string <- landcover@crs
#essai <- lusummary(landcover, polygons, "province")

