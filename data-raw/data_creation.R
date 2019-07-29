library(globcover)
library(gadmVN)
globcover <- getgc()
vietnam <- gadm(level = "country", resolution = "high")
globcoverVN <- crop(globcover, vietnam)
themask <- rasterize(vietnam, globcoverVN)
globcoverVN <- mask(globcoverVN, themask)
dir.create("inst/extdata", showWarnings = FALSE, recursive = TRUE)
writeRaster(globcoverVN, "inst/extdata/globcoverVN.tif", "GTiff", overwrite = TRUE)
globcoverVN <- raster("inst/extdata/globcoverVN.tif")
# the legend:
globcover_val <- unique(globcover)
globcoverVN_val <- unique(globcoverVN)
sel <- globcover_val %in% globcoverVN_val
globcoverVN@legend@values <- globcover@legend@values[sel]
globcoverVN@legend@color <- globcover@legend@color[sel]
globcoverVN@legend@names <- globcover@legend@names[sel]

# ------------------------------------------------------------------------------

landcover <- globcoverVN::getgcvn()
population <- worldpopVN::getpop(2015)
#provinces <- gadmVN::gadm()
#provinces@proj4string <- population@crs

fct <- function(provinces) {
  lccovperc <- lcpopsummary(landcover, population, provinces, "province")
  names(lccovperc)[-1] <- paste0(names(lccovperc)[-1], "_pop")
  provinces <- merge(provinces, lccovperc)
  provinces <- merge(provinces, lcsummary(landcover, provinces, "province"))
  provinces@data <- provinces@data[, c("province", "11", "14", "20", "30", "40",
                                       "50", "60", "70", "100", "110", "120",
                                       "130", "140", "150", "160", "170", "190",
                                       "200", "210", "220", "11_pop", "14_pop",
                                       "20_pop", "30_pop","40_pop", "50_pop",
                                       "60_pop", "70_pop", "100_pop", "110_pop",
                                       "120_pop", "130_pop", "140_pop", "150_pop",
                                       "160_pop", "170_pop", "190_pop", "200_pop",
                                       "210_pop", "220_pop")]
  provinces
}

dates <- c(rep(c(1979, 1990:1992, 1997, 2004), 2), 2008)
merge_hanois <- c(rep(c(TRUE, FALSE), each = 6), FALSE)
provinces <- mapply(gadmVN::gadm, date = dates, merge_hanoi = merge_hanois)
f <- function(x) {x@proj4string <- population@crs; x}
provinces <- lapply(provinces, f)
out <- lapply(provinces, fct)
names(out) <- paste0("y", dates, merge_hanois)
list2env(out, globalenv())
eply::evals(paste0("devtools::use_data(",
                   paste(grep("^y\\d{4}.*$", ls(), value = TRUE), collapse = ", "),
                   ", internal = TRUE, overwrite = TRUE)"))


# ------------------------------------------------------------------------------

eply::evals(paste0("devtools::use_data(",
                   paste(c(grep("^y\\d{4}.*$", ls(), value = TRUE), "globcoverVN"),
                         collapse = ", "), ", internal = TRUE, overwrite = TRUE)"))

#devtools::use_data(globcoverVN, internal = TRUE, overwrite = TRUE)
#devtools::use_data(provinces, overwrite = TRUE)
