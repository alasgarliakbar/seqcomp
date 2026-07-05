# Score difference bounds -\> sub-Gaussian / sub-exponential scale

Given score-difference bounds `[lo, hi]`, computes the two scale
constants used elsewhere in `seqcomp`:

- `c_thm1` = `(hi - lo) / 2` — sub-Gaussian scale for Theorem 1, where
  `|delta_i| <= c_thm1`.

- `c_thm23` = `hi - lo` — sub-exponential scale for Theorems 2 & 3,
  where `|delta_i| <= c_thm23 / 2`.

## Usage

``` r
score_diff_scales(lo, hi)
```

## Arguments

- lo:

  Numeric. Lower bound of score difference (usually a - b).

- hi:

  Numeric. Upper bound of score difference (usually b - a).

## Value

Named list with elements c_thm1 and c_thm23.

## Details

Both conventions bound the same quantity: after centering, `delta_i`
lies in `[-(hi-lo)/2, (hi-lo)/2]`, so `max|delta_i| = (hi-lo)/2`, which
equals both `c_thm1` and `c_thm23 / 2`.

## Examples

``` r
score_diff_scales(lo = -1, hi = 1)
#> $c_thm1
#> [1] 1
#> 
#> $c_thm23
#> [1] 2
#> 
```
