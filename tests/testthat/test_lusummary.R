library(sf)
library(sp)
library(raster)

context("lcsummary")

test_that("`lcsummary` behaves correctly", {

  landcover <- globcoverVN::getgcvn()
  polygons <- as_Spatial(gadmVN::gadm())
  polygons@proj4string <- CRS("+init=epsg:4267")

  expect_error(globcoverVN:::lcsummary(landcover, polygons, "province"))

  polygons <- as_Spatial(gadmVN::gadm())
  test1 <- globcoverVN:::lcsummary(landcover, polygons, "province")
  expect_equal(mean(rowSums(test1[, which(names(test1) != "province")])), 1)
})
