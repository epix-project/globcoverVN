library(sf)
library(sp)
library(raster)

context("lusummary")

test_that("`lusummary` behaves correctly", {

  landcover <- globcoverVN::getgcvn()
  polygons <- as_Spatial(gadmVN::gadm())
  polygons@proj4string <- CRS("+init=epsg:4267")

  expect_error(globcoverVN:::lusummary(landcover, polygons, "province"))

  polygons <- as_Spatial(gadmVN::gadm())
  test1 <- globcoverVN:::lusummary(landcover, polygons, "province")
  expect_equal(mean(rowSums(test1[, which(names(test1) != "province")])), 1)
})
