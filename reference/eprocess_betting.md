# Betting-style e-process for the strong null hypothesis

Implements the product-form test martingale \$\$E_t = \prod\_{r=1}^{t}
(1 + \lambda_r \hat\delta_r)\$\$ for testing the strong null \\H_0^s(p,
q): \delta_t \le 0\\ for all t.

## Usage

``` r
eprocess_betting(scores1, scores2, c_t, lambda_t = NULL, clip_max = 1e+07)
```

## Arguments

- scores1:

  Numeric vector. Scores S(p_t, y_t) for forecaster 1.

- scores2:

  Numeric vector. Scores S(q_t, y_t) for forecaster 2.

- c_t:

  Numeric scalar or vector (same length as scores) of predictable bounds
  such that \|scores1 - scores2\| \<= c_t / 2 almost surely at every
  step.

- lambda_t:

  Optional numeric vector of predictable betting fractions in
  `[0, 1/c_t]`. If `NULL` (default), uses the fixed fraction
  `lambda_t = 1 / (2 * c_t)`.

- clip_max:

  Numeric. Maximum e-process value before clipping. Default: 1e7.

## Value

data.frame with columns t, e_pq, e_qp, log_e_pq, log_e_qp.
