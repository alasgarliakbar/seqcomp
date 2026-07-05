# Normal mixture (CM) boundary

Normal mixture (CM) boundary

## Usage

``` r
cm_boundary(v, alpha, rho)
```

## Arguments

- v:

  Numeric vector \>= 0. Intrinsic time values (V_t or t).

- alpha:

  Numeric in (0,1). ONE-SIDED significance level.

- rho:

  Numeric \> 0. Tuning parameter. Obtain via rho_from_vopt().

## Value

Numeric vector of boundary values (cumulative-sum scale, before /t).

## See also

[`rho_from_vopt()`](https://alasgarliakbar.github.io/seqcomp/reference/rho_from_vopt.md)
to compute `rho` from a target `v_opt`.

## Examples

``` r
  rho <- rho_from_vopt(v_opt = 10, alpha = 0.025)
  u   <- cm_boundary(v = 1:500, alpha = 0.025, rho = rho)
```
