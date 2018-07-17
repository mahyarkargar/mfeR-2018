#include <R.h>
#include <Rmath.h>
void randNorm(double *out)
{
    GetRNGstate();
		out[0] = norm_rand();
		PutRNGstate();
}