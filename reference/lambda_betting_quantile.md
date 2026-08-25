# Adaptive betting fraction for quantile-forecast strong-null tests

Implements the quantile-specific adaptive betting scheme of Arnold et
al. (2026), translating their log-scale loss convention to seqcomp's
positively-oriented scores.

## Usage

``` r
lambda_betting_quantile(p_t, q_t, tau, delta_hat_lag1 = NULL, eps = 1e-08)
```

## Arguments

- p_t:

  Numeric vector. Quantile forecasts of the first forecaster.

- q_t:

  Numeric vector. Quantile forecasts of the second forecaster.

- tau:

  Numeric scalar in (0, 1). The quantile level.

- delta_hat_lag1:

  Numeric vector. The *previous* step's score difference. Must have
  `delta_hat_lag1[1] = 0`.

- eps:

  Numeric. Safeguard against division by zero. Default: 1e-8.

## Value

A list with `c_t` and `lambda_t` vectors for
[`eprocess_betting()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_betting.md).

## Note

**Scale Translation:** This function assumes `p_t`, `q_t`, and
`delta_hat_lag1` are calculated on the raw, linear scale. To replicate
the exact log-scale bounds used in the Arnold et al. (2026) Covid-19
case study, the forecast vectors passed to this function must be
log-transformed prior to evaluation.
