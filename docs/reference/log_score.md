# Logarithmic score for binary and categorical forecasts

Computes the positively oriented logarithmic score. Vector probability
input is treated as binary; matrix probability input is treated as
categorical.

## Usage

``` r
log_score(p, y, eps = 1e-15)
```

## Arguments

- p:

  Numeric vector in `[0, 1]` for binary forecasts, or a numeric matrix
  whose rows are probability vectors for categorical forecasts.

- y:

  For binary vector input, numeric vector in `{0, 1}`. For categorical
  matrix input, integer vector in `{1, ..., K}`, where `K = ncol(p)`.

- eps:

  Numeric. Probability floor used before taking logarithms. Default is
  `1e-15`. Set to `0` to disable clipping.

## Value

Numeric vector of scores in `(-Inf, 0]`. Higher is better.

## Details

For binary forecasts, this computes \$\$S(p, y) = y\log(p) +
(1-y)\log(1-p).\$\$

For categorical forecasts, this computes \$\$S(\mathbf{p}, y) =
\log(p_y),\$\$ where `p_y` is the forecast probability assigned to the
realised category.

## Use with seqcomp

The logarithmic score is unbounded below. It should not be used directly
with the finite-sample bounded-difference confidence sequences or
e-processes. For binary outcomes, use
[`winkler_score()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_score.md)
and
[`winkler_cs()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_cs.md)
when the Winkler construction is appropriate. For unbounded score
differences, use
[`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md)
or supply genuine predictable bounds to
[`eprocess_predictable()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_predictable.md).

## Examples

``` r
p <- c(0.2, 0.7, 0.9)
y <- c(0, 1, 1)
log_score(p, y)
#> [1] -0.2231436 -0.3566749 -0.1053605
```
