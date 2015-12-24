// [[Rcpp::plugins(cpp11, PluginGperf)]]

/*
 * Example only... for profiler to capture any output
 * the size of the NumericVector on my system needed
 * to be >= 6000000.
 */

#include <Rcpp.h>
using namespace Rcpp;

#ifdef GOOGLE_PROFILER
#include <gperftools/profiler.h>
#endif

// [[Rcpp::export]]
NumericVector timesTwo(NumericVector x) {
  return x * 2;
}

#ifdef GOOGLE_PROFILER
#define CPUPROFILE_FREQUENCY 250
// [[Rcpp::export]]
NumericVector gperf(NumericVector x) {
  ProfilerStart("gprof.out");

  auto y = timesTwo(x);

  ProfilerStop();
  return y;
}
#endif
