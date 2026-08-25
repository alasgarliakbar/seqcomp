# Arithmetic-mean closed-testing e-value merge

Given a vector of e-values \\e_1, \ldots, e_m\\ (where each \\e_i\\
represents the evidence against the intersection null hypothesis for
model \\i\\), computes the closed-testing adjusted e-values using the
arithmetic mean as the e-merging function.

## Usage

``` r
vovk_wang_merge(e_values)
```

## Arguments

- e_values:

  Numeric vector of non-negative e-values, one per model.

## Value

A numeric vector of the same length, containing the closed-testing
adjusted e-values \\e^\star_i\\, in the original (unsorted) order.

## Details

This implements the Accelerated E-Value Calibration algorithm (Tim
Stephan, ETH Zurich; Section H of the supplementary material to Arnold
et al., 2026), which solves the Vovk & Wang (2021) closed-testing
minimization in \\O(m \log m)\\ time rather than the naive \\O(m^2)\\.

## Examples

``` r
raw_evalues <- c(10, 2, 1)
# Model 1 has strong evidence against it, Model 3 has none.
vovk_wang_merge(raw_evalues)
#> [1] 4.333333 1.500000 1.000000
```
