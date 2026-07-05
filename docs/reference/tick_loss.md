# Negated tick loss for quantile forecasts

Computes the positively oriented (negated) tick/quantile loss (Koenker &
Bassett, 1978).

## Usage

``` r
tick_loss(q, y, alpha)
```

## Arguments

- q:

  Numeric vector. Quantile forecasts at level alpha.

- y:

  Numeric vector. Realised outcomes.

- alpha:

  Numeric in (0,1). Quantile level.

## Value

Numeric vector of negated tick loss scores. Higher = better.

## Details

The standard tick loss is \$\$\rho\_\alpha(u) = u \left(\alpha -
\mathbb{1}(u \< 0)\right),\$\$ where \\u = y - q\_\alpha\\ is the
forecast error. This is loss-oriented (lower = better), so the function
negates it: \$\$S_T(q, y; \alpha) = -(y - q)\left(\alpha - \mathbb{1}(y
\< q)\right).\$\$

Tick loss is unbounded on general real-valued outcomes. Bounds derived
from an empirical data range are ex-post and do not provide
theorem-valid constants for finite-sample Hoeffding/Bernstein confidence
sequences or e-processes.

Sign convention: the negation means `hat_delta_t > 0` when forecaster
`p` has smaller tick loss, hence a better quantile forecast, than
forecaster `q`.

## Examples

``` r
q <- c(1.0, 1.5, 2.0)
y <- c(1.2, 1.4, 2.3)
tick_loss(q, y, alpha = 0.5)
#> [1] -0.10 -0.05 -0.15
```
