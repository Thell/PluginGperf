# inline.R: Google performance tools helper plugin for Rcpp.

#' Register the plugin with Rcpp
#' @importFrom Rcpp registerPlugin
#' @export
register.plugin <- function() {
  # Sure this _could_ be done via onLoad but the plugin shouldn't
  # __need__ loading, just like `cpp11`, `openmp`, etc...
  pkg_name <- getPackageName()
  registerPlugin(pkg_name, inlineCxxPlugin)
}

#' Provide needed compilation flags for google performance tools.
#' @param ... who knows.
#' @importFrom Rcpp Rcpp.plugin.maker
inlineCxxPlugin <- function(...) {

  # It'd be nicer if the full `context` was passed to hooks
  # as output would simply only use onBuildComplete context$dynlibPath.
  # As it is logic would need to be added to make this work with
  # packages instead of ad-hoc sourceCpp commands.
  setHook("sourceCpp.onBuildComplete", function(successful, ...) {
    if (successful) {
      dynLibPath <- getwd()
      dynLibPath <- list.files(dynLibPath,
                               pattern = "sourceCpp_.*so",
                               full.names = TRUE)
      cat("Execute profiling function then in a shell run:\n",
           "google-pprof --web", dynLibPath, "gprof.out")
    }
    return(NULL)
  }, action = "append")

  plugin <- Rcpp.plugin.maker(
    libs = "-lprofiler",
    package = "PluginGperf")

  settings <- plugin()
  settings$env$PKG_CPPFLAGS <-
    "-g -fno-omit-frame-pointer -DGOOGLE_PROFILER"

  settings
}
