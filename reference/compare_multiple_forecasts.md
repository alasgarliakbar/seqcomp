# Compare Multiple Sequential Forecasters (SMCS)

Evaluates an arbitrary number of candidate forecasters simultaneously,
constructing Sequential Model Confidence Sets (SMCS) that maintain
family-wise error rate control over time.

## Usage

``` r
compare_multiple_forecasts(
  forecasts,
  outcomes,
  scoring_rule = c("brier", "spherical", "tick"),
  cs_method = c("bernstein", "hoeffding"),
  tau = NULL,
  alpha = 0.05,
  v_opt = 10,
  clip_max = 1e+07
)
```

## Arguments

- forecasts:

  A \\T \times m\\ matrix of forecasts. For binary/categorical
  probability forecasts, these should be matrices of probabilities. For
  quantile forecasts, these should be raw predicted quantiles. *Note:*
  to replicate the log-scale bounds of the Arnold et al. (2026) Covid-19
  study, pass log-transformed forecasts and outcomes.

- outcomes:

  A numeric vector of \\T\\ realised outcomes.

- scoring_rule:

  Character. Scoring rule used to compare forecasts. Currently supports
  `"brier"`, `"spherical"`, and `"tick"`.

- cs_method:

  Character. Confidence sequence method for the weak null: `"bernstein"`
  or `"hoeffding"`. Default is `"bernstein"`.

- tau:

  Numeric in `(0, 1)`. The quantile level. Required only if
  `scoring_rule = "tick"`.

- alpha:

  Numeric in `(0, 1)`. Family-wise significance level. Default is
  `0.05`.

- v_opt:

  Numeric \> 0. Intrinsic time at which the weak-null confidence
  sequence is tuned to be tightest. Default is `10`.

- clip_max:

  Numeric. Maximum e-process value before clipping in the strong-null
  test. Default is `1e7`.

## Value

A list containing:

- `scores`:

  A \\T \times m\\ matrix of evaluated pointwise scores.

- `smcs_strong`:

  A \\T \times m\\ logical matrix tracking inclusion in the strong-null
  SMCS over time (permanent exclusions).

- `smcs_weak`:

  A \\T \times m\\ logical matrix tracking inclusion in the weak-null
  SMCS over time (models can exit and re-enter). Currently `NULL` for
  `"tick"` loss.

## Details

This is a high-level wrapper that automates pointwise score calculation,
boundary generation, and multiplicity corrections via
[`smcs_strong()`](https://alasgarliakbar.github.io/seqcomp/reference/smcs_strong.md)
and
[`smcs_weak()`](https://alasgarliakbar.github.io/seqcomp/reference/smcs_weak.md).
For conditionally bounded rules like `"tick"` loss, it automatically
builds the dynamic 3D arrays required for adaptive betting.

## Examples

``` r
set.seed(42)
T_sim <- 100
y <- rbinom(T_sim, 1, 0.5)

# Create 3 forecasters:
# M1 is a perfect oracle (always predicts the true y)
# M2 is slightly noisy (adds small uniform noise to y)
# M3 is an anti-oracle (predicts the exact opposite of y)
fcsts <- matrix(NA, nrow = T_sim, ncol = 3)
fcsts[, 1] <- y
fcsts[, 2] <- abs(y - runif(T_sim, 0, 0.1))
fcsts[, 3] <- 1 - y
colnames(fcsts) <- c("M1", "M2", "M3")

out <- compare_multiple_forecasts(fcsts, y, scoring_rule = "brier")

# Print the object to see exclusions (M3 will be dropped rapidly)
out
#> <seqcomp multi-model comparison>
#>   3 models, 100 time steps, alpha = 0.05, scoring rule = 'brier'
#> 
#> -- Strong-null SMCS (Permanent Exclusion) --
#>  model status_at_T first_dropped
#>     M1    included             -
#>     M2    included             -
#>     M3    excluded            19
#>    final set size: 3 -> 2
#> 
#> -- Weak-null SMCS (Dynamic Re-entry) --
#>  model status_at_T first_dropped
#>     M1    included             -
#>     M2    included             -
#>     M3    excluded            15
#>    final set size: 3 -> 2
#> 
#> Use `x$smcs_strong` / `x$smcs_weak` for full inclusion matrices, or `x$scores` for pointwise scores.

# View how the set sizes shrink over time
summary(out)
#>     t strong_set_size weak_set_size
#> 1   1               3             3
#> 2  25               2             2
#> 3  50               2             2
#> 4  75               2             2
#> 5 100               2             2
```
