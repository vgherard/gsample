#' Efficient weighted sampling without replacement
#'
#' These functions offer a drop-in replacement for \link[base]{sample}, with
#' considerably better performance for the case of weighted sampling without
#' replacement (both from the speed and memory point of view).
#' The interface of \code{gsample} and \code{gsample.int} is essentially
#' the same of the corresponding \code{base} functions, so that they can be
#' replaced in \code{base} R code with little (if any) modification.
#'
#' @author Valerio Gherardi
#' @md
#'
#' @param x a vector of one or more elements from which to choose.
#' @param n length one integer. The total number of categories to choose from.
#' See ‘Details’.
#' @param size length one integer. Size of sample.
#' @param replace TRUE or FALSE. Sample with replacement? Defaults to
#' \code{FALSE}.
#' @param prob either \code{NULL}, or a numeric vector of length \code{n},
#' containing probability weights for sampling the various classes.
#' If \code{NULL} (default), sampling is performed assuming uniform
#' probabilities.
#' @param algorithm either \code{NULL}, \code{"introselect"} or
#' \code{"partial_heap"}. The default (\code{NULL}), uses a rough estimate
#' of the relative time complexities to select between the two algorithms.
#' See ‘Details’.
#' @return an integer vector of class indexes for \code{gsample.int}, a vector
#' of the same type of \code{x} for \code{gsample}.
#' @examples
#' set.seed(840)
#' gsample(letters, 5, prob = runif(length(letters)))
#' gsample.int(10, 3, prob = 10:1)
#' @details
#' These functions are meant to replace \code{base::sample()} and
#' \code{base::sample.int()} for weighted sampling without replacement, for
#' which the \code{base} implementation is inefficient. For uniform
#' sampling, or sampling with replacement, \code{gsample} simply calls the
#' \code{base} functions.
#'
#' The APIs of \code{gsample()} and \code{gsample.int()} are almost identical to
#' the ones of \code{base::sample()} and \code{base::sample.int()},
#' respectively, with the following differences:
#'
#' - The argument \code{useHash} for
#' \code{base::sample.int(replace = FALSE, prob = NULL)} is not provided.
#' - An additional \code{algorithm} argument.
#'
#' The basic arguments \code{x}, \code{n}, \code{size}, \code{replace} and
#' \code{prob} are documented in \link[base]{sample}, to which we refer. Here
#' we describe the additional argument \code{algorithm}.
#'
#' \code{gsample} supports two algorithms, \code{"introselect"} and
#' \code{"partial_heap"} with different space and time
#' complexities for weighted sampling without replacement. If the argument
#' \code{algorithm} is left as default (\code{NULL}), \code{gsample()}
#' tentatively selects the fastest algorithm based on a rough estimate of the
#' two running times.
#' \code{algorithm = "introselect"} has time complexity \emph{T = O(n)}, and
#' space complexity \emph{S = O(n)}, whereas \code{algorithm = "partial_heap"}
#' has time complexity \emph{T = O(n * log(size))}, and space complexity
#' \emph{S = O(size)}. The running time of \code{"introselect"} is largely
#' independent of the actual value of \code{prob}, whereas \code{"partial_heap"}
#' can be get some speed-up (speed-down) if \code{prob} is sorted in decreasing
#' (increasing) order.
#'
#' Despite its worst asymptotic performance, \code{"partial_heap"} is typically
#' faster for small sample sizes (of less than 100, say), in which case
#' it is also much cheaper from the memory point of view.
#'
#' @name gsample
#'

#' @rdname gsample
#' @export
gsample.int <- function(n,
			size = n,
			replace = FALSE,
			prob = NULL,
			algorithm = NULL
			)
{
	argcheck(n, size, replace, prob, algorithm)
	if (is.null(algorithm))
		algorithm <- default_algorithm(n, size)

	if (replace || is.null(prob)) {
		index <- sample.int(n, size, replace, prob)
	} else {
		if (algorithm == "introselect") {
			index <- gsample_introselect(n, size, prob)
		} else {
			index <- gsample_partial_heap(n, size, prob)
		}
	}

	return(index)
}

#' @rdname gsample
#' @export
gsample <- function(x,
		    size,
		    replace = FALSE,
		    prob
		    )
{
	if (length(x) == 1L && is.numeric(x) && is.finite(x) && x >= 1) {
		if (missing(size))
			size <- x
		gsample.int(x, size, replace, prob)
	} else {
		if (missing(size))
			size <- length(x)
		x[gsample.int(length(x), size, replace, prob)]
	}

}
