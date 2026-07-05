# Getting started with seqcomp

``` r
library(seqcomp)
```

## Overview

`seqcomp` compares two sequential probabilistic forecasters.

The basic question is:

> As outcomes arrive over time, is one forecaster consistently scoring
> better than the other?

The package follows the convention that all scores are positively
oriented: larger scores are better.

For two forecasters `p` and `q`, the pointwise score difference is

``` math
\hat{\delta}_t = S(p_t, y_t) - S(q_t, y_t).
```

Positive values favour forecaster `p`; negative values favour forecaster
`q`.

## A simple binary forecasting example

Suppose we observe a sequence of binary outcomes.

``` r
set.seed(1)

n <- 300
y <- rbinom(n, size = 1, prob = 0.55)
```

Now create two forecasters.

Forecaster `p` is mildly informative: it tends to assign higher
probability when the event occurs and lower probability when it does
not.

Forecaster `q` is less informative and stays closer to 0.5.

``` r
p <- ifelse(y == 1, 0.62, 0.38)
q <- rep(0.50, n)

head(data.frame(y = y, p = p, q = q))
#>   y    p   q
#> 1 1 0.62 0.5
#> 2 1 0.62 0.5
#> 3 0 0.38 0.5
#> 4 0 0.38 0.5
#> 5 1 0.62 0.5
#> 6 0 0.38 0.5
```

This toy example is deliberately simple. In a real application, `p` and
`q` would come from two forecasting models, analysts, or institutions.

## Compare the forecasts

The easiest workflow is to use
[`compare_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_forecasts.md).

``` r
cmp <- compare_forecasts(
  p = p,
  q = q,
  y = y,
  scoring_rule = "brier"
)

head(cmp)
#>   t score_p score_q  delta estimate      lower     upper     e_pq         e_qp
#> 1 1 -0.1444   -0.25 0.1056   0.1056 -10.014906 10.226106 1.034560 9.495389e-01
#> 2 2 -0.1444   -0.25 0.1056   0.1056  -4.954653  5.165853 1.080177 9.099389e-01
#> 3 3 -0.1444   -0.25 0.1056   0.1056  -3.267902  3.479102 1.128004 8.721567e-01
#> 4 4 -0.1444   -0.25 0.1056   0.1056  -2.424527  2.635727 1.178151 8.361057e-01
#> 5 5 -0.1444   -0.25 0.1056   0.1056  -1.918501  2.129701 1.230736 2.220446e-16
#> 6 6 -0.1444   -0.25 0.1056   0.1056  -1.581151  1.792351 1.285880 2.220446e-16
```

The output contains one row per time point.

The most important columns are:

- `score_p`: the score of forecaster `p`,
- `score_q`: the score of forecaster `q`,
- `delta`: the score difference `score_p - score_q`,
- `estimate`: the running mean score difference,
- `lower` and `upper`: the confidence sequence,
- `e_pq` and `e_qp`: the two one-sided e-processes.

## Interpreting the confidence sequence

The confidence sequence tracks the running average score advantage.

``` r
plot(
  cmp$t, cmp$estimate,
  type = "l",
  ylim = range(c(cmp$lower, cmp$upper, 0), finite = TRUE),
  xlab = "Time",
  ylab = "Mean score difference",
  main = "Sequential comparison using the Brier score"
)
lines(cmp$t, cmp$lower, lty = 2)
lines(cmp$t, cmp$upper, lty = 2)
abline(h = 0, col = "gray50")
```

![](seqcomp_files/figure-html/unnamed-chunk-5-1.png)

If the whole interval lies above zero, the data favour `p`.

If the whole interval lies below zero, the data favour `q`.

If the interval still contains zero, the comparison is not yet decisive
at the chosen level.

## Interpreting the e-process

The e-process is an evidence process. Larger values mean stronger
evidence against the corresponding null hypothesis.

For a two-sided comparison at level `alpha`, the rejection threshold
used by
[`eprocess()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess.md)
is `2 / alpha`.

``` r
alpha <- 0.05
threshold <- 2 / alpha

threshold
#> [1] 40
```

The column `e_pq` gives evidence that `p` outperforms `q`.

The column `e_qp` gives evidence that `q` outperforms `p`.

``` r
plot(
  cmp$t, cmp$e_pq,
  type = "l",
  log = "y",
  xlab = "Time",
  ylab = "e-process value",
  main = "Evidence that p outperforms q"
)
abline(h = threshold, lty = 2, col = "gray50")
```

![](seqcomp_files/figure-html/unnamed-chunk-7-1.png)

