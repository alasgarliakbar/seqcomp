# Asymptotic confidence sequence (Appendix C, Eq. 55, Choe & Ramdas 2023)

**Asymptotic, not finite-sample**: coverage `>= 1 - alpha` holds only as
`t -> infinity`. Valid without requiring bounded score differences —
requires only that `hat_delta_t` has finite variance — so it's
appropriate for tick loss and other scoring rules where hard bounds
depend on unbounded realised values. Suitable for large evaluation
windows.

## Usage

``` r
cs_asymptotic(scores1, scores2, alpha = 0.05, t_star = NULL)
```

## Arguments

- scores1:

  Numeric vector. Scores for forecaster 1.

- scores2:

  Numeric vector. Scores for forecaster 2.

- alpha:

  Numeric in (0,1). Significance level. Default: 0.05.

- t_star:

  Numeric \> 0. Sample size at which CS is tightest. Default:
  length(scores1) (tightest at end of sample).

## Value

data.frame with columns t, estimate, lower, upper.

## Details

\$\$C_t^A = \hat\Delta_t \pm \sqrt{ \frac{2(t \sigma^2_t \rho^2 +
1)}{t^2 \rho^2} \log\frac{\sqrt{t \sigma^2_t \rho^2 + 1}}{\alpha}}\$\$
where \\\sigma^2_t = \frac{1}{t}\sum\_{i=1}^t (\hat\delta_i -
\hat\Delta\_{i-1})^2\\ and `rho` is tuned to be tightest at `t_star`:
\$\$\rho(t\_{star}) = \sqrt{\frac{2\log(1/\alpha) + \log(1 +
2\log(1/\alpha))}{t\_{star}}}\$\$

The running variance estimator uses the predictable mean
`hat_Delta_{t-1}` (not the current mean `hat_Delta_t`) to maintain
predictability, with `hat_Delta_0 := 0`.

## Examples

``` r
scores1 <- c(-0.4, -0.2, -0.3, -0.1, -0.2)
scores2 <- c(-0.5, -0.3, -0.4, -0.2, -0.3)
cs_asymptotic(scores1, scores2, alpha = 0.05)
#>   t estimate      lower     upper
#> 1 1      0.1 -1.8608122 2.0608122
#> 2 2      0.1 -0.8804061 1.0804061
#> 3 3      0.1 -0.5536041 0.7536041
#> 4 4      0.1 -0.3902030 0.5902030
#> 5 5      0.1 -0.2921624 0.4921624
```
