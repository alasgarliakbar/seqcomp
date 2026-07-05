# Lag-h e-process for sequential forecast comparison (Propositions 5 & 6)

For h-step-ahead forecasts, constructs an anytime-valid e-process by
stream splitting and combining h individual e-processes.

## Usage

``` r
eprocess_lag(
  scores1,
  scores2,
  h = 1,
  alpha = 0.05,
  c = 2,
  v_opt = 10,
  null = "pw",
  calibrate = TRUE,
  cal_strategy = "mixture"
)
```

## Arguments

- scores1:

  Numeric vector. Scores for forecaster 1.

- scores2:

  Numeric vector. Scores for forecaster 2.

- h:

  Integer \>= 1. Forecast lag. For h=1, reduces to standard eprocess() —
  no splitting.

- alpha:

  Numeric in (0,1). Significance level. Default: 0.05.

- c:

  Numeric \> 0. Sub-exponential scale. Default: 2.

- v_opt:

  Numeric \> 0. Default: 10.

- null:

  Character. Null hypothesis type:

  - `"pw"` — period-wise weak null (average combination).

  - `"w"` — standard weak null (minimum combination).

- calibrate:

  Logical. Apply p-to-e calibration. Default: TRUE.

- cal_strategy:

  Character. "mixture" (default) or "simple".

## Value

data.frame with columns t, e_pq, e_qp, log_e_pq, log_e_qp.

## Details

For h = 1: calls eprocess() directly and returns its output unchanged.

For h \>= 2: 1. Split xs into h streams 2. Compute e-process on each
stream independently 3. Combine using the appropriate null rule 4.
Convert to p-process, combine, calibrate back to e-process 5. Unroll to
original time scale

The period-wise ("pw") null is less conservative than the standard ("w")
null but tests a different (weaker) hypothesis. See CR23 Section 4.4.

## Examples

``` r
scores1 <- c(-0.04, -0.09, -0.01, -0.16, -0.04, -0.09)
scores2 <- c(-0.09, -0.16, -0.04, -0.25, -0.09, -0.16)
ep <- eprocess_lag(scores1, scores2, h = 2, alpha = 0.05)
head(ep)
#>   t         e_pq         e_qp  log_e_pq  log_e_qp
#> 1 1 2.220446e-16 2.220446e-16 -36.04365 -36.04365
#> 2 2 2.220446e-16 2.220446e-16 -36.04365 -36.04365
#> 3 3 2.220446e-16 2.220446e-16 -36.04365 -36.04365
#> 4 4 2.220446e-16 2.220446e-16 -36.04365 -36.04365
#> 5 5 2.220446e-16 2.220446e-16 -36.04365 -36.04365
#> 6 6 2.220446e-16 2.220446e-16 -36.04365 -36.04365
```
