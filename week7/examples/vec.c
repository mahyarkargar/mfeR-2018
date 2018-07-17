void cumsum(double *x, int *n, double *res) {
  res[0] = x[0];
  for (int i = 1; i < *n; ++i) {
    res[i] = x[i] + x[i-1];
  }
}