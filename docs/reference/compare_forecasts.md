# Compare Two Sequential Forecasters

Computes pointwise scores for two probabilistic forecasters and compares
them sequentially using confidence sequences and, when valid
finite-sample bounds are available, e-processes.

## Usage

``` r
compare_forecasts(
  p,
  q,
  y,
  scoring_rule = c("brier", "spherical", "log"),
  alpha = 0.05,
  cs_type = NULL,
  compute_cs = TRUE,
  compute_e = TRUE,
  v_opt = 10,
  boundary = "mixture",
  lcb_only = FALSE,
  ucb_only = FALSE,
  eps = 1e-15,
  clip_max = 1e+07
)
```

## Arguments

- p:

  Forecasts from forecaster 1. For binary outcomes, a numeric vector of
  probabilities for event `y = 1`. For categorical outcomes, a numeric
  matrix whose rows are probability vectors.

- q:

  Forecasts from forecaster 2, in the same format as `p`.

- y:

  Outcomes. For binary vector forecasts, a numeric vector in `{0, 1}`.
  For categorical matrix forecasts, integer class labels in
  `{1, ..., K}`.

- scoring_rule:

  Character. Scoring rule used to compare forecasts. Currently supports
  `"brier"`, `"spherical"`, and `"log"`.

- alpha:

  Numeric in `(0, 1)`. Significance level. Default is `0.05`.

- cs_type:

  Character or `NULL`. Confidence sequence type: `"bernstein"`,
  `"hoeffding"`, `"asymptotic"`, or `"none"`. If `NULL`, the wrapper
  uses `"bernstein"` for bounded scoring rules (`"brier"` and
  `"spherical"`) and `"asymptotic"` for `"log"`.

- compute_cs:

  Logical. If `TRUE`, compute a confidence sequence. Default is `TRUE`.

- compute_e:

  Logical. If `TRUE`, compute two one-sided e-processes. Default is
  `TRUE`. This is only allowed for bounded score differences under the
  current wrapper, namely `"brier"` and `"spherical"`.

- v_opt:

  Numeric \> 0. Intrinsic time at which the mixture boundary or
  e-process is tuned to be tightest. Default is `10`.

- boundary:

  Character. Boundary type passed to
  [`cs_hoeffding()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_hoeffding.md)
  or
  [`cs_bernstein()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_bernstein.md).
  Default is `"mixture"`.

- lcb_only:

  Logical. If `TRUE`, compute a lower one-sided empirical Bernstein CS.
  Only used when `cs_type = "bernstein"`.

- ucb_only:

  Logical. If `TRUE`, compute an upper one-sided empirical Bernstein CS.
  Only used when `cs_type = "bernstein"`.

- eps:

  Numeric. Probability floor passed to
  [`log_score()`](https://alasgarliakbar.github.io/seqcomp/reference/log_score.md)
  when `scoring_rule = "log"`. Default is `1e-15`.

- clip_max:

  Numeric. Maximum e-process value before clipping. Passed to
  [`eprocess()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess.md).
  Default is `1e7`.

## Value

A `data.frame` with one row per time point and columns:

- `t`:

  Time index.

- `score_p`:

  Pointwise score of forecaster `p`.

- `score_q`:

  Pointwise score of forecaster `q`.

- `delta`:

  Pointwise score difference, `score_p - score_q`.

- `estimate`:

  Running mean score difference. Positive values favour forecaster `p`;
  negative values favour forecaster `q`.

- `lower`, `upper`:

  Confidence sequence bounds. These are `NA` if `compute_cs = FALSE` or
  `cs_type = "none"`.

- `e_pq`, `e_qp`:

  One-sided e-processes. `e_pq` tests whether forecaster `p` outperforms
  `q`; `e_qp` tests the reverse direction. These are `NA` if
  `compute_e = FALSE`.

## Details

This is a convenience wrapper around
[`brier_score()`](https://alasgarliakbar.github.io/seqcomp/reference/brier_score.md),
[`spherical_score()`](https://alasgarliakbar.github.io/seqcomp/reference/spherical_score.md),
[`log_score()`](https://alasgarliakbar.github.io/seqcomp/reference/log_score.md),
[`cs_hoeffding()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_hoeffding.md),
[`cs_bernstein()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_bernstein.md),
[`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md),
and
[`eprocess()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess.md).
It is designed for the common workflow where the user has two forecast
streams `p` and `q`, an outcome stream `y`, and wants a single tidy
output object.

All scoring rules in `seqcomp` are positively oriented: higher scores
are better. Therefore \$\$\hat{\delta}\_t = S(p_t, y_t) - S(q_t,
y_t)\$\$ is positive when forecaster `p` performs better than forecaster
`q` at time `t`.

For `"brier"` and `"spherical"`, score differences are bounded in
`[-1, 1]`. The wrapper therefore uses `c = 1` for Hoeffding-style
confidence sequences and `c = 2` for empirical Bernstein confidence
sequences and e-processes.

For `"log"`, score differences are unbounded. The wrapper therefore
defaults to
[`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md)
and refuses to compute finite-sample e-processes. For binary log-score
comparisons where the Winkler construction is appropriate, use
[`winkler_compare()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_compare.md)
instead.

## Interpretation

The confidence sequence estimates the running average score advantage of
`p` over `q`. If the whole interval lies above zero, the data favour
`p`; if the whole interval lies below zero, the data favour `q`.

The e-processes are evidence processes for one-sided null hypotheses. At
level `alpha`, the two-sided rejection threshold used by
[`eprocess()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess.md)
is `2 / alpha`.

## Examples

``` r
set.seed(1)
y <- rbinom(200, 1, 0.5)
p <- rep(0.5, 200)
q <- runif(200)

out <- compare_forecasts(p, q, y, scoring_rule = "brier")
tail(out)
#>       t score_p     score_q      delta   estimate       lower     upper
#> 195 195   -0.25 -0.02397884 -0.2260212 0.04786789 -0.05978248 0.1555182
#> 196 196   -0.25 -0.42471022  0.1747102 0.04851504 -0.05862231 0.1556524
#> 197 197   -0.25 -0.43536379  0.1853638 0.04920970 -0.05742572 0.1558451
#> 198 198   -0.25 -0.47365726  0.2236573 0.05009075 -0.05607385 0.1562554
#> 199 199   -0.25 -0.12360386 -0.1263961 0.04920388 -0.05649615 0.1549039
#> 200 200   -0.25 -0.72616694  0.4761669 0.05133870 -0.05423303 0.1569104
#>         e_pq         e_qp
#> 195 1.047987 2.220446e-16
#> 196 1.096365 2.220446e-16
#> 197 1.150311 2.220446e-16
#> 198 1.218612 2.220446e-16
#> 199 1.174685 2.220446e-16
#> 200 1.315716 2.220446e-16
```
