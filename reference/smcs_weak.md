# Sequential Model Confidence Set (Weak Null)

Constructs a Sequential Model Confidence Set (SMCS) evaluating the weak
null hypothesis that a model outperforms all other candidate models on
average over time.

## Usage

``` r
smcs_weak(
  scores,
  alpha = 0.05,
  cs_method = c("bernstein", "hoeffding"),
  c_param = NULL,
  ...
)
```

## Arguments

- scores:

  A \\T \times m\\ matrix of positively-oriented scores.

- alpha:

  Numeric in `(0, 1)`. Family-wise significance level. Default is
  `0.05`.

- cs_method:

  Character. `"bernstein"` (uses
  [`cs_bernstein()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_bernstein.md))
  or `"hoeffding"` (uses
  [`cs_hoeffding()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_hoeffding.md)).

- c_param:

  Numeric scalar or \\m \times m\\ matrix. The uniform bound parameter.
  Must be constant over time.

- ...:

  Additional arguments passed to the chosen CS function (e.g., `v_opt`).

## Value

A list containing:

- `smcs`:

  A \\T \times m\\ logical matrix. `TRUE` indicates the model is in the
  weakly superior set at time `t`.

- `alpha_adjusted`:

  The Bonferroni-adjusted significance level applied to each pairwise
  sequence.

## Details

Uses a joint confidence sequence decoupling result: a model \\i\\
remains in the SMCS at time \\t\\ if and only if, for every competitor
\\j\\, the pairwise \\(1 - \alpha/(m(m-1)))\\-confidence sequence for
the average score difference does not strictly rule out that \\i\\ is
better than \\j\\.

Unlike the strong null, this SMCS does not maintain a strict running
intersection; a model's average score can recover over time, allowing it
to dynamically exit and re-enter the confidence set.

## Examples

``` r
set.seed(2)
scores <- matrix(runif(300, -0.5, 0), nrow = 100, ncol = 3)
scores[, 3] <- scores[, 3] - 0.5
colnames(scores) <- c("M1", "M2", "M3")

res <- smcs_weak(scores, alpha = 0.05, cs_method = "bernstein", c_param = 2)
tail(res$smcs)
#>          M1   M2    M3
#>  [95,] TRUE TRUE FALSE
#>  [96,] TRUE TRUE FALSE
#>  [97,] TRUE TRUE FALSE
#>  [98,] TRUE TRUE FALSE
#>  [99,] TRUE TRUE FALSE
#> [100,] TRUE TRUE FALSE
```
