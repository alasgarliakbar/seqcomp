# Score difference bounds for a named scoring rule

Returns lo, hi and the derived scale parameters c_thm1, c_thm23 for the
score difference process hat_delta_t = S(p, y) - S(q, y), in those cases
where a genuine, theorem-valid bound is available.

## Usage

``` r
score_bounds(scoring_rule)
```

## Arguments

- scoring_rule:

  Character. One of:

  - `"brier"`, `"spherical"` — bounded, exact finite-sample `c`.

  - `"winkler"` — descriptive helper for the one-sided CS on the log
    score.

  - `"tick"` — unbounded; returns `NULL` with guidance.

  - `"crps"`, `"crps_normal"`, `"crps_empirical"`, `"crps_std"` —
    unbounded; returns `NULL` with guidance.

  - `"log"`, `"qlike"` — unbounded; returns `NULL` with guidance.

## Value

Named list with elements lo, hi, c_thm1, c_thm23 for bounded rules, or
NULL for unbounded rules (with an informative message).

## Details

Convention (utils.R::score_diff_scales): c_thm1 = (hi - lo) / 2 \#
Theorem 1: \|delta_i\| \<= c c_thm23 = hi - lo \# Theorems 2 & 3:
\|delta_i\| \<= c/2

## Per-rule notes

- **Brier / Spherical** — individual scores lie in `[-1, 0]` (Brier) or
  `[0, 1]` (Spherical), so score differences lie in `[-1, 1]` either
  way. This bound is exact and yields finite-sample anytime-valid CS via
  Hoeffding/Bernstein.

- **Winkler** — bounded above by 1; the lower bound is
  problem-dependent, so `lo = -Inf` and only `hi = 1` is used, as a
  descriptive helper for the one-sided CS wrapper
  [`winkler_cs()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_cs.md).
  Not intended for generic Hoeffding/Bernstein use (Theorem 1 requires a
  finite symmetric interval).

- **Tick loss** — unbounded on general financial returns. Any bound
  derived from an empirical data range is ex-post and not
  filtration-respecting, so it cannot justify finite-sample anytime
  validity. Use
  [`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md)
  for tick comparisons.

- **CRPS** (normal, t, empirical) — unbounded, since both the predictive
  distributions and the realised outcomes are unbounded. A historical
  data range is again an ex-post surrogate and does not provide a
  theorem-valid `c` for Hoeffding/Bernstein. Use
  [`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md),
  or supply genuine ex ante bounds in problem-specific code if
  available.

- **Log / QLIKE** — both unbounded. For binary log-score comparisons,
  use
  [`winkler_score()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_score.md) +
  [`winkler_cs()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_cs.md)
  when the Winkler construction is appropriate. For categorical
  log-score, QLIKE, and other unbounded score differences, use
  [`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md),
  or
  [`eprocess_predictable()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_predictable.md)
  only with genuine ex ante predictable bounds.

## Examples

``` r
score_bounds("brier")
#> $lo
#> [1] -1
#> 
#> $hi
#> [1] 1
#> 
#> $c_thm1
#> [1] 1
#> 
#> $c_thm23
#> [1] 2
#> 
score_bounds("winkler")
#> $lo
#> [1] -Inf
#> 
#> $hi
#> [1] 1
#> 
#> $c_thm1
#> [1] NA
#> 
#> $c_thm23
#> [1] 2
#> 
```
