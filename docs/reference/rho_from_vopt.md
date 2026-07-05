# Convert optimal intrinsic time to rho

Maps the user-specified intrinsic time `v_opt` (the point at which a
boundary is tightest) to the `rho` tuning parameter, via the Lambert W
formula of Howard et al. (2021), Proposition 3 (paper-exact).

## Usage

``` r
rho_from_vopt(v_opt = 10, alpha = 0.025)
```

## Arguments

- v_opt:

  Numeric \> 0. Intrinsic time at which the boundary is tightest.
  Recommended default from CR23: 10.

- alpha:

  Numeric in (0,1). Significance level (one-sided). For a two-sided
  boundary at level alpha, pass alpha/2 here.

## Value

Numeric \> 0. The rho tuning parameter.

## Details

\$\$\rho = \frac{v\_{opt}}{-W\_{-1}(-\alpha^2 / e) - 1}\$\$ The lower
branch \\W\_{-1}\\ is defined for `x` in `[-1/e, 0)` and returns values
`<= -1`. For `alpha` in `(0, 1)`, `-alpha^2/e` is always in `(-1/e, 0)`,
so the branch is well-defined.

## Examples

``` r
rho_from_vopt(v_opt = 10, alpha = 0.025)
#> [1] 1.025332
```
