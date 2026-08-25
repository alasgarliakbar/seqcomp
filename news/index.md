# Changelog

## seqcomp 0.2.0

### New Features

- Introduced Sequential Model Confidence Sets (SMCS) for multi-model
  evaluations, based on Arnold et al. (2026).
- Added
  [`compare_multiple_forecasts()`](https://alasgarliakbar.github.io/seqcomp/reference/compare_multiple_forecasts.md)
  as a high-level wrapper to sequentially compare 3 or more forecasters
  simultaneously.
- Added
  [`smcs_strong()`](https://alasgarliakbar.github.io/seqcomp/reference/smcs_strong.md)
  and
  [`smcs_weak()`](https://alasgarliakbar.github.io/seqcomp/reference/smcs_weak.md)
  to construct confidence sets under the strong, uniformly weak, and
  weak null hypotheses.
- Implemented predictable betting-style e-processes
  ([`eprocess_betting()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_betting.md))
  and adaptive betting fractions for quantile forecasts
  ([`lambda_betting_quantile()`](https://alasgarliakbar.github.io/seqcomp/reference/lambda_betting_quantile.md)).
- Added
  [`vovk_wang_merge()`](https://alasgarliakbar.github.io/seqcomp/reference/vovk_wang_merge.md)
  for highly efficient $`O(m \log m)`$ closed-testing e-value merging.

### Minor Improvements & Fixes

- Updated documentation and citations to reflect the official
  publication of Choe & Ramdas (2024) in *Operations Research*, 72(4).

## seqcomp 0.1.0

CRAN release: 2026-06-30

- Initial CRAN submission.
