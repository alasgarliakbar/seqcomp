# Hoeffding-style confidence sequence (Theorem 1, Choe & Ramdas 2023)

Constructs a time-uniform confidence sequence for the mean score
difference \\\Delta_t = \frac{1}{t} \sum\_{i=1}^t E\[\hat{\delta_i} \mid
\mathcal{F}\_{i-1}\]\\.

## Usage

``` r
cs_hoeffding(
  scores1,
  scores2,
  alpha = 0.05,
  c = 1,
  v_opt = 10,
  boundary = "mixture"
)
```

## Arguments

- scores1:

  Numeric vector. Scores S(p_t, y_t) for forecaster 1.

- scores2:

  Numeric vector. Scores S(q_t, y_t) for forecaster 2.

- alpha:

  Numeric in (0,1). Significance level. The CS has coverage 1 - alpha
  uniformly over all t. Default: 0.05.

- c:

  Numeric \> 0. Sub-Gaussian scale. The process must satisfy
  \|hat_delta_i\| \<= c for all i. For scores in `[a,b]`, the difference
  is in `[a-b, b-a]`, so c = b - a. Default: 1 (appropriate for Brier
  score differences in `[-1,1]`).

- v_opt:

  Numeric \> 0. Intrinsic time at which the CS is tightest. Default: 10
  (recommended by CR23).

- boundary:

  Character. "mixture" (default, recommended) or "stitching".

## Value

data.frame with columns t, estimate, lower, upper.

## Assumption

Requires `hat_delta_i` to be c-sub-Gaussian given
\\\mathcal{F}\_{i-1}\\, i.e. `|hat_delta_i| <= c` for all `i`.

## Boundary

\$\$C_t^H = \hat\Delta_t \pm u^{CM}\_{\alpha/2}(c^2 t; \rho) / t\$\$
where \\u^{CM}\\ is the normal mixture boundary and \\c^2 t\\ is the
intrinsic time for a c-sub-Gaussian process with deterministic variance
proxy. The intrinsic time for Theorem 1 is `v_t = c^2 * t`, not
`v_t = t`: the CM boundary implicitly assumes 1-sub-Gaussian inputs, so
the `c^2` scaling must be applied explicitly. This matches the H21
convention, where the boundary absorbs the sub-Gaussian parameter via
the variance process definition.

Relation to Python comparecast: Python uses `v_t = sigma * t` where
`sigma = (hi - lo)/2 = c`. This is equivalent to our `c^2 * t` only when
`c = 1`. For `c != 1` the parametrisations differ; we follow the paper.

## Output

Returns a `data.frame` with one row per `t` and columns `t`, `estimate`
(the running mean `hat_Delta_t`), `lower`, and `upper`, with coverage
guarantee \\P(\forall t \geq 1 : \Delta_t \in \[\text{lower}\_t,
\text{upper}\_t\]) \geq 1 - \alpha\\.

## Examples

``` r
scores1 <- c(-0.04, -0.09, -0.01, -0.16)
scores2 <- c(-0.09, -0.16, -0.04, -0.25)
cs_hoeffding(scores1, scores2, alpha = 0.05)
#>   t estimate     lower    upper
#> 1 1     0.05 -3.989937 4.089937
#> 2 2     0.06 -2.469506 2.589506
#> 3 3     0.05 -1.927735 2.027735
#> 4 4     0.06 -1.618231 1.738231
```
