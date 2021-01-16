#' Efficient sampling from discrete probability distributions
#'
#' Sample from a discrete probability distribution
#' using the Gumbel-Max trick (c.f. \url{https://arxiv.org/pdf/1903.06059.pdf}).
#
#' @author Valerio Gherardi
#' @md
#'
#' @param size length one integer. Size of sample.
#' @param weights a numeric vector, containing either (unnormalized)
#' probabilities or (unnormalized) log-probabilities of categories
#' (c.f. description of \code{log_weights} argument).
#' @param replace TRUE or FALSE. Sample with replacement? Defaults to
#' \code{FALSE}.
#' @param log_weights TRUE or FALSE. Are the \code{weights} given as
#' (unnormalized) log-probabilities? Defaults to \code{FALSE}.
#' @param map either \code{NULL} or a vector of length \code{length(weights)}.
#' If \code{NULL}, the returned value is an integer vector containing the
#' indexes of the sampled classes, otherwise the elements of \code{map}
#' corresponding to such indexes.
#' @return an integer vector if \code{map} is \code{NULL}, otherwise a vector
#' of the same type as \code{map}.
#'
#' @export
gsample <- function(size,
		    weights,
		    replace = FALSE,
		    log_weights = FALSE,
		    map = NULL
		    )
{
	argcheck(size, weights, replace, log_weights, map)

	if (replace) {
		index <- gsample_wr(size, weights, log_weights)
	} else {
		index <- gsample_wor(size, weights, log_weights)
	}

	if (is.null(map)) {
		return(index)
	} else {
		return(map[index])
	}
}
