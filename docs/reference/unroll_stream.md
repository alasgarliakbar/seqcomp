# Unroll a stream-wise quantity back to the original time scale

After computing a per-stream cumulative quantity (e.g. e-process
values), restores them to the original length `T` by zero-padding the
first `k - 1` positions, repeating each stream value `h` times, then
truncating to length `T`.

## Usage

``` r
unroll_stream(stream_vals, k, h, T_)
```

## Arguments

- stream_vals:

  Numeric vector. Values for stream k (length ~ T/h).

- k:

  Integer. Stream index (1-based).

- h:

  Integer. Lag.

- T\_:

  Integer. Total original sequence length.

## Value

Numeric vector of length T\_.

## Alignment only, not theoretical updating

For lagged forecasts (`h >= 2`), the returned series is aligned to the
evaluated score-difference index after stream splitting. It should
**not** be interpreted as a process that updates at the original
forecast-issuance time. The unrolled process is for visualization and
alignment only; the theoretical validity argument relies strictly on the
streamwise sub-filtrations, not on this unrolled representation.

## Examples

``` r
unroll_stream(c(1, 2, 3), k = 2, h = 2, T_ = 6)
#> [1] 0 1 1 2 2 3
```
