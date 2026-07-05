# Full Winkler comparison pipeline (Proposition 4)

Convenience wrapper that computes Winkler scores, one-sided CS, and
e-process in a single call.

## Usage

``` r
winkler_compare(
  p,
  q,
  y,
  alpha = 0.05,
  base_score = log_score,
  v_opt = 10,
  lower_bound = NULL
)
```

## Arguments

- p:

  Numeric vector in (0,1).

- q:

  Numeric vector in (0,1).

- y:

  Numeric vector containing only 0 and 1. Binary outcomes.

- alpha:

  Numeric in (0,1). Default: 0.05.

- base_score:

  Function. Default: log_score.

- v_opt:

  Numeric \> 0. Default: 10.

- lower_bound:

  Numeric or NULL. See winkler_cs().

## Value

Named list with elements:

- `winkler_scores` — raw Winkler score vector.

- `cs` — `data.frame` from
  [`winkler_cs()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_cs.md).

- `etest_p_worse` — one-sided e-process testing whether `p` is worse
  than `q`.

- `etest_q_worse` — one-sided e-process testing whether `q` is worse
  than `p`.

- `rejections` — list of one-sided rejection summaries.

## Examples

``` r
p <- c(0.7, 0.6, 0.8, 0.65)
q <- c(0.5, 0.7, 0.6, 0.55)
y <- c(1, 1, 0, 1)
winkler_compare(p, q, y, alpha = 0.05)
#> $winkler_scores
#> [1]  1.0000000 -0.5358369 -2.4094208  1.0000000
#> 
#> $cs
#>   t   estimate lower    upper
#> 1 1  1.0000000  -Inf 9.539781
#> 2 2  0.2320815  -Inf 5.748373
#> 3 3 -0.6484193  -Inf 4.538189
#> 4 4 -0.2363144  -Inf 3.988530
#> 
#> $etest_p_worse
#>   t         e      log_e
#> 1 1 0.4487869 -0.8012071
#> 2 2 0.3320708 -1.1024071
#> 3 3 0.3175664 -1.1470682
#> 4 4 0.2220444 -1.5048778
#> 
#> $etest_q_worse
#>   t         e        log_e
#> 1 1 1.0058884  0.005871134
#> 2 2 0.3518387 -1.044582350
#> 3 3 0.2494182 -1.388624389
#> 4 4 0.2591944 -1.350177087
#> 
#> $rejections
#> $rejections$p_worse_than_q
#> $rejections$p_worse_than_q$threshold
#> [1] 20
#> 
#> $rejections$p_worse_than_q$tau
#> [1] NA
#> 
#> $rejections$p_worse_than_q$reject
#> [1] FALSE
#> 
#> 
#> $rejections$q_worse_than_p
#> $rejections$q_worse_than_p$threshold
#> [1] 20
#> 
#> $rejections$q_worse_than_p$tau
#> [1] NA
#> 
#> $rejections$q_worse_than_p$reject
#> [1] FALSE
#> 
#> 
#> 
```
