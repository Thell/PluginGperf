# inline.R: Google performance tools helper plugin for Rcpp.
#
# It'd be nice if the full `context` was passed to hooks.
# ie: dynLibPath <-  context$dynlibPath.

.onLoad <- function(libname, pkgname) {
  options(gperf.active = FALSE)

  setHook("sourceCpp.onBuildComplete", function(successful, ...) {
    if (successful && isTRUE(getOption("gperf.active"))) {
      options("gperf.active" = FALSE)
      dynLibPath <- getwd()
      dynLibPath <- list.files(dynLibPath,
                               pattern = "sourceCpp_.*so",
                               full.names = TRUE)
      cat("Execute profiling function then in a shell run:\n",
          "google-pprof --web", dynLibPath, "gprof.out")
    }
    return(NULL)
  }, action = "append")
}

#' Register the plugin with Rcpp
#' @importFrom Rcpp registerPlugin
#' @export
register.plugin <- function() {
  pkg_name <- getPackageName()
  registerPlugin(pkg_name, inlineCxxPlugin)
}

#' Provide needed compilation flags for google performance tools.
#' @param ... who knows.
#' @importFrom Rcpp Rcpp.plugin.maker
inlineCxxPlugin <- function(...) {
  plugin <- Rcpp.plugin.maker(
    libs = "-lprofiler",
    package = "PluginGperf")

  settings <- plugin()
  settings$env$PKG_CPPFLAGS <-
    "-g -fno-omit-frame-pointer -DGOOGLE_PROFILER"

  options(gperf.active = TRUE)
  settings
}
