# Negated CRPS for Student-t predictive distributions

Wrapper over
[`scoringRules::crps_t`](https://rdrr.io/pkg/scoringRules/man/scores_t.html).
Positively oriented: higher = better. The dof \> 2 constraint ensures
finite variance, which is required for the CRPS to be well-defined for
the t-distribution.

## Usage

``` r
crps_std(mu, sigma, dof, x)
```

## Arguments

- mu:

  Numeric vector. Location parameters (conditional means).

- sigma:

  Numeric vector. Scale parameters (conditional SDs, \> 0).

- dof:

  Numeric vector or scalar. Degrees of freedom (\> 2). May be scalar if
  constant across all observations (e.g. estimated once per rolling
  window).

- x:

  Numeric vector. Realised observations.

## Value

Numeric vector of CRPS values in `(-Inf, 0]` (negated loss).

## Details

Calls
`scoringRules::crps_t(y = x, df = dof, location = mu, scale = sigma)`
and negates. Use for GARCH(1,1)-std forecasts where dof is the estimated
degrees-of-freedom parameter from ugarchroll.

## Examples

``` r
if (requireNamespace("scoringRules", quietly = TRUE)) {
  crps_std(mu = c(0, 1), sigma = c(1, 2), dof = 5, x = c(0.2, 1.3))
}
#> [1] -0.2721493 -0.5310947
```
