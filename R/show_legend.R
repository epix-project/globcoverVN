#' Show legend
#'
#' Print to screen the legend of a spatial object.
#'
#' @param object an object of type raster
#'
#' @docType methods
#' @rdname show_legend-methods
#'
#' @export
setGeneric("show_legend", function(object) {
  standardGeneric("show_legend")
})



#' @rdname show_legend-methods
setMethod("show_legend", signature(object = "RasterLayer"), function(object) {
  out <- data.frame(landtype = object@legend@names,
                    code     = object@legend@values,
                    color    = object@legend@color, stringsAsFactors = FALSE)
  rownames(out) <- NULL
  cat(paste(c(paste("", out[1:8, "code"], ":", out[1:8, "landtype"]),
              paste(out[9:20, "code"], ":", out[9:20, "landtype"])), collapse = "\n"))
  invisible(out)
})
