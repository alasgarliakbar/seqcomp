# Spherical score for binary and categorical forecasts

Computes the positively oriented spherical score. Vector probability
input is treated as binary; matrix probability input is treated as
categorical.

## Usage

``` r
spherical_score(p, y)
```

## Arguments

- p:

  Numeric vector in `[0, 1]` for binary forecasts, or a numeric matrix
  whose rows are probability vectors for categorical forecasts.

- y:

  For binary vector input, numeric vector in `{0, 1}`. For categorical
  matrix input, integer vector in `{1, ..., K}`, where `K = ncol(p)`.

## Value

Numeric vector of scores in `[0, 1]`. Higher is better.

## Details

For binary forecasts, this computes \$\$S(p, y) = \frac{py +
(1-p)(1-y)}{\sqrt{p^2 + (1-p)^2}}.\$\$ For categorical forecasts, this
computes \$\$S(\mathbf{p}, y) = \frac{p_y}{\\\mathbf{p}\\\_2},\$\$ where
`p_y` is the forecast probability assigned to the realised category.

Score differences lie in `[-1, 1]`, so use `c = 1` for Theorem 1 and
`c = 2` for Theorems 2 and 3.

## Examples

``` r
p <- c(0.2, 0.7, 0.9)
y <- c(0, 1, 1)
spherical_score(p, y)
#> [1] 0.9701425 0.9191450 0.9938837
```
