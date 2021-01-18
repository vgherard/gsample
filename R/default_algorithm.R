# Make a rough estimate of time-complexity for both Introselect and PartialHeap
# algorithms, return the best one.
# The coefficient 'a' and 'b' are rough estimates and the functional forms are
# very approximate
default_algorithm <- function(n, size) {
	a <- 5.665116e-05
	b <- c(7.572343e-06, 6.858951e-05)
	t_introsel <- a * n
	t_partial_heap <- (b[[1]] * n + b[[2]] * size) * log(size)
	ifelse(t_introsel < t_partial_heap, "introselect", "partial_heap")
}
