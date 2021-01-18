# Argument checking for gsample()
argcheck <- function(n,
		     size,
		     replace,
		     prob,
		     algorithm
		     )
{
	if (!is.numeric(n) || length(n) != 1)
		stop("'n' must be a length one positive integer.")
	if (size < 0)
		stop("'n' must be greater than zero.")

	if (!is.numeric(size) || length(size) != 1)
		stop("'size' must be a length one positive integer.")
	if (size < 0)
		stop("sample size must be greater than zero.")

	if (!is.logical(replace) || length(replace) != 1)
		stop("'replace' must be a length one logical")
	if (is.na(replace))
		stop("'replace' must be either 'TRUE' or 'FALSE'.")

	if (!replace && n < size)
		stop("cannot take a sample larger than the population",
		     " when 'replace = FALSE'")

	if (!is.null(prob) &&
	    (!is.numeric(prob) || length(prob) != n) )
		stop("'prob' must be a numeric vector length 'n'.")

	if (!is.null(algorithm) &&
	    !identical(algorithm, "introselect") &&
	    !identical(algorithm, "partial_heap")
	    ) stop("'algorithm' must be either 'NULL',",
	           "or \"introselect\" or \"partial_heap\""
	           )
}
