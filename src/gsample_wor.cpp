#include "gsample.h"
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector gsample_wor(size_t n,
                          size_t size,
                          NumericVector weights,
                          bool log_weights
                          )
{
	// Initialize a generator of uniform random numbers in (0, 1)
	// Will be used to generate standard Gumbel noise ~ G(0, 1)
	std::random_device rd;
	std::default_random_engine gen(rd());
	std::uniform_real_distribution<> unif(0, 1);

	// Build heap of indexes k = 1...K, using as priority key for 'k' its
	// (unnormalized) log-probability shifted with Gumbel noise ~ G(0, 1).
	// Space-time complexity: S = O(n), T = O(n)
	std::vector<int> H(n);
	std::vector<double> g(n);
	for (int k = 0; k < n; k++) {
		g[k] = log_weights ? weights[k] : log(weights[k]);
		g[k] += -log(-log(unif(gen))); // rhs ~ G(0, 1)
		H[k] = k + 1;
	}
	auto cmp = [& g](const int & l, const int & r)
		{return g[l - 1] < g[r - 1];}; // Indexes in H(n) are one-based!
	std::make_heap(H.begin(), H.end(), cmp);

	// Fill result with 'size' indexes having largest g
	// Time = O(size * log(K)), Space = O(size)
	IntegerVector res(size);
	auto res_end = res.end();
	for (auto res_it = res.begin(); res_it != res_end; ++res_it) {
		*res_it = H.front();
		std::pop_heap(H.begin(), H.end(), cmp);
		H.pop_back();
	}

	return res;
} // gsample_wor
