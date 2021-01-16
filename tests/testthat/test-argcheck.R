context("argcheck")

# A set of valid arguments
size <- 1
weights <- c(1, 1, 1)
replace <- FALSE
log_weights <- FALSE
map <- NULL

test_that("valid arguments do not throw any error", {
	expect_error(argcheck(size, weights, replace, log_weights, map), NA)
})

test_that("invalid 'size' errors", {
	expect_error(
		argcheck(size = "10", weights, replace, log_weights, map)
		)
	expect_error(
		argcheck(size = c(1, 2), weights, replace, log_weights, map)
		)
	expect_error(
		argcheck(size = -1, weights, replace, log_weights, map)
	)
})

test_that("invalid 'weights' errors", {
	expect_error(
		argcheck(size, weights = "a", replace, log_weights, map)
	)
	expect_error(
		argcheck(size, weights = numeric(), replace, log_weights, map)
	)
	expect_error(
		argcheck(size, weights = -1, replace, log_weights,  map)
	)
	expect_error(
		argcheck(size, weights = -1, replace, log_weights = T, map),
	NA)
})

test_that("invalid 'replace' errors", {
	expect_error(
		argcheck(size, weights, replace = "a", log_weights, map)
	)
	expect_error(
		argcheck(size, weights, replace = NA, log_weights, map)
	)
	expect_error(
		argcheck(size, weights, replace = TRUE, log_weights = T, map),
		NA)
})

test_that("invalid 'log_weights' errors", {
	expect_error(
		argcheck(size, weights, replace, log_weights = "a", map)
	)
	expect_error(
		argcheck(size, weights, replace, log_weights = NA, map)
	)
	expect_error(
		argcheck(size, weights, replace, log_weights = T, map),
		NA) # A valid use case, since all(weights > 0)
})

test_that("invalid 'map' errors", {
	expect_error(
		argcheck(size, weights, replace, log_weights, map = c(1, 2))
	) # length(map) does not match length(weights)
	expect_error(
		argcheck(size, weights, replace, log_weights = NA, map = print)
	) # map is not a vector
})
