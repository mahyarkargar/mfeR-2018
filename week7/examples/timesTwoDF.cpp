#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
DataFrame timesTwoDF(NumericVector x) {
  // create a new vector y the same size as x
  NumericVector y(x.size());
  // loop through, double x, assign to y
  for(int i = 0; i < x.size(); i++) {
    y[i] = x[i]*2.0;
  }
  // return a data.frame
  return DataFrame::create(
    Named("x")=x,
    Named("y")=y);
}