# Sequential Model Confidence Set (Strong & Uniformly Weak Null)

Constructs a Sequential Model Confidence Set (SMCS) evaluating a
family-wise intersection null hypothesis. By maintaining a running
intersection over time, any model excluded from the set is permanently
eliminated.

## Usage

``` r
smcs_strong(
  scores,
  alpha = 0.05,
  method = c("betting", "mixture"),
  c_param = NULL,
  lambda_param = NULL,
  ...
)
```

## Arguments

- scores:

  A \\T \times m\\ matrix of positively-oriented scores.

- alpha:

  Numeric in `(0, 1)`. Family-wise significance level. Default is
  `0.05`.

- method:

  Character. `"betting"` (uses
  [`eprocess_betting()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_betting.md),
  true strong null) or `"mixture"` (uses
  [`eprocess()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess.md),
  tests uniformly weak null). Default is `"betting"`.

- c_param:

  Numeric scalar, \\m \times m\\ matrix, or \\T \times m \times m\\
  array. The predictable bound parameter. Required. Time-varying arrays
  are only allowed if `method = "betting"`.

- lambda_param:

  Optional parameter for betting fractions, matching the shape allowed
  for `c_param`. Only used if `method = "betting"`.

- ...:

  Additional arguments passed to the underlying pairwise e-process
  function (e.g., `v_opt` and `clip_max` for `"mixture"`; `clip_max` for
  `"betting"`).

## Value

A list containing:

- `E_i_dot`:

  A \\T \times m\\ matrix of unadjusted intersection e-processes.

- `E_star`:

  A \\T \times m\\ matrix of closed-testing adjusted e-processes.

- `smcs`:

  A \\T \times m\\ logical matrix. `TRUE` indicates the model remains in
  the SMCS at time `t`.

## Details

Depending on the `method` chosen, this function tests different
hypotheses:

- **`method = "betting"`**: Tests the **Strong Null** hypothesis
  (conditional step-by-step superiority). Uses a product-form betting
  martingale.

- **`method = "mixture"`**: Tests the **Uniformly Weak Null** hypothesis
  (average superiority over time). Uses an exponential-mixture
  martingale. Because strong superiority implies uniform weak
  superiority, feeding `"mixture"` into this closed-testing machinery
  yields a valid (though strictly testing the uniformly weak null) SMCS.

The function computes pairwise e-processes between all models,
constructs an intersection e-process for each model, applies a
closed-testing multiplicity adjustment via
[`vovk_wang_merge()`](https://alasgarliakbar.github.io/seqcomp/reference/vovk_wang_merge.md),
and permanently excludes models when their adjusted e-value exceeds
\\1/\alpha\\.

## Examples

``` r
set.seed(1)
# 3 models, 100 time steps. Model 3 is artificially much worse.
scores <- matrix(runif(300, -0.5, 0), nrow = 100, ncol = 3)
scores[, 3] <- scores[, 3] - 0.5
colnames(scores) <- c("M1", "M2", "M3")

# Using the betting method with a global bound c = 2
res <- smcs_strong(scores, alpha = 0.05, method = "betting", c_param = 2)
tail(res$smcs)
#>          M1   M2    M3
#>  [95,] TRUE TRUE FALSE
#>  [96,] TRUE TRUE FALSE
#>  [97,] TRUE TRUE FALSE
#>  [98,] TRUE TRUE FALSE
#>  [99,] TRUE TRUE FALSE
#> [100,] TRUE TRUE FALSE
```
