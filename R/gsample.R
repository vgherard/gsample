#' Efficient weighted sampling without replacement
#'
#' Sample without replacement using the Gumbel-Max trick
#' (c.f. \url{https://arxiv.org/pdf/1903.06059.pdf}).
#
#' @author Valerio Gherardi
#' @md
#'
#' @param n length one integer. The total number of categories to choose from;
#' See ‘Details’.
#' @param size length one integer. Size of sample.
#' @param replace TRUE or FALSE. Sample with replacement? Defaults to
#' \code{FALSE}.
#' @param weights either \code{NULL}, or a numeric vector of length \code{n},
#' containing the (unnormalized) probabilities, or the (unnormalized)
#' log-probabilities for sampling categories
#' (depending on the value of \code{log_weights} argument, see below).
#' If \code{NULL} (default), sampling is performed assuming uniform
#' probabilities.
#' @param log_weights TRUE or FALSE. Should the values given in \code{weights}
#' be interpreted as (unnormalized) log-probabilities? Defaults to \code{FALSE}.
#' @return an integer vector if \code{map} is \code{NULL}, otherwise a vector
#' of the same type as \code{map}.
#' @examples
#' set.seed(840)
#' size <- 5
#' weights <- rnorm(length(letters), sd = 10)
#' gsample(size = 5, weights, map = letters)
#' @details
#'
#' @name gsample
#'

#' @rdname gsample
#' @export
gsample.int <- function(n,
			size = n,
			replace = FALSE,
			weights = NULL,
			log_weights = FALSE
			)
{
	argcheck(n, size, replace, weights, log_weights)

	if (replace || is.null(weights)) {
		if (log_weights)
			prob <- exp(weights)
		index <- sample.int(n, size, replace, prob)
	} else {
		index <- gsample_wor(n, size, weights, log_weights)
	}

	return(index)
}

#' @rdname gsample
#' @export
gsample <- function(x,
		    size,
		    replace = FALSE,
		    weights = NULL,
		    log_weights = FALSE
		    )
{
	if (!is.vector(x) && length(x) >= 1)
		stop("'x' must be a vector of positive length.")
	x[gsample.int(length(x), size, replace, weights, log_weights)]
}
