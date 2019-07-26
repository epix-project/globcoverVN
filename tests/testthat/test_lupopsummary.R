library(sf)
library(sp)
library(raster)

context("lupopsummary")

test_that("`lupopsummary` behaves correctly", {

  landcover <- globcoverVN::getgcvn()
  polygons <- as_Spatial(gadmVN::gadm())
  polygons@proj4string <- CRS("+init=epsg:4267")
  population <- worldpopVN::getpop(2015)

  expect_error(globcoverVN:::lupopsummary(landcover, population, polygons,
                                           "province"))

  polygons <- as_Spatial(gadmVN::gadm())
  test1 <- globcoverVN:::lupopsummary(landcover, population, polygons,
                                      "province")

  expect_equal(mean(rowSums(test1[, which(names(test1) != "province")])), 1)

})
