# E-process for Winkler scores (Proposition 4 + Theorem 3)

Tests whether the mean Winkler score W_t \>= 0 for all t. A rejection
provides time-uniform evidence that forecaster 1 (p) is worse than
forecaster 2 (q) under the base scoring rule.

## Usage

``` r
winkler_etest(
  p,
  q,
  y,
  alpha = 0.05,
  base_score = log_score,
  v_opt = 10,
  clip_max = 1e+07
)
```

## Arguments

- p:

  Numeric vector in (0,1). Forecasts from model 1.

- q:

  Numeric vector in (0,1). Forecasts from model 2.

- y:

  Numeric vector containing only 0 and 1. Binary outcomes.

- alpha:

  Numeric in (0,1). Significance level. Default: 0.05.

- base_score:

  Function. Underlying scoring rule. Default: log_score.

- v_opt:

  Numeric \> 0. Default: 10.

- clip_max:

  Numeric. Maximum e-process value before clipping. Default: 1e7.

## Value

data.frame with columns t, e, log_e.

## Rejection rule

Reject at level `alpha` when `e >= 1 / alpha`; this provides
time-uniform evidence that `p` is worse than `q`.

## Examples

``` r
p <- c(0.7, 0.6, 0.8, 0.65)
q <- c(0.5, 0.7, 0.6, 0.55)
y <- c(1, 1, 0, 1)
winkler_etest(p, q, y, alpha = 0.05)
#>   t         e      log_e
#> 1 1 0.4487869 -0.8012071
#> 2 2 0.3320708 -1.1024071
#> 3 3 0.3175664 -1.1470682
#> 4 4 0.2220444 -1.5048778
```
