#include "gsample.h"
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector gsample_wor(size_t size, NumericVector weights, bool log_weights)
{
	// Initialize a generator of uniform random numbers in (0, 1)
	// Will be used to generate standard Gumbel noise ~ G(0, 1)
	std::random_device rd;
	std::default_random_engine gen(rd());
	std::uniform_real_distribution<> unif(0, 1);

	// Total number of classes
	size_t K = weights.size();

	// Build heap of indexes, using g[k] = phi[k] + G(0, 1) as priority keys
	// Time = O(K), Space = O(K)
	std::vector<size_t> H(K);
	std::vector<double> g(K);
	int k = 0;
	auto w_end = weights.end();
	for (auto w_it = weights.begin(); w_it != w_end; ++w_it) {
		g[k] = log_weights ? *w_it : log(*w_it);
		g[k] += -log(-log(unif(gen))); // rhs ~ G(0, 1)
		H[k] = k + 1;
		++k;
	}
	auto cmp = [& g](const size_t & l, const size_t & r)
		{return g[l] < g[r];};
	std::make_heap(H.begin(), H.end(), cmp);

	// Fill result with 'size' indexes having largest g
	// Time = O(size * log(K)), Space = O(size)
	IntegerVector res(size);
	auto res_end = res.end();
	for (auto res_it = res.begin(); res_it != res_end; ++res_it) {
		*res_it = H.back();
		std::pop_heap(H.begin(), H.end(), cmp);
		H.pop_back();
	}

	return res;
} // gsample_wor

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
