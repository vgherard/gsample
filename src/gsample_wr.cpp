/*

 // N.B. The implementation below (not exported) is highly inefficient, having
 // time complexity of O(size * num_classes)

#include "gsample.h"
using namespace Rcpp;


// [[Rcpp::export]]
IntegerVector gsample_wr(size_t size, NumericVector weights, bool log_weights)
{
	// Total number of classes
	size_t K = weights.size();

	// Define new variable to avoid modifying weights in place
	NumericVector phi;
	if (not log_weights)
		phi = weights;
	else
		phi = log(weights);

	// At each step:
	// generate K variables g[k] = phi + (Gumbel noise) and take argmax
	// Time = O(size * K), Space = O(K + size)
	IntegerVector res(size);
	auto res_end = res.end();
	NumericVector g(K);
	for (auto res_it = res.begin(); res_it != res_end; ++res_it) {
		// Add Gumbel noise to each phi[i] and take argmax
		g = phi - log(-log(Rcpp::runif(K)));
		*res_it = which_max(g) + 1; // Prob(rhs == i) ~ exp(phi[i - 1])
	}

	return res;
} // gsample_wr

*/
