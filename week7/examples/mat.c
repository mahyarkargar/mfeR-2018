void vecsum(double *x, int *n, double *res) {
  for (int i = 0; i < *n; ++i) {
    *res += x[i];
  }
}