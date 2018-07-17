#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
NumericVector rcppNormals(int n) {
  return rnorm(n);
}