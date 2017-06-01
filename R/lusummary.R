lusummary <- function(landuse, polygons, spatial_unit_names) {

  if (!identical(projection(landuse), projection(polygons)))
    stop("'landuse' and 'polygon' should have the same projections")

  # let's extract the land use by province:
  landuse <- setNames(raster::extract(landuse, polygons), polygons[[spatial_unit_names]])

  # let's compute the tables of land use:
  out <- lapply(landuse, table)

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
#landuse <- globcoverVN::getgcvn()
#polygons <- gadmVN::gadm()
#polygons@proj4string <- landuse@crs
#essai <- lusummary(landuse, polygons, "province")

