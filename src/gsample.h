#ifndef GSAMPLE_H
#define GSAMPLE_H

// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include <queue>
#include <random>


struct IndexScorePair {
	int index;
	double score;
	IndexScorePair() : index(-1), score(0) {}
	IndexScorePair(int i, double s) : index(i), score(s) {}
	friend bool operator<(const IndexScorePair& l, const IndexScorePair& r)
		{ return l.score < r.score; }
};

#endif // GSAMPLE_H
