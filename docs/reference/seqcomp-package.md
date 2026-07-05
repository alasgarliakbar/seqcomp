# seqcomp: Sequential Comparison of Probabilistic Forecasts

`seqcomp` provides tools for comparing probabilistic forecasters
sequentially, following the anytime-valid framework of Choe and Ramdas
(2024).

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

## Winkler scores

For binary probability forecasts with unbounded base scores, use
[`winkler_score()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_score.md),
[`winkler_cs()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_cs.md),
[`winkler_etest()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_etest.md),
or
[`winkler_compare()`](https://alasgarliakbar.github.io/seqcomp/reference/winkler_compare.md).

## References

Choe, Y. J. and Ramdas, A. (2024). Comparing Sequential Forecasters.
Operations Research, 72(4), 1368-1387.

Howard, S. R., Ramdas, A., McAuliffe, J. and Sekhon, J. (2021).
Time-uniform, nonparametric, nonasymptotic confidence sequences. The
Annals of Statistics, 49(2).
