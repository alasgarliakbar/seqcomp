# Sub-exponential mixture e-process (Theorem 3, Choe & Ramdas 2023)

Constructs two simultaneous one-sided e-processes for sequentially
testing whether forecaster 1 (p) outperforms forecaster 2 (q) or vice
versa.

## Usage

``` r
eprocess(
  scores1,
  scores2,
  alpha = 0.05,
  c = 2,
  v_opt = 10,
  alpha_opt = NULL,
  gammas = NULL,
  clip_max = 1e+07
)
```

## Arguments

- scores1:

  Numeric vector. Scores S(p_t, y_t) for forecaster 1.

- scores2:

  Numeric vector. Scores S(q_t, y_t) for forecaster 2.

- alpha:

  Numeric in (0,1). Significance level. Rejection threshold is 2/alpha
  for the two-sided test. Default: 0.05.

- c:

  Numeric \> 0. Sub-exponential scale. Must satisfy \|hat_delta_i\| \<=
  c/2 for all i. For score differences in `[-(b-a), b-a]`: c = 2\*(b-a).
  Default: 2 (for Brier score differences in `[-1,1]`).

- v_opt:

  Numeric \> 0. Intrinsic time at which e-process grows fastest.
  Default: 10 (recommended by CR23).

- alpha_opt:

  Numeric in (0,1). One-sided alpha used to compute rho. Default:
  alpha/2 (matches comparecast two-sided convention).

- gammas:

  Numeric vector or NULL. Predictable centering sequence. If NULL,
  constructed as lagged running mean.

- clip_max:

  Numeric. Maximum e-process value before clipping. Default: 1e7
  (matches Python comparecast).

## Value

data.frame with columns t, e_pq, e_qp, log_e_pq, log_e_qp.

## Details

The mixture e-process at time t is: \$\$E_t^{\mathrm{mix}} = m(S_t,
\hat{V}\_t)\$\$ where \\S_t = \sum\_{i=1}^t \hat{\delta}\_i\\,
\\\hat{V}\_t = \sum\_{i=1}^t (\hat{\delta}\_i - \gamma_i)^2\\, and
\\m(s, v)\\ is the Gamma-Exponential mixture function (Proposition 3,
CR23).

VARIANCE PROCESS: The intrinsic time V_hat_t uses NO floor (unlike the
EB CS). The GE mixture m(s, v) is well-defined at v=0 (returns 1 when
s=0), so no floor is needed. Adding a floor would distort e-values.

SCALE CONVENTION: c is the sub-exponential scale parameter such that
\|hat_delta_i\| \<= c/2. This is the Theorems 2 & 3 convention from
CR23. For Brier score differences in `[-1,1]`: c = 2. For Winkler scores
(bounded above by 1): c = 2.

LOG-SPACE: E-process values are computed in log-space and clipped before
exponentiating to avoid numerical overflow.

## Rejection rule

At level `alpha`: reject \\H_0^w(p, q)\\ (conclude `p` outperforms `q`)
when `e_pq >= 2/alpha`; reject \\H_0^w(q, p)\\ (conclude `q` outperforms
`p`) when `e_qp >= 2/alpha`. Use
[`eprocess_rejections()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_rejections.md)
to extract the first crossing time for each.

## Examples

``` r
scores1 <- c(-0.04, -0.09, -0.01, -0.16)
scores2 <- c(-0.09, -0.16, -0.04, -0.25)
ep <- eprocess(scores1, scores2, alpha = 0.05)
head(ep)
#>   t     e_pq      e_qp   log_e_pq    log_e_qp
#> 1 1 1.018495 0.9779115 0.01832561 -0.02233605
#> 2 2 1.047660 0.9502583 0.04655865 -0.05102145
#> 3 3 1.059805 0.9381265 0.05808536 -0.06387052
#> 4 4 1.098162 0.9035433 0.09363831 -0.10143124
```
