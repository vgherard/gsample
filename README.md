
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gsample

<!-- badges: start -->

<!-- badges: end -->

`gsample` offers a drop-in replacement for the R `base::sample()`
functions for random sampling, with considerably better performance for
the case of weighted sampling without replacement (both from the speed
and memory point of view).

## Installation

You can install `gsample` from
[GitHub](https://github.com/vgherard/gsample) with:

``` r
# install.packages("devtools")
devtools::install_github("vgherard/gsample")
```

## Example

The `gsample` API is identical to the one of `base::sample()`:

``` r
library(gsample)
n <- 1e3
size <- 1e2
prob <- exp(rnorm(n, sd = 3))
gsample.int(n, size, prob = prob)
#>   [1] 898 905 225 504 298 893 166 430 990 464 683 993  13 404 229 862 379 494
#>  [19] 135 226 232  22 370 236 985 562 186 395 487 873 527 561 810 420 480 572
#>  [37] 891 120 919  40 556  42  43 799 161 479 878  48 258 400 577 896 398 511
#>  [55] 270 593 314 776 840 928 771 478 448 446 441   6 998 286 293  10 757 877
#>  [73] 941 545 939 434 662 115 583 602  63 148 542 674 986 126 317 975  33 794
#>  [91] 965 741 752 994  56 940 530  52 785 745
```

``` r
x <- letters
size <- 10
prob <- exp(rnorm(length(letters), sd = 3))
gsample(x, size, prob = prob)
#>  [1] "r" "z" "c" "y" "e" "f" "o" "u" "i" "l"
```

Here are some simple benchmark comparisons with `base::sample()`:

``` r
library(dplyr)
library(ggplot2)
set.seed(840)
n <- 1e6
prob <- rexp(n)

bm <- lapply(10 ^ (1:5), function(size) {
    bench::mark(
        gsample.int(n, size, prob = prob),
        sample.int(n, size, prob = prob),
        check = FALSE
        ) %>%
        select(expression, median) %>%
        mutate(expression = as.character(expression)) %>%
            mutate(size = size)
    }) 

bind_rows(bm) %>%
    ggplot(aes(x = size, y = 1e3 * median, colour = expression)) +
        geom_line() +
        scale_x_continuous(trans = "log10") +
        scale_y_continuous("median (ms)", trans = "log10")
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
