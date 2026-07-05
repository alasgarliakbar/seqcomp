# Empirical Bernstein confidence sequence (Theorem 2, Choe & Ramdas 2023)

Constructs a variance-adaptive time-uniform CS using empirical intrinsic
time \\\hat{V}\_t = \sum\_{i=1}^t (\hat{\delta}\_i - \gamma_i)^2\\.
Tighter than the Hoeffding CS when score differences have low variance.

## Usage

``` r
cs_bernstein(
  scores1,
  scores2,
  alpha = 0.05,
  c = 2,
  v_opt = 10,
  boundary = "mixture",
  gammas = NULL,
  lcb_only = FALSE,
  ucb_only = FALSE
)
```

## Arguments

- scores1:

  Numeric vector. Scores for forecaster 1.

- scores2:

  Numeric vector. Scores for forecaster 2.

- alpha:

  Numeric in (0,1). Significance level. Default: 0.05.

- c:

  Numeric \> 0. Sub-exponential scale. The process must satisfy
  \|hat_delta_i\| \<= c/2. For score differences in `[a-b, b-a]`, c =
  b - a (e.g. c = 2 for Brier score differences in `[-1,1]`). Default:
  2.

- v_opt:

  Numeric \> 0. Optimal intrinsic time. Default: 10.

- boundary:

  Character. "mixture" (default, GE mixture) or "stitching" (polynomial
  stitched) or "hardcoded" (CR23 example formula, only valid for
  alpha=0.05, c=1).

- gammas:

  Numeric vector or NULL. Predictable centering sequence. If NULL,
  constructed as lagged running mean (default).

- lcb_only:

  Logical. If TRUE, return lower CS only: `[lower, +Inf)`. Requires
  finite lower bound on hat_delta_i; provide c.

- ucb_only:

  Logical. If TRUE, return upper CS only: `(-Inf, upper]`.

## Value

data.frame with columns t, estimate, lower, upper. lower = -Inf if
ucb_only = TRUE; upper = Inf if lcb_only = TRUE.

## Details

The CS is: \$\$C_t^{EB} = \hat{\Delta}\_t \pm
u\_{\alpha/2}^{GE}(\hat{V}\_t;\\ \rho, c) \\/\\ t\$\$

## Examples

``` r
scores1 <- c(-0.04, -0.09, -0.01, -0.16)
scores2 <- c(-0.09, -0.16, -0.04, -0.25)
cs_bernstein(scores1, scores2, alpha = 0.05)
#>   t estimate      lower     upper
#> 1 1     0.05 -10.070506 10.170506
#> 2 2     0.06  -5.000253  5.120253
#> 3 3     0.05  -3.323502  3.423502
#> 4 4     0.06  -2.470127  2.590127
```
