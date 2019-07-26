lupopsummary <- function(landcover, population, polygons, spatial_unit_names) {

  if (any(!c(identical(projection(landcover), projection(population)),
             identical(projection(landcover), projection(polygons)),
             identical(projection(polygons), projection(population)))))
    stop("'landcover', 'population', and 'polygon' should have the same ",
         "projections")

  if (!identical(res(landcover), res(population))) {
    if (res(population)[1] < res(landcover)[1])
      population <- raster::resample(population, landcover)
    else landcover <- raster::resample(landcover, population)
  }

# let's extract the population densities by province:
  population <- setNames(raster::extract(population, polygons),
                         polygons[[spatial_unit_names]])

# let's extract the land use by province:
  landcover <- setNames(raster::extract(landcover, polygons),
                      polygons[[spatial_unit_names]])

# now we need to identify the index of the values that are missing in at least
# one of the 2 data sets:
  na_idx <- mapply("|", lapply(population, is.na), lapply(landcover, is.na))
  na_idx <- lapply(na_idx, "!")

# remove these values from the two data sets:
  population <- mapply("[", population, na_idx)
  landcover <- mapply("[", landcover, na_idx)

# some of the polygons (islands) may not have corresponding values in the raster
# files, in which case the above test returns a vector of length zero. We need
# to remove them too:
  sel <- which(vapply(na_idx, length, 0) < 1)
  if (length(sel) > 0) {
    population <- population[-sel]
    landcover <- landcover[-sel]
  }

# let's compute the weighted tables of land use:
  out <- mapply(weights::wpct, landcover, population)

# transform the outputs into data frames:
  out <- lapply(out, function(x) setNames(data.frame(as.list(x)), names(x)))

# binds together:
  out <- dplyr::bind_rows(out, .id = spatial_unit_names)

# replace the missing values by zeros:
  tmp <- out[, -1]
  tmp[is.na(tmp)] <- 0
  out[, -1] <- tmp

# return the output:
  out
}

# Let's try it:
#landcover <- globcoverVN::getgcvn()
#population <- worldpopVN::getpop(2015)
#polygons <- gadmVN::gadm()
#polygons@proj4string <- population@crs
#essai <- lupopsummary(landcover, population, polygons, "province")

