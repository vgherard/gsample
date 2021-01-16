# Argument checking for gsample()
argcheck <- function(size, weights, replace, log_weights, map) {
	if (!is.numeric(size) || length(size) != 1)
		stop("'size' must be a length one positive integer.")
	if (size < 0)
		stop("sample size must be greater than zero.")
	if (!is.numeric(weights) || length(weights) == 0)
		stop("'weights' must be a numeric vector of positive length.")
	if (!is.logical(log_weights) || length(log_weights) != 1)
		stop("'log_weights' must be a length one logical")
	if (is.na(log_weights))
		stop("'log_weights' must be either 'TRUE' or 'FALSE'.")
	if (!log_weights && any(weights < 1))
		stop("'weights' must be positive if 'log_weights' is 'FALSE'.")
	if (!is.logical(replace) || length(replace) != 1)
		stop("'replace' must be a length one logical")
	if (is.na(replace))
		stop("'replace' must be either 'TRUE' or 'FALSE'.")
	if (!replace && length(weights) < size)
		stop("cannot take a sample larger than the population",
		     " when 'replace = FALSE'"
		)
	if (!is.null(map))
		if (!is.vector(map) || length(map) != length(weights))
			stop("'map' must be either NULL or a vector of length",
			     " 'length(weight)'"
			)
}
