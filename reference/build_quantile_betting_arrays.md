# Build 3D Parameter Arrays for Quantile Betting

Pre-computes the dynamic, pair-specific bounding arrays (`c_array`) and
betting fractions (`lambda_array`) required to evaluate the Sequential
Model Confidence Set for quantile forecasts under the strong null
hypothesis.

## Usage

``` r
build_quantile_betting_arrays(forecasts, scores, tau, eps = 1e-08)
```

## Arguments

- forecasts:

  A \\T \times m\\ matrix of raw quantile forecasts.

- scores:

  A \\T \times m\\ matrix of positively-oriented tick-loss scores.

- tau:

  Numeric scalar in `(0, 1)`. The quantile level.

- eps:

  Numeric. Safeguard against division by zero. Default: `1e-8`.

## Value

A list containing two \\T \times m \times m\\ numeric arrays: `c_array`
and `lambda_array`.

## Note

**Scale Translation:** This function assumes `forecasts` and `scores`
are evaluated on the raw, linear scale. To replicate the exact log-scale
bounds used in the Arnold et al. (2026) Covid-19 case study, the
forecast matrix and outcomes must be log-transformed prior to passing
them to this pipeline.

## Examples

``` r
set.seed(3)
fcsts <- matrix(runif(150), nrow = 50, ncol = 3)
y <- rbinom(50, 1, 0.5)
scores <- matrix(0, nrow = 50, ncol = 3)
for(i in 1:3) scores[, i] <- tick_loss(fcsts[, i], y, tau = 0.5)

arrays <- build_quantile_betting_arrays(fcsts, scores, tau = 0.5)
dim(arrays$c_array) # 50 x 3 x 3
#> [1] 50  3  3
```
