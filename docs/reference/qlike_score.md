# Negated QLIKE score for variance forecasts

Computes the positively oriented (negated) QLIKE quasi-likelihood loss
for variance forecasts.

## Usage

``` r
qlike_score(sigma2_hat, sigma2)
```

## Arguments

- sigma2_hat:

  Numeric vector. Forecast variance (strictly positive).

- sigma2:

  Numeric vector. Realised variance (strictly positive).

## Value

Numeric vector of negated QLIKE scores. Higher is better. Maximum value
is 0, achieved at a perfect forecast `sigma2_hat = sigma2`. Unbounded
below.

## Details

Standard QLIKE loss is \$\$L\_{QL}(\hat\sigma^2, \sigma^2) =
\frac{\sigma^2}{\hat\sigma^2} - \log\frac{\sigma^2}{\hat\sigma^2} -
1.\$\$ This is loss-oriented (lower = better, minimum 0 at a perfect
forecast), so the function negates it: \\S\_{QL} = -L\_{QL}\\.

Literature note: some sources define QLIKE as
`log(sigma2_hat) + sigma2 / sigma2_hat`, which differs by constants from
the form above. Here the loss is normalised to have minimum 0 and is
then negated for positive orientation.

## Unbounded below

QLIKE is unbounded below. It should not be used directly with the
finite-sample bounded-difference confidence sequences or e-processes.
Use
[`cs_asymptotic()`](https://alasgarliakbar.github.io/seqcomp/reference/cs_asymptotic.md)
for QLIKE-based confidence sequences, or use
[`eprocess_predictable()`](https://alasgarliakbar.github.io/seqcomp/reference/eprocess_predictable.md)
only when genuine ex ante predictable bounds are available. QLIKE is not
compatible with the Winkler construction because Winkler scores are
restricted to binary outcomes and probability forecasts.

## Examples

``` r
sigma2_hat <- c(1.0, 1.5, 2.0)
sigma2 <- c(1.1, 1.4, 2.2)
qlike_score(sigma2_hat, sigma2)
#> [1] -0.004689820 -0.002326205 -0.004689820
```
