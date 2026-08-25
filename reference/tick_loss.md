# Negated tick loss for quantile forecasts

Computes the positively oriented (negated) tick/quantile loss (Koenker &
Bassett, 1978).

## Usage

``` r
tick_loss(q, y, tau)
```

## Arguments

- q:

  Numeric vector. Quantile forecasts at level tau.

- y:

  Numeric vector. Realised outcomes.

- tau:

  Numeric in (0,1). Quantile level.

## Value

Numeric vector of negated tick loss scores. Higher = better.

## Details

The standard tick loss is \$\$\rho\_\tau(u) = u \left(\tau -
\mathbb{1}(u \< 0)\right),\$\$ where \\u = y - q\_\tau\\ is the forecast
error. This is loss-oriented (lower = better), so the function negates
it: \$\$S_T(q, y; \tau) = -(y - q)\left(\tau - \mathbb{1}(y \<
q)\right).\$\$

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
tick_loss(q, y, tau = 0.5)
#> [1] -0.10 -0.05 -0.15
```
