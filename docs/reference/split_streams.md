# Split a sequence into h interleaved lag streams

For lag `h`, the k-th stream (`k = 1, ..., h`) contains indices \\\\k,\\
k+h,\\ k+2h,\\ \ldots\\\\, following the CR23 convention.

## Usage

``` r
split_streams(xs, h)
```

## Arguments

- xs:

  Numeric vector. Score differences hat_delta_t.

- h:

  Integer \>= 1. Lag (number of steps ahead).

## Value

List of length h. Each element is a numeric vector containing the score
differences for that stream.

## Examples

``` r
  split_streams(1:10, h = 3)
#> [[1]]
#> [1]  1  4  7 10
#> 
#> [[2]]
#> [1] 2 5 8
#> 
#> [[3]]
#> [1] 3 6 9
#> 
  # stream 1: indices 1, 4, 7, 10
  # stream 2: indices 2, 5, 8
  # stream 3: indices 3, 6, 9
```
