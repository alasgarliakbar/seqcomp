# Package index

## Main workflows

- [`compare_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_forecasts.md)
  : Compare Two Sequential Forecasters
- [`compare_multiple_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_multiple_forecasts.md)
  : Compare Multiple Sequential Forecasters (SMCS)

## Sequential Model Confidence Sets (SMCS)

- [`smcs_strong()`](https://alasgarliakbar.github.io/seqcomp/reference/smcs_strong.md)
  : Sequential Model Confidence Set (Strong & Uniformly Weak Null)
- [`smcs_weak()`](https://alasgarliakbar.github.io/seqcomp/reference/smcs_weak.md)
  : Sequential Model Confidence Set (Weak Null)
- [`vovk_wang_merge()`](https://alasgarliakbar.github.io/seqcomp/reference/vovk_wang_merge.md)
  : Arithmetic-mean closed-testing e-value merge
- [`build_quantile_betting_arrays()`](https://alasgarliakbar.github.io/seqcomp/reference/build_quantile_betting_arrays.md)
  : Build 3D Parameter Arrays for Quantile Betting

## Confidence sequences

- [`cs_hoeffding()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_hoeffding.md)
  : Hoeffding-style confidence sequence (Theorem 1, Choe & Ramdas 2024)
- [`cs_bernstein()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_bernstein.md)
  : Empirical Bernstein confidence sequence (Theorem 2, Choe & Ramdas
  2024)
- [`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md)
  : Asymptotic confidence sequence (EC.3, Eq. EC.29, Choe & Ramdas 2024)

## E-processes

- [`eprocess()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess.md)
  : Sub-exponential mixture e-process (Theorem 3, Choe & Ramdas 2024)
- [`eprocess_betting()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_betting.md)
  : Betting-style e-process for the strong null hypothesis
- [`lambda_betting_quantile()`](https://alasgarliakbar.github.io/seqcomp/reference/lambda_betting_quantile.md)
  : Adaptive betting fraction for quantile-forecast strong-null tests
- [`eprocess_lag()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_lag.md)
  : Lag-h e-process for sequential forecast comparison (Propositions 5 &
  6)
- [`eprocess_predictable()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_predictable.md)
  : Fixed-lambda e-process with predictable bounds (Proposition EC.7)
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
  : Full Winkler comparison pipeline (Proposition EC.4)
- [`winkler_cs()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_cs.md)
  : One-sided empirical Bernstein CS for Winkler scores (Proposition
  EC.4)
- [`winkler_etest()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_etest.md)
  : E-process for Winkler scores (Proposition EC.4 + Theorem 3)

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
