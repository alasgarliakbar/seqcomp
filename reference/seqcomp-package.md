# seqcomp: Sequential Comparison of Probabilistic Forecasts

`seqcomp` provides tools for comparing probabilistic forecasters
sequentially, following the anytime-valid framework of Choe and Ramdas
(2024). For three or more forecasters, the package additionally
implements Sequential Model Confidence Sets following Arnold,
Gavrilopoulos, Schulz and Ziegel (2026).

## Details

The package is built around the score difference

\$\$\hat{\delta}\_t = S(p_t, y_t) - S(q_t, y_t),\$\$

where scores are positively oriented, so larger values are better.
Positive score differences favour forecaster `p`; negative score
differences favour forecaster `q`.

## Main workflow

For most applications, start with
[`compare_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_forecasts.md).
It computes pointwise scores, running mean score differences, confidence
sequences, and e-processes in one call.

## Scoring rules

The package includes positively oriented scoring rules such as
[`brier_score()`](https://alasgarliakbar.github.io/seqcomp/reference/brier_score.md),
[`log_score()`](https://alasgarliakbar.github.io/seqcomp/reference/log_score.md),
[`spherical_score()`](https://alasgarliakbar.github.io/seqcomp/reference/spherical_score.md),
[`tick_loss()`](https://alasgarliakbar.github.io/seqcomp/reference/tick_loss.md),
[`qlike_score()`](https://alasgarliakbar.github.io/seqcomp/reference/qlike_score.md),
[`winkler_score()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_score.md),
[`crps_normal()`](https://alasgarliakbar.github.io/seqcomp/reference/crps_normal.md),
[`crps_empirical()`](https://alasgarliakbar.github.io/seqcomp/reference/crps_empirical.md),
and
[`crps_std()`](https://alasgarliakbar.github.io/seqcomp/reference/crps_std.md).

## Confidence sequences

Use
[`cs_hoeffding()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_hoeffding.md)
for Hoeffding-style confidence sequences,
[`cs_bernstein()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_bernstein.md)
for empirical Bernstein confidence sequences, and
[`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md)
for asymptotic confidence sequences when finite-sample boundedness is
not available.

## E-processes

Use
[`eprocess()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess.md)
for the main sub-exponential mixture e-process and
[`eprocess_rejections()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_rejections.md)
to extract first rejection times. For multi-step forecasts, see
[`eprocess_lag()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_lag.md).
For predictable time-varying bounds, see
[`eprocess_predictable()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_predictable.md).

## Multiple forecasters

For three or more candidate forecasters, use
[`compare_multiple_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_multiple_forecasts.md)
as the main entry point. It extends the pairwise workflow above to a
Sequential Model Confidence Set (SMCS): the running set of models not
yet shown to underperform some competitor. Lower-level access is
available via
[`smcs_strong()`](https://alasgarliakbar.github.io/seqcomp/reference/smcs_strong.md)
(strong or uniformly weak null, via closure testing) and
[`smcs_weak()`](https://alasgarliakbar.github.io/seqcomp/reference/smcs_weak.md)
(time-varying weak null, via joint confidence sequences), with
[`vovk_wang_merge()`](https://alasgarliakbar.github.io/seqcomp/reference/vovk_wang_merge.md)
and
[`eprocess_betting()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_betting.md)
as supporting building blocks, and
[`build_quantile_betting_arrays()`](https://alasgarliakbar.github.io/seqcomp/reference/build_quantile_betting_arrays.md)
for conditionally bounded scoring rules such as tick loss.

## Winkler scores

For binary probability forecasts with unbounded base scores, use
[`winkler_score()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_score.md),
[`winkler_cs()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_cs.md),
[`winkler_etest()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_etest.md),
or
[`winkler_compare()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_compare.md).

## References

Arnold, S., Gavrilopoulos, G., Schulz, B. and Ziegel, J. (2026).
Sequential model confidence sets. Journal of the Royal Statistical
Society Series B: Statistical Methodology, qkag066.

Choe, Y. J. and Ramdas, A. (2024). Comparing Sequential Forecasters.
Operations Research, 72(4), 1368-1387.

Howard, S. R., Ramdas, A., McAuliffe, J. and Sekhon, J. (2021).
Time-uniform, nonparametric, nonasymptotic confidence sequences. The
Annals of Statistics, 49(2), 1055-1080.
