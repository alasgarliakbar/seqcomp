# Fixed-lambda e-process with predictable bounds (Proposition 7)

Constructs a valid e-process when score difference bounds vary over time
but are predictable (known at time i-1 before observing hat_delta_i).

## Usage

``` r
eprocess_predictable(
  scores1,
  scores2,
  c_seq,
  lambda = NULL,
  alpha = 0.05,
  gammas = NULL,
  clip_max = 1e+07,
  strict = FALSE
)
```

## Arguments

- scores1:

  Numeric vector. Scores for forecaster 1.

- scores2:

  Numeric vector. Scores for forecaster 2.

- c_seq:

  Numeric vector. Predictable bound sequence (c_i), same length as
  scores1. Must satisfy `|scores1[i]-scores2[i]| <= c_i/2` and c_i \> 0
  for all i.

- lambda:

  Numeric in `[0, 1/c_0)`. Betting parameter. Must be strictly less than
  1/c_0 where c_0 = max(c_seq). If NULL, uses the recommended default
  lambda = 0.5/c_0.

- alpha:

  Numeric in (0,1). Significance level for rejection rule. Default:
  0.05. Not used in computation, only for API consistency. Pass the same
  value to
  [`predictable_rejections()`](https://alasgarliakbar.github.io/seqcomp/reference/predictable_rejections.md)
  when evaluating rejection.

- gammas:

  Numeric vector or NULL. Predictable centering sequence. If NULL,
  constructed as lagged running mean.

- clip_max:

  Numeric. Maximum e-process value. Default: 1e7.

- strict:

  Logical. If TRUE, any violation of the bound condition at any time
  point will stop execution with an error. If FALSE (default), a warning
  is issued but the e-process is still computed. Note that violations
  invalidate the e-process guarantee, so strict = TRUE is recommended
  for formal inference.

## Value

data.frame with columns: t, e_pq, e_qp, log_e_pq, log_e_qp, c_seq,
lambda_used

## Details

The e-process is computed as: \$\$\log E_t(\lambda) = \sum\_{i=1}^t
\Bigl\[\lambda\\\hat{\delta}\_i -
\psi\_{E,c_i}(\lambda)\\(\hat{\delta}\_i - \gamma_i)^2\Bigr\]\$\$

where \$\$\psi\_{E,c}(\lambda) = \frac{-\log(1 - c\lambda) -
c\lambda}{c^2}\$\$ is evaluated at each step with the current \\c_i\\.

LAMBDA CHOICE: lambda = 0.5/c_0 is a conservative default that stays
well within the valid domain `[0, 1/c_0)`. For better power, lambda can
be tuned to the expected signal size, but must never reach 1/c_0.

VALIDITY CHECK: The function verifies \|hat_delta_i\| \<= c_i/2 at each
step and warns if violated. Violations invalidate the e-process
guarantee.

## Predictability

The bound sequence `c_seq` (and the centering sequence `gammas`) must be
predictable: `c_i` is fixed and known at time `i - 1`, before
`scores1[i]`/`scores2[i]` (and hence `hat_delta_i`) are observed —
formally, \\c_i\\ is \\\mathcal{F}\_{i-1}\\-measurable. A bound chosen
after seeing `hat_delta_i` (e.g. derived from the realised data range)
invalidates the e-process guarantee, even if it numerically satisfies
`|hat_delta_i| <= c_i/2`.

## Examples

``` r
scores1 <- c(0.10, 0.20, 0.15, 0.25)
scores2 <- c(0.05, 0.10, 0.10, 0.20)
c_seq <- rep(1, length(scores1))
ep <- eprocess_predictable(scores1, scores2, c_seq = c_seq)
head(ep)
#>   t     e_pq      e_qp   log_e_pq    log_e_qp c_seq lambda_used
#> 1 1 1.024820 0.9748391 0.02451713 -0.02548287     1         0.5
#> 2 2 1.076844 0.9268480 0.07403426 -0.07596574     1         0.5
#> 3 3 1.103971 0.9038549 0.09891355 -0.10108645     1         0.5
#> 4 4 1.131857 0.8814913 0.12385990 -0.12614010     1         0.5
```
