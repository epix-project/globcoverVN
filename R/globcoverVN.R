#' globcoverVN: land use of Vietnam from the GlobCover project.
#'
#' The globcover package provides land use data for Vietnam from the GlobCover
#' project. The data contain 20 types of land use.
#'
#' @docType package
#' @importFrom stats setNames
#' @name globcoverVN
NULL

## quiets concerns of R CMD check for the values that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c("projection", "res"))

