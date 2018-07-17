#include <random>

extern "C" {
  void randNorm(int *seed, double *out)
  {
    std::mt19937 e(*seed);
    std::normal_distribution<double> N(0.0, 1.0);
    out[0] = N(e);
  }
}



