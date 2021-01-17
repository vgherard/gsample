#' Efficient weighted sampling without replacement
#'
#' Weighted sampling without replacement using the Gumbel-Max trick
#' (c.f. \url{https://arxiv.org/pdf/1903.06059.pdf}).
#
#' @author Valerio Gherardi
#' @md
#'
#' @param x a vector of one or more elements from which to choose.
#' @param n length one integer. The total number of categories to choose from;
#' See ‘Details’.
#' @param size length one integer. Size of sample.
#' @param replace TRUE or FALSE. Sample with replacement? Defaults to
#' \code{FALSE}.
#' @param prob either \code{NULL}, or a numeric vector of length \code{n},
#' containing probability weights for sampling the various classes.
#' If \code{NULL} (default), sampling is performed assuming uniform
#' probabilities.
#' @return an integer vector of class indexes for \code{gsample.int}, a vector
#' of the same type of \code{x} for \code{gsample}.
#' @examples
#' set.seed(840)
#' gsample(letters, 5, prob = runif(length(letters)))
#' gsample.int(10, 3, prob = 10:1)
#' @name gsample
#'

#' @rdname gsample
#' @export
gsample.int <- function(n,
			size = n,
			replace = FALSE,
			prob = NULL
			)
{
	argcheck(n, size, replace, prob)

	if (replace || is.null(prob)) {
		index <- sample.int(n, size, replace, prob)
	} else {
		index <- gsample_wor(n, size, prob)
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
