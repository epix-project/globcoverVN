#' Proportions of provinces per landcover
#'
#' Generates a provinces map of Vietnam for a given date with proportions of
#' each land cover category as attributes.
#'
#' These maps are prepared by
#'
#' @note argument \code{merge_hanoi} makes a difference only for \code{date}
#' before 2008-01-01.
#'
#' @param date either text in the "YYYY-MM-DD" format (for example "2015-01-17"
#' for the 17th of January 2017), or a numeric format of the year (for example
#' 2015). By default "2015-01-01".
#' @param merge_hanoi boolean indicating whether the provinces of Ha Noi and
#' Ha Son Binh (or Ha Noi and Ha Tay) should be merged.
#' @author Marc Choisy
#' @export
#' @return An object of class "SpatialPolygonsDataFrame".
getlandcover <- function(date = "2015-01-01", merge_hanoi = FALSE) {
  if (class(date) == "Date" | is.character(date)) date <- sub("-.*$", "",  date)
  years <- c(2008, 2004, 1997, 1992, 1991, 1990, 1979)
  sel <- sum(date < c(1990:1992, 1997, 2004, 2008)) + 1
  get(paste0("y", years[sel], merge_hanoi))
}
