# One-sided empirical Bernstein CS for Winkler scores (Proposition 4)

Applies the Winkler normalisation and constructs a one-sided upper
confidence sequence for the mean Winkler score W_t = (1/t)\*sum w_i. The
CS takes the form `(-Inf, U_t]`, valid uniformly over all t \>= 1.

## Usage

``` r
winkler_cs(
  p,
  q,
  y,
  alpha = 0.05,
  base_score = log_score,
  v_opt = 10,
  lower_bound = NULL
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

  Numeric \> 0. Optimal intrinsic time. Default: 10.

- lower_bound:

  Numeric or NULL. Analytical lower bound on w_i for two-sided CS via
  Corollary 2. If NULL (default), returns one-sided CS only. If
  supplied, must satisfy w_i \>= lower_bound for all i almost surely.

## Value

data.frame with columns t, estimate, lower, upper. lower = -Inf always
(one-sided) unless lower_bound is supplied.

## Details

Scale convention: Winkler score bounded above by 1, so c/2 = 1, c = 2.
This is hardcoded — do not change c without re-deriving the bound.

## Interpretation

If `U_t < 0` for some `t`, this is time-uniform evidence that forecaster
1 (`p`) is worse than forecaster 2 (`q`) on average — i.e. a rejection
is evidence against `p`, not for it. More generally, `W_t > 0` suggests
`p` outperforms `q`; `W_t < 0` suggests `q` outperforms `p`.

## Examples

``` r
p <- c(0.7, 0.6, 0.8, 0.65)
q <- c(0.5, 0.7, 0.6, 0.55)
y <- c(1, 1, 0, 1)
winkler_cs(p, q, y, alpha = 0.05)
#>   t   estimate lower    upper
#> 1 1  1.0000000  -Inf 9.539781
#> 2 2  0.2320815  -Inf 5.748373
#> 3 3 -0.6484193  -Inf 4.538189
#> 4 4 -0.2363144  -Inf 3.988530
```
