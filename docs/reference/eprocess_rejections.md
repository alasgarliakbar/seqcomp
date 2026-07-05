# Determine rejection times for an e-process output

Determine rejection times for an e-process output

## Usage

``` r
eprocess_rejections(ep, alpha = 0.05)
```

## Arguments

- ep:

  data.frame. Output of eprocess().

- alpha:

  Numeric. Significance level. Threshold is 2/alpha.

## Value

Named list with elements:

- `threshold` — rejection threshold (`2 / alpha`).

- `tau_pq` — first `t` where `e_pq >= threshold` (`NA` if never
  crossed).

- `tau_qp` — first `t` where `e_qp >= threshold` (`NA` if never
  crossed).

- `reject_pq` — logical: was \\H_0^w(p,q)\\ ever rejected?

- `reject_qp` — logical: was \\H_0^w(q,p)\\ ever rejected?

## Examples

``` r
scores1 <- c(-0.04, -0.09, -0.01, -0.16)
scores2 <- c(-0.09, -0.16, -0.04, -0.25)
ep <- eprocess(scores1, scores2, alpha = 0.05)
eprocess_rejections(ep, alpha = 0.05)
#> $threshold
#> [1] 40
#> 
#> $tau_pq
#> [1] NA
#> 
#> $tau_qp
#> [1] NA
#> 
#> $reject_pq
#> [1] FALSE
#> 
#> $reject_qp
#> [1] FALSE
#> 
```
