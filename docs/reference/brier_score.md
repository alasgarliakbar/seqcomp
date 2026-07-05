# Brier score for binary and categorical forecasts

Computes the positively oriented Brier/quadratic score. Vector
probability input is treated as binary; matrix probability input is
treated as categorical.

## Usage

``` r
brier_score(p, y)
```

## Arguments

- p:

  Numeric vector in `[0, 1]` for binary forecasts, or a numeric matrix
  whose rows are probability vectors for categorical forecasts.

- y:

  For binary vector input, numeric vector in `{0, 1}`. For categorical
  matrix input, integer vector in `{1, ..., K}`, where `K = ncol(p)`.

## Value

Numeric vector of scores in `[-1, 0]`. Higher is better.

## Details

For binary forecasts, this computes \$\$S(p, y) = -(p-y)^2.\$\$

For categorical forecasts, this computes \$\$S(\mathbf{p}, y) =
-\frac{1}{2}\\\mathbf{p} - e_y\\\_2^2,\$\$ where `e_y` is the one-hot
vector of the realised category.

With the convention that category 2 corresponds to the binary event
`y = 1`, the categorical formula recovers the binary formula exactly
when `K = 2`.

## Bounds

Score differences lie in `[-1, 1]`, so use `c = 1` for Theorem 1 and
`c = 2` for Theorems 2 and 3.

## Examples

``` r
p <- c(0.2, 0.7, 0.9)
y <- c(0, 1, 1)
brier_score(p, y)
#> [1] -0.04 -0.09 -0.01
```
