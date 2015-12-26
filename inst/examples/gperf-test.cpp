/*
 * Example only... for profiler to capture any output
 * the size of the NumericVector on my system needed
 * to be >= 6000000.
 */

// [[Rcpp::plugins(cpp11, PluginGperf)]]

#include <Rcpp.h>
using namespace Rcpp;

#ifdef GOOGLE_PROFILER
#include <gperftools/profiler.h>
#endif

// [[Rcpp::export]]
NumericVector timesTwo(NumericVector x) { return x * 2; }

// [[Rcpp::export]]
NumericVector gperf(NumericVector x) {

#ifdef GOOGLE_PROFILER
#define CPUPROFILE_FREQUENCY 250
  ProfilerStart("gprof.out");
  auto y = timesTwo(x);
  ProfilerStop();
#else
  Rcpp::warning("Rcpp gperf plugin is not active.");
  auto y = x;
#endif

  return y;
}
