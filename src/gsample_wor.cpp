#include "gsample.h"
using namespace Rcpp;

class Comparison {
	const std::vector<double> & g_;
public:
	Comparison(const std::vector<double> & g) : g_(g) {}
	bool operator() (const size_t &l, const size_t & r)
		{return g_[l] < g_[r];}
};

// [[Rcpp::export]]
IntegerVector gsample_wor(size_t n,
                          size_t size,
                          NumericVector prob
                          )
{
	// Build heap of indexes k = 1...K, using g[k] = e[k] / weights[k] as
	// priority keys, where e[k] ~ Exp(rate = 1)
	// Space-time complexity: S = O(n), T = O(n)
	std::vector<size_t> H(n);
	std::iota(H.begin(), H.end(), 0);
	std::vector<double> g(n);
	for (size_t k = 0; k < n; k++) {
	 	g[k] = prob[k] / R::rexp(1.0);
	}
	Comparison cmp(g);
	std::make_heap(H.begin(), H.end(), cmp);

	// Fill result with 'size' indexes having largest g - equivalent to
	// sampling w/o replacement (Gumbel-Max trick).
	// Time = O(size * log(n)), Space = O(size)
	IntegerVector res(size);
	auto res_end = res.end();
	for (auto res_it = res.begin(); res_it != res_end; ++res_it) {
		*res_it = H.front() + 1; // Indexes in H(n) are zero-based!
		std::pop_heap(H.begin(), H.end(), cmp);
		H.pop_back();
	}

	return res;
} // gsample_wor
