#
# code snippets for topic VI3: R Programming - Rccp interface
##install.packages('Rcpp')

## ------------------------------------------------------------------------
library(Rcpp)
evalCpp("2 + 2") # simple test

## ------------------------------------------------------------------------
evalCpp("std::numeric_limits<double>::max()")

## ------------------------------------------------------------------------
cppFunction("
  int simpleExample() {
    int x = 10;
    return x;
}")
simpleExample() # same identifier as C++ function

## ------------------------------------------------------------------------
cppFunction("
  int exampleCpp11() {
    auto x = 10;
    return x;
}",plugins=c("cpp11"))
exampleCpp11() # same identifier as C++ function

## ------------------------------------------------------------------------
# You might need to change the path
sourceCpp("./examples/timesTwo.cpp")

## ------------------------------------------------------------------------
timesTwo(c(12,24))

## ------------------------------------------------------------------------
sourceCpp("./examples/timesTwoDF.cpp")
x <- 1:3
df <- timesTwoDF(x)
str(df)

## ------------------------------------------------------------------------
sourceCpp("./examples/rcppNormals.cpp")
set.seed(18)
rcppNormals(5)

