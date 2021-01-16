context("argcheck")

# A set of valid arguments
l <- list(n = 3, size = 1, replace = F, weights = c(1, 1, 1), log_weights = F)

test_that("valid arguments do not throw any error", {
	expect_error(do.call(argcheck, l), NA)
})

test_that("invalid 'n' errors", {
	invalid_n <- list("10", 0, -1, function() {})
	lapply(invalid_n, function(n) {
		l[["n"]] <- n
		expect_error(do.call(argcheck, l))
	})
})

test_that("invalid 'size' errors", {
	invalid_size <- list("10", c(1, 2), -1, 4)
	lapply(invalid_size, function(size) {
	       	l[["size"]] <- size
	       	expect_error(do.call(argcheck, l))
	       })
})

test_that("invalid 'replace' errors", {
	invalid_replace <- list("a", NA)
	lapply(invalid_replace, function(replace) {
		l[["replace"]] <- replace
		expect_error(do.call(argcheck, l))
	})
})

test_that("invalid 'weights' errors", {
	invalid_weights <- list("a", numeric(), c(-1, -2, -3), c(1, 2))
	lapply(invalid_weights, function(weights) {
		l[["weight"]] <- weights
		expect_error(do.call(argcheck, l))
	})

	expect_error(
		argcheck(3, 1, F, weights = c(-1, -3, -2), log_weights = T),
		NA)
})

test_that("invalid 'log_weights' errors", {
	invalid_log_weights <- list("a", NA)
	lapply(invalid_log_weights, function(log_weights) {
		l[["log_weights"]] <- log_weights
		expect_error(do.call(argcheck, l))
	})
})
