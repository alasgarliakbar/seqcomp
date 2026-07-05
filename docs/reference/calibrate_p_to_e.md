# P-to-e calibrator

Converts anytime-valid p-values to e-values using the mixture or simple
calibrator, as used in CR23 Section 4.4.

## Usage

``` r
calibrate_p_to_e(p, strategy = "mixture", eps = 1e-16)
```

## Arguments

- p:

  Numeric vector of p-values in (0, 1\].

- strategy:

  Character. `"mixture"` (default, from Vovk & Wang 2021) or `"simple"`.
  See Details for the formulas.

- eps:

  Numeric. Numerical guard for log(0). Default: 1e-16.

## Value

Numeric vector of e-values \>= 0.

## Details

Mixture calibrator (default, matches Python comparecast behaviour):
\$\$f(p) = \frac{1 - p + p\log(p)}{p\\(\log p)^2}\$\$

Simple calibrator (`strategy = "simple"`): \$\$f(p) =
\frac{1}{2\sqrt{p}}\$\$

## Examples

``` r
p <- c(0.5, 0.1, 0.01)
calibrate_p_to_e(p)
#> [1] 0.6386739 1.2632108 4.4509923
calibrate_p_to_e(p, strategy = "simple")
#> [1] 0.7071068 1.5811388 5.0000000
```