We can summarize rejection times with
[`eprocess_rejections()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_rejections.md).

``` r
eprocess_rejections(cmp, alpha = alpha)
#> $threshold
#> [1] 40
#> 
#> $tau_pq
#> [1] 79
#> 
#> $tau_qp
#> [1] NA
#> 
#> $reject_pq
#> [1] TRUE
#> 
#> $reject_qp
#> [1] FALSE
```

## Using lower-level functions directly

The wrapper is convenient, but the package also exposes the individual
pieces.

First compute the scores.

``` r
score_p <- brier_score(p, y)
score_q <- brier_score(q, y)

head(score_p)
#> [1] -0.1444 -0.1444 -0.1444 -0.1444 -0.1444 -0.1444
head(score_q)
#> [1] -0.25 -0.25 -0.25 -0.25 -0.25 -0.25
```

Then construct a confidence sequence.

``` r
cs <- cs_bernstein(
  scores1 = score_p,
  scores2 = score_q,
  alpha = 0.05,
  c = 2
)

head(cs)
#>   t estimate      lower     upper
#> 1 1   0.1056 -10.014906 10.226106
#> 2 2   0.1056  -4.954653  5.165853
#> 3 3   0.1056  -3.267902  3.479102
#> 4 4   0.1056  -2.424527  2.635727
#> 5 5   0.1056  -1.918501  2.129701
#> 6 6   0.1056  -1.581151  1.792351
```

And construct an e-process.

``` r
ep <- eprocess(
  scores1 = score_p,
  scores2 = score_q,
  alpha = 0.05,
  c = 2
)

head(ep)
#>   t     e_pq         e_qp   log_e_pq     log_e_qp
#> 1 1 1.034560 9.495389e-01 0.03397626  -0.05177881
#> 2 2 1.080177 9.099389e-01 0.07712494  -0.09437783
#> 3 3 1.128004 8.721567e-01 0.12044953  -0.13678622
#> 4 4 1.178151 8.361057e-01 0.16394647  -0.17900019
#> 5 5 1.230736 2.220446e-16 0.20761222 -36.04365339
#> 6 6 1.285880 2.220446e-16 0.25144328 -36.04365339
```

This gives the same core information as
[`compare_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_forecasts.md),
but with more manual control.

## Choosing a scoring rule

For binary probability forecasts, `"brier"` is the safest starting
point.

``` r
cmp_brier <- compare_forecasts(p, q, y, scoring_rule = "brier")
tail(cmp_brier)
#>       t score_p score_q  delta estimate      lower     upper    e_pq
#> 295 295 -0.1444   -0.25 0.1056   0.1056 0.07129320 0.1399068 2681618
#> 296 296 -0.1444   -0.25 0.1056   0.1056 0.07140910 0.1397909 2824574
#> 297 297 -0.1444   -0.25 0.1056   0.1056 0.07152422 0.1396758 2975161
#> 298 298 -0.1444   -0.25 0.1056   0.1056 0.07163857 0.1395614 3133784
#> 299 299 -0.1444   -0.25 0.1056   0.1056 0.07175215 0.1394478 3300873
#> 300 300 -0.1444   -0.25 0.1056   0.1056 0.07186498 0.1393350 3476882
#>             e_qp
#> 295 2.220446e-16
#> 296 2.220446e-16
#> 297 2.220446e-16
#> 298 2.220446e-16
#> 299 2.220446e-16
#> 300 2.220446e-16
```

The spherical score is also bounded and can be used with finite-sample
confidence sequences and e-processes.

``` r
cmp_spherical <- compare_forecasts(p, q, y, scoring_rule = "spherical")
tail(cmp_spherical)
#>       t   score_p   score_q     delta  estimate     lower     upper  e_pq
#> 295 295 0.8526013 0.7071068 0.1454945 0.1454945 0.1111877 0.1798013 1e+07
#> 296 296 0.8526013 0.7071068 0.1454945 0.1454945 0.1113036 0.1796854 1e+07
#> 297 297 0.8526013 0.7071068 0.1454945 0.1454945 0.1114187 0.1795702 1e+07
#> 298 298 0.8526013 0.7071068 0.1454945 0.1454945 0.1115330 0.1794559 1e+07
#> 299 299 0.8526013 0.7071068 0.1454945 0.1454945 0.1116466 0.1793423 1e+07
#> 300 300 0.8526013 0.7071068 0.1454945 0.1454945 0.1117595 0.1792295 1e+07
#>             e_qp
#> 295 2.220446e-16
#> 296 2.220446e-16
#> 297 2.220446e-16
#> 298 2.220446e-16
#> 299 2.220446e-16
#> 300 2.220446e-16
```

The logarithmic score is unbounded. Therefore
[`compare_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_forecasts.md)
uses an asymptotic confidence sequence by default and does not compute
an e-process.

``` r
cmp_log <- compare_forecasts(
  p = p,
  q = q,
  y = y,
  scoring_rule = "log",
  compute_e = FALSE
)

tail(cmp_log)
#>       t    score_p    score_q     delta  estimate     lower     upper e_pq e_qp
#> 295 295 -0.4780358 -0.6931472 0.2151114 0.2151114 0.1640597 0.2661631   NA   NA
#> 296 296 -0.4780358 -0.6931472 0.2151114 0.2151114 0.1642322 0.2659906   NA   NA
#> 297 297 -0.4780358 -0.6931472 0.2151114 0.2151114 0.1644035 0.2658193   NA   NA
#> 298 298 -0.4780358 -0.6931472 0.2151114 0.2151114 0.1645736 0.2656491   NA   NA
#> 299 299 -0.4780358 -0.6931472 0.2151114 0.2151114 0.1647427 0.2654801   NA   NA
#> 300 300 -0.4780358 -0.6931472 0.2151114 0.2151114 0.1649106 0.2653122   NA   NA
```

For binary log-score comparisons where the Winkler construction is
appropriate, use
[`winkler_compare()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_compare.md).

``` r
wcmp <- winkler_compare(p, q, y)

names(wcmp)
#> [1] "winkler_scores" "cs"             "etest_p_worse"  "etest_q_worse" 
#> [5] "rejections"
```

## Practical guidance

Use
[`compare_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_forecasts.md)
for the common workflow.

Use the lower-level functions when you want more control over the
scoring rule, confidence sequence, e-process, lag handling, or
predictable bounds.

For bounded binary or categorical scores such as Brier and spherical
scores, finite-sample confidence sequences and e-processes are
available.

For unbounded scores such as the log score, QLIKE, tick loss, and CRPS,
be more careful. Use asymptotic confidence sequences, Winkler scores
where applicable, or problem-specific predictable bounds.
