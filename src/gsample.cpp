#include "gsample.h"
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector gsample_wo_repl(int size, NumericVector phi) {
	std::random_device rd;
	std::default_random_engine gen(rd());
	std::uniform_real_distribution<> unif(0, 1);

	// Build heap of (k, g) pairs, with g = phi[k] + (Gumbel noise) as keys
	int K = phi.size(); // Total number of classes
	std::priority_queue<IndexScorePair> Q;
	for (int k = 0; k < K; k++) {
		double g = phi[k] - log(-log(unif(gen))); // g ~ G(0, 1)
		Q.push(IndexScorePair(k, g)); // 'g' is the priority key
	}

	// Fill result with 'size' top-scoring elements of Q
	IntegerVector res(size);
	auto itend = res.end();
	for (auto it = res.begin(); it != itend; ++it) {
		*it = Q.top().index + 1;
		Q.pop();
	}

	return res;
}

// [[Rcpp::export]]
IntegerVector gsample_w_repl(int size, NumericVector phi) {
	int K = phi.size();
	IntegerVector res(size);
	auto itend = res.end();
	for (auto it = res.begin(); it != itend; ++it) {
		// Add Gumbel noise to each phi[i] and take argmax
		NumericVector g = phi - log(-log(Rcpp::runif(K)));
		*it = which_max(g) + 1; // Prob(rhs == i) ~ exp(phi[i - 1])
	}
	return res;
}
