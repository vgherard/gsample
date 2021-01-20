#include "gsample.h"
using namespace Rcpp;

class Comparison {
	const std::vector<double> & g_;
public:
	Comparison(const std::vector<double> & g) : g_(g) {}
	bool operator() (const size_t &l, const size_t & r)
	{return g_[l] > g_[r];}
};

// [[Rcpp::export]]
IntegerVector gsample_introselect(size_t n,
                                  size_t size,
                                  NumericVector prob
                                          )
{
	// Generate  g[k] = prob[k] / E, with E ~ Exp(rate = 1)
	// T ~ O(n)
	// S ~ O(n)
	std::vector<double> g(n);
	for (size_t k = 0; k < n; k++) {
	 	g[k] = prob[k] / R::rexp(1.0);
	}
	Comparison cmp(g);
	// Select the 'size' indexes 'k' with highest 'g[k]' with Introselect
	// T ~ O(n)
	// S ~ O(n)
	// TODO: can we avoid filling the vector H with all indexes 0:(n - 1),
	// avoiding some of the extra space S ~ O(n)?
	std::vector<size_t> H(n);
	std::iota(H.begin(), H.end(), 0);
	std::nth_element(H.begin(), H.begin() + size, H.end(), cmp);

	// Fill result with 'size' indexes k with largest g[k] - equivalent to
	// sampling w/o replacement (Gumbel-Max trick).
	// T ~ O(size)
	// S ~ O(1)
	IntegerVector res(size);
	auto res_end = res.end();
	size_t k = 0;
	for (auto res_it = res.begin(); res_it != res_end; ++res_it) {
		*res_it = H[k] + 1; // transform to one-based indexing
		k++;
	}

	// Total time complexity T ~ O(n) + O(size) ~ O(n)
	// Total (extra) space complexity S ~ O(n)
	return res;
} // gsample_wor

struct IndexScorePair {
	size_t index;
	double score;
	IndexScorePair (size_t i, double s) : index(i), score(s) {}
	friend bool operator>(const IndexScorePair& l, const IndexScorePair & r)
		{return l.score > r.score;}
};

// [[Rcpp::export]]
IntegerVector gsample_partial_heap(size_t n,
                                   size_t size,
                                   NumericVector prob
                                           )
{
	// Generate  g[k] = prob[k] / E, with E ~ Exp(rate = 1)
	// Keep a small min-heap of size 'size' with the largest 'size' values
	// (and corresponding indexes) obtained so far.
	std::priority_queue<
		IndexScorePair,
		std::vector<IndexScorePair>,
		std::greater<IndexScorePair>
		> H;
	double g;
	// Initialize the heap with first 'size' elements.
	// T ~ O(size * log(size))
	// S ~ O(S)
	for (size_t k = 0; k < size; k++) {
		H.push(IndexScorePair(k, prob[k] / R::rexp(1.0)));
	}
	// Update the heap iff g[k] > H.min();
	// T ~ O(N) [generate g[k]'s] + O(N * log(size)) [update heap]
	// S ~ O(1)
	for (size_t k = size; k < n; k++) {
		g = prob[k] / R::rexp(1.0);
		if (g > H.top().score) {
			H.pop();
			H.push(IndexScorePair(k, g));
		}
	}

	// Fill result with 'size' indexes k with largest g[k] - equivalent to
	// sampling w/o replacement (Gumbel-Max trick).
	// T ~ O(size * log(n))
	// S ~ O(1)
	IntegerVector res(size);
	auto res_end = res.end();
	size_t k = 0;
	// T = O(size * log(size))
	for (auto res_it = res.begin(); res_it != res_end; ++res_it) {
		*res_it = H.top().index + 1;
		H.pop();
	}

	return res;
} // gsample_wor
