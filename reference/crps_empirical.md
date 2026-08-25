# Negated CRPS for empirical predictive distributions

Wrapper over
[`scoringRules::crps_sample`](https://rdrr.io/pkg/scoringRules/man/scores_sample_univ.html)
using method = "edf" (empirical distribution function, O(n log n) via
quantile decomposition of Laio & Tamea, 2007). Positively oriented:
higher = better.

## Usage

``` r
crps_empirical(ensemble, y)
```

## Arguments

- ensemble:

  Matrix. T x n matrix of forecast draws. Each row corresponds to one
  observation in y and comprises n simulation draws from the predictive
  distribution. For Historical Simulation: each row is the past WINDOW
  returns.

- y:

  Numeric vector of length T. Realised observations.

## Value

Numeric vector of length T of CRPS values in `(-Inf, 0]` (negated loss).

## Details

Requires `nrow(ensemble) == length(y)`. Passes `dat = ensemble` directly
to `crps_sample` which handles vectorisation over rows natively.
`show_messages` is suppressed as the "edf" method requires no bandwidth
selection messages.

## Examples

``` r
if (requireNamespace("scoringRules", quietly = TRUE)) {
  ensemble <- matrix(c(0.1, 0.2, 0.3, 1.0, 1.1, 1.2), nrow = 2, byrow = TRUE)
  crps_empirical(ensemble, y = c(0.25, 1.05))
}
#> [1] -0.03888889 -0.03888889
```
