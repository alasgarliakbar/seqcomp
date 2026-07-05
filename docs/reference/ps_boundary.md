# Polynomial stitched (PS) boundary

Alternative boundary for both Theorem 1 and Theorem 2 constructions,
included for completeness and for cross-checking CR23 Table results.

## Usage

``` r
ps_boundary(v, alpha, v_opt = 10, c = 1, s = 1.4, eta = 2)
```

## Arguments

- v:

  Numeric vector \>= 0. Intrinsic time values.

- alpha:

  Numeric in (0,1). ONE-SIDED significance level.

- v_opt:

  Numeric \> 0. Optimal intrinsic time (= m in H21). Default: 10.

- c:

  Numeric \> 0. Sub-exponential scale.

- s:

  Numeric \> 1. Stitching parameter. Default: 1.4.

- eta:

  Numeric \> 1. Geometric spacing. Default: 2.

## Value

Numeric vector of boundary values (cumulative-sum scale).

## Details

This is **not** the recommended primary boundary: the CM/GE mixture
boundaries
([`cm_boundary()`](https://alasgarliakbar.github.io/seqcomp/reference/cm_boundary.md),
[`ge_boundary()`](https://alasgarliakbar.github.io/seqcomp/reference/ge_boundary.md))
are tighter in CR23 and are used by default throughout `seqcomp`. Use
`ps_boundary()` only when you specifically need the polynomial-stitched
construction.

## Examples

``` r
ps_boundary(v = 1:5, alpha = 0.025, v_opt = 10, c = 1)
#> [1] 16.12066 16.12066 16.12066 16.12066 16.12066
```
