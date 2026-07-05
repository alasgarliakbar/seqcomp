# Gamma-exponential mixture boundary

Gamma-exponential mixture boundary

## Usage

``` r
ge_boundary(v, alpha, rho, c, s_lo = -10, s_hi = 500)
```

## Arguments

- v:

  Numeric vector \>= 0. Intrinsic time values.

- alpha:

  Numeric in (0,1). ONE-SIDED significance level.

- rho:

  Numeric \> 0. From rho_from_vopt().

- c:

  Numeric \> 0. Sub-exponential scale.

- s_lo:

  Numeric. Lower search bound for uniroot. Default: -10.

- s_hi:

  Numeric. Upper search bound for uniroot. Default: 500.

## Value

Numeric vector of boundary values (cumulative-sum scale).

## Details

Computes \\u\_{GE}(v; \alpha, \rho, c) = \sup\\s : m(s,v) \<
1/\alpha\\\\ by solving `m(s, v) = 1/alpha` numerically for `s` via
[`uniroot()`](https://rdrr.io/r/stats/uniroot.html), separately for each
`v_i`.

Root-finding fallback: the search starts in `[s_lo, s_hi]`; if
`m(s_hi, v_i)` has not yet crossed the target, `s_hi` is doubled once
and retried. If it still fails, a warning is issued and `s_hi` is
returned as a conservative fallback value. Increase `s_hi` directly if
this warning appears often (e.g. at large `v` or small `alpha`);
increase `abs(s_lo)` if no root is found at small `v`.

Computed elementwise; can be slow for long vectors — consider caching
boundary values when the same `(alpha, rho, c)` are reused.

## Examples

``` r
rho <- rho_from_vopt(v_opt = 10, alpha = 0.025)
ge_boundary(v = 1:3, alpha = 0.025, rho = rho, c = 2)
#> [1] 10.12051 11.43416 12.49748
```
