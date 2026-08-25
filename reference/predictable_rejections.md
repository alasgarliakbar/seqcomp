# Summarise predictable bounds e-process

Summarise predictable bounds e-process

## Usage

``` r
predictable_rejections(ep, alpha = 0.05)
```

## Arguments

- ep:

  data.frame. Output of eprocess_predictable().

- alpha:

  Numeric. Significance level.

## Value

Named list matching the
[`eprocess_rejections()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_rejections.md)
format (`threshold`, `tau_pq`, `tau_qp`, `reject_pq`, `reject_qp`),
plus:

- `c_range` — range of `c_seq` used.

- `lambda` — `lambda` value used.

## Examples

``` r
scores1 <- c(0.10, 0.20, 0.15, 0.25)
scores2 <- c(0.05, 0.10, 0.10, 0.20)
c_seq <- rep(1, length(scores1))
ep <- eprocess_predictable(scores1, scores2, c_seq = c_seq)
predictable_rejections(ep, alpha = 0.05)
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
#> $c_range
#> [1] 1 1
#> 
#> $lambda
#> [1] 0.5
#> 
```
