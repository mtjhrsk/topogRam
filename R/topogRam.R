#' `d3.js` topogram
#'
#' Continuous area cartograms with `d3.js`
#'
#' @param data a \code{data.frame} with at least two variables : the geo id and the value associated
#' @param key_var a character vector of length one or more, or a named list. The value to represent on the map
#' @param shape geographical shape to use, should be one of \code{france-reg}, \code{france-reg-2016}, \code{france-dep}, \code{usa-states}
#' @param geo_id name of variable containing the geographical id
#' @param geo_lab name of variable containing the geographical label
#' @param colors a vector of color to use on the map
#'
#'
#' @import htmlwidgets
#' @import jsonlite
#'
#' @export

topogRam <- function(data, key_var, shape = "france-reg", geo_id = "id", geo_lab = NULL,
                     colors, origin = NULL, scale = NULL, width = 500, height = 500, elementId = NULL) {

  if (missing(colors))
    colors <- c("#FEE5D9", "#FCAE91", "#FB6A4A", "#DE2D26", "#A50F15")

  if (geo_id != "id")
    names(data)[names(data) == geo_id] <- "id"

  if (!is.null(geo_lab))
    names(data)[names(data) == geo_lab] <- "NAME"

  if (is.list(key_var) && !is.list(unlist(key_var, recursive = FALSE)))
    key_var <- list(key_var)

  if (!is.list(key_var) & is.character(key_var))
    key_var <- lapply(key_var, function(x) list(key = x, name = "", format = "", lab = ""))

  shape <- match.arg(arg = shape, choices = c("france-reg", "france-reg-2016", "france-dep", "france-dep-2", "usa-states"))

  if (is.null(origin))
    origin <- c(8, 45.5)
  if (is.null(scale))
    scale <- 2500

  # shapejs <- switch(
  #   shape,
  #   "france-reg" = 'frReg',
  #   "france-dep" = 'frDep',
  #   "france-dep-2" = 'frDep2',
  #   "france-reg-2016" = 'frReg2016',
  #   "usa-states" = 'usaStates'
  # )

  # forward options using x
  x = list(
    data = jsonlite::toJSON(x = data),
    colors = jsonlite::toJSON(x = colors),
    fields = jsonlite::toJSON(x = key_var, auto_unbox = TRUE),
    shape = shape, #shapejs = shapejs,
    addSelect = jsonlite::toJSON(length(key_var) > 1, auto_unbox = TRUE),
    idSelect = paste0("selectfield", round(runif(1,1e6,9e6))),
    origin = jsonlite::toJSON(x = origin), scale = jsonlite::toJSON(x = scale)
  )

  # shapesDisp <- list(
  #   "france-reg" = 'france-regions.topojson',
  #   "france-dep" = 'france-departements.topojson',
  #   "france-dep-2" = 'france-departements-2.topojson',
  #   "france-reg-2016" = 'france-regions-2016.topojson',
  #   "usa-states" = 'usa-states.topojson'
  # )
  #
  # # Dependancies
  # shapeDep <- htmltools::htmlDependency(
  #   name = "shapes",
  #   version = '1.0',
  #   src = system.file('htmlwidgets/lib/shapes', package = 'topogRam'),
  #   attachment = shapesDisp[shape]
  # )

  # create widget
  htmlwidgets::createWidget(
    name = 'topogRam',
    x,
    width = width,
    height = height,
    # dependencies = shapeDep,
    package = 'topogRam',
    elementId = elementId
  )
}

#' Shiny bindings for topogRam
#'
#' Output and render functions for using topogRam within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a topogRam
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name topogRam-shiny
#'
#' @export
topogRamOutput <- function(outputId, width = '500px', height = '500px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'topogRam', width, height, package = 'topogRam')
}

#' @rdname topogRam-shiny
#' @export
renderTopogRam <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, topogRamOutput, env, quoted = TRUE)
}