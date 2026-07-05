# Package index

## Main workflow

- [`compare_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_forecasts.md)
  : Compare Two Sequential Forecasters

## Confidence sequences

- [`cs_hoeffding()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_hoeffding.md)
  : Hoeffding-style confidence sequence (Theorem 1, Choe & Ramdas 2023)
- [`cs_bernstein()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_bernstein.md)
  : Empirical Bernstein confidence sequence (Theorem 2, Choe & Ramdas
  2023)
- [`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md)
  : Asymptotic confidence sequence (Appendix C, Eq. 55, Choe & Ramdas
  2023)

## E-processes

- [`eprocess()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess.md)
  : Sub-exponential mixture e-process (Theorem 3, Choe & Ramdas 2023)
- [`eprocess_lag()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_lag.md)
  : Lag-h e-process for sequential forecast comparison (Propositions 5 &
  6)
- [`eprocess_predictable()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_predictable.md)
  : Fixed-lambda e-process with predictable bounds (Proposition 7)
- [`eprocess_rejections()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_rejections.md)
  : Determine rejection times for an e-process output
- [`predictable_rejections()`](https://alasgarliakbar.github.io/seqcomp/reference/predictable_rejections.md)
  : Summarise predictable bounds e-process

## Scoring rules

- [`brier_score()`](https://alasgarliakbar.github.io/seqcomp/reference/brier_score.md)
  : Brier score for binary and categorical forecasts
- [`log_score()`](https://alasgarliakbar.github.io/seqcomp/reference/log_score.md)
  : Logarithmic score for binary and categorical forecasts
- [`spherical_score()`](https://alasgarliakbar.github.io/seqcomp/reference/spherical_score.md)
  : Spherical score for binary and categorical forecasts
- [`winkler_score()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_score.md)
  : Winkler-normalized binary score
- [`crps_empirical()`](https://alasgarliakbar.github.io/seqcomp/reference/crps_empirical.md)
  : Negated CRPS for empirical predictive distributions
- [`crps_normal()`](https://alasgarliakbar.github.io/seqcomp/reference/crps_normal.md)
  : Negated CRPS for normal predictive distributions
- [`crps_std()`](https://alasgarliakbar.github.io/seqcomp/reference/crps_std.md)
  : Negated CRPS for Student-t predictive distributions
- [`tick_loss()`](https://alasgarliakbar.github.io/seqcomp/reference/tick_loss.md)
  : Negated tick loss for quantile forecasts
- [`qlike_score()`](https://alasgarliakbar.github.io/seqcomp/reference/qlike_score.md)
  : Negated QLIKE score for variance forecasts

## Boundaries

- [`cm_boundary()`](https://alasgarliakbar.github.io/seqcomp/reference/cm_boundary.md)
  : Normal mixture (CM) boundary
- [`ge_boundary()`](https://alasgarliakbar.github.io/seqcomp/reference/ge_boundary.md)
  : Gamma-exponential mixture boundary
- [`ps_boundary()`](https://alasgarliakbar.github.io/seqcomp/reference/ps_boundary.md)
  : Polynomial stitched (PS) boundary
- [`rho_from_vopt()`](https://alasgarliakbar.github.io/seqcomp/reference/rho_from_vopt.md)
  : Convert optimal intrinsic time to rho

## Winkler procedures

- [`winkler_compare()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_compare.md)
  : Full Winkler comparison pipeline (Proposition 4)
- [`winkler_cs()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_cs.md)
  : One-sided empirical Bernstein CS for Winkler scores (Proposition 4)
- [`winkler_etest()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_etest.md)
  : E-process for Winkler scores (Proposition 4 + Theorem 3)

## Utilities

- [`score_bounds()`](https://alasgarliakbar.github.io/seqcomp/reference/score_bounds.md)
  : Score difference bounds for a named scoring rule
- [`score_diff_scales()`](https://alasgarliakbar.github.io/seqcomp/reference/score_diff_scales.md)
  : Score difference bounds -\> sub-Gaussian / sub-exponential scale
- [`split_streams()`](https://alasgarliakbar.github.io/seqcomp/reference/split_streams.md)
  : Split a sequence into h interleaved lag streams
- [`unroll_stream()`](https://alasgarliakbar.github.io/seqcomp/reference/unroll_stream.md)
  : Unroll a stream-wise quantity back to the original time scale
- [`calibrate_p_to_e()`](https://alasgarliakbar.github.io/seqcomp/reference/calibrate_p_to_e.md)
  : P-to-e calibrator
- [`seqcomp-package`](https://alasgarliakbar.github.io/seqcomp/reference/seqcomp-package.md)
  [`seqcomp`](https://alasgarliakbar.github.io/seqcomp/reference/seqcomp-package.md)
  : seqcomp: Sequential Comparison of Probabilistic Forecasts
