
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gsample

<!-- badges: start -->

<!-- badges: end -->

`gsample` allows efficient weighted sampling without replacement using
the Gumbel-Max trick.

## Installation

You can install `gsample` from
[GitHub](https://github.com/vgherard/gsample) with:

``` r
# install.packages("devtools")
devtools::install_github("vgherard/gsample")
```

## Example

The `gsample` API is similar to `base::sample()`:

``` r
library(gsample)
n <- 1e3
size <- 1e2
weights <- exp(rnorm(n, sd = 3))
gsample.int(n, size, weights = weights)
#>   [1] 857 821  80 521 336 884 309 663  77 930 204 870 721 994 972 254 778 230
#>  [19]  75 377 955 352 989 435 896  10 584  13 672 610 561 785 195 241 600 608
#>  [37] 508 202 751 299 371 171 796 495 964 165 529 918 931 287 664 190 613 177
#>  [55]  45 243 742  11 707 541 428 399 384 395 252 848 105  19 284 725 684 110
#>  [73] 693 157 536 479 648 512 376 984 301 780 777 351  29 792 294 576 845 268
#>  [91] 383 329 858 855 925 496 866 348 677 939
```

``` r
x <- letters
size <- 10
weights <- exp(rnorm(length(letters), sd = 3))
gsample(x, size, weights = weights)
#>  [1] "f" "n" "l" "i" "g" "t" "a" "b" "r" "p"
```

Here is a simple benchmark comparing to `base::sample()`:

``` r
library(bench)
library(dplyr)
n <- 1e6
size <- 1e5
weights <- exp(rnorm(n, sd = 3))

bench::mark(
gsample.int(n, size, weights = weights),
sample.int(n, size, prob = weights),
check = FALSE
) %>% select(min, median, mem_alloc, n_itr)
#> # A tibble: 2 x 3
#>        min   median mem_alloc
#>   <bch:tm> <bch:tm> <bch:byt>
#> 1 458.48ms 465.73ms     4.2MB
#> 2    3.23m    3.23m    11.8MB
```
