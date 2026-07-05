# Winkler-normalized binary score

Normalises the score difference S(p,y) - S(q,y) by the maximum possible
score difference given the forecaster ordering, mapping the result to
`(-Inf, 1]` (Proposition 4, Choe & Ramdas 2023). Used to apply Theorems
2 & 3 to unbounded scoring rules on binary outcomes.

## Usage

``` r
winkler_score(p, q, y, base_score = log_score, eps = 1e-08)
```

## Arguments

- p:

  Numeric vector in (0,1). Forecasts from model 1.

- q:

  Numeric vector in (0,1). Forecasts from model 2.

- y:

  Numeric vector containing only 0 and 1. Binary outcomes.

- base_score:

  Function. The underlying scoring rule S(p, y). Must accept two
  arguments: forecast probability and outcome. Default: log_score (with
  eps clipping).

- eps:

  Numeric. Zero-protection for the normaliser denominator. Default: 1e-8
  (matches Python comparecast convention).

## Value

Numeric vector. Winkler scores in `(-Inf, 1]`. Upper bound of 1 is
tight: w = 1 when y = 1(p \> q).

## Details

\$\$w(p, q, y) = \frac{S(p,y) - S(q,y)}{S(p, \mathbb{1}(p\>q)) - S(q,
\mathbb{1}(p\>q))}\$\$ with the convention 0/0 := 0.

The lower bound is problem-dependent (depends on how extreme p and q can
be). For a two-sided CS via Corollary 2, the user must establish a
finite lower bound analytically. If no finite lower bound can be
guaranteed, use the one-sided (upper) CS only, as in the CR23 MLB
experiments.

## When to use

Strictly limited to binary outcomes `y` in `{0, 1}` and probability
forecasts `p`, `q` in `(0, 1)`. Not applicable to QLIKE or other
continuous-outcome scoring rules. See CR23 Section G for discussion.

For use in Theorems 2 & 3: upper bound = 1 implies c/2 = 1, so use
`c = 2` in all GE boundary and e-process calls.

## Examples

``` r
p <- c(0.7, 0.6, 0.8, 0.65)
q <- c(0.5, 0.7, 0.6, 0.55)
y <- c(1, 1, 0, 1)
winkler_score(p, q, y)
#> [1]  1.0000000 -0.5358369 -2.4094208  1.0000000
```
