# Negated CRPS for normal predictive distributions

Computes the Continuous Ranked Probability Score for a normal predictive
distribution using
[`scoringRules::crps_norm()`](https://rdrr.io/pkg/scoringRules/man/scores_norm.html)
and negates it so that higher values are better.

## Usage

``` r
crps_normal(mu, sigma, x)
```

## Arguments

- mu:

  Numeric vector. Location parameters (conditional means).

- sigma:

  Numeric vector. Scale parameters (conditional SDs, \> 0).

- x:

  Numeric vector. Realised observations.

## Value

Numeric vector of CRPS values in `(-Inf, 0]` (negated loss).

## Details

Calls `scoringRules::crps_norm(y = x, mean = mu, sd = sigma)` and
negates. Use for GARCH(1,1)-norm forecasts where mu is the conditional
mean and sigma is the conditional standard deviation.

## Examples

``` r
if (requireNamespace("scoringRules", quietly = TRUE)) {
  crps_normal(mu = c(0, 1), sigma = c(1, 2), x = c(0.2, 1.3))
}
#> [1] -0.2495997 -0.4853088
```
