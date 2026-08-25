# =============================================================================
# etests.R
# Sequential e-processes for testing the weak null hypothesis
#
# Implements:
#   eprocess()                — Theorem 3 CR24: sub-exponential mixture e-process
#   eprocess_betting()        — Proposition 3.2 A26: product-form betting
#                               e-process (strong null)
#   lambda_betting_quantile() — Section 5.1 A26: adaptive betting fraction for
#                               quantile forecasts
#
# The weak null being tested:
#   H_0^w(p, q): Delta_t = (1/t) * sum_{i=1}^t E[hat_delta_i | F_{i-1}] <= 0
#   for all t = 1, 2, ...
#   i.e. forecaster 1 is no better than forecaster 2 on average.
#   Tested via exponential-mixture martingales.
#
# The strong null being tested:
#   H_0^s(p, q): mu_t = E[hat_delta_t | F_{t-1}] <= 0 for all t = 1, 2, ...
#   i.e. forecaster 1 is no better than forecaster 2 at every time step.
#   Tested via product-form predictable betting martingales.
#
# References:
#   CR24  Choe & Ramdas (2024), Operations Research 72(4)
#   H21   Howard et al. (2021), Annals of Statistics 49(2)
#   A26   Arnold et al. (2026), J R Stat Soc B 88, qkag066
# =============================================================================

#' Sub-exponential mixture e-process (Theorem 3, Choe & Ramdas 2024)
#'
#' Constructs two simultaneous one-sided e-processes for sequentially testing
#' whether forecaster 1 (p) outperforms forecaster 2 (q) or vice versa.
#'
#' The mixture e-process at time t is:
#' \deqn{E_t^{\mathrm{mix}} = m(S_t, \hat{V}_t)}
#' where \eqn{S_t = \sum_{i=1}^t \hat{\delta}_i},
#' \eqn{\hat{V}_t = \sum_{i=1}^t (\hat{\delta}_i - \gamma_i)^2},
#' and \eqn{m(s, v)} is the Gamma-Exponential mixture function (Proposition EC.3,
#' CR24).
#'
#' @param scores1   Numeric vector. Scores S(p_t, y_t) for forecaster 1.
#' @param scores2   Numeric vector. Scores S(q_t, y_t) for forecaster 2.
#' @param alpha     Numeric in (0,1). Significance level. Rejection threshold
#'                  is 2/alpha for the two-sided test. Default: 0.05.
#' @param c         Numeric > 0. Sub-exponential scale. Must satisfy
#'                  |hat_delta_i| <= c/2 for all i.
#'                  For score differences in `[-(b-a), b-a]`: c = 2*(b-a).
#'                  Default: 2 (for Brier score differences in `[-1,1]`).
#' @param v_opt     Numeric > 0. Intrinsic time at which e-process grows
#'                  fastest. Default: 10 (recommended by CR24).
#' @param alpha_opt Numeric in (0,1). One-sided alpha used to compute rho.
#'                  Default: alpha/2 (matches comparecast two-sided convention).
#' @param gammas    Numeric vector or NULL. Predictable centering sequence.
#'                  If NULL, constructed as lagged running mean.
#' @param clip_max  Numeric. Maximum e-process value before clipping.
#'                  Default: 1e7 (matches Python comparecast).
#'
#' @return data.frame with the following columns:
#' \describe{
#'  \item{`t`}{Time index.}
#'  \item{`e_pq`, `e_qp`}{One-sided e-processes. `e_pq` tests H_0^w(p, q):
#'  whether forecaster `p` outperforms `q`; `e_qp` tests H_0^w(q, p): whether
#'  forecaster `q` outperforms `p`.}
#'  \item{`log_e_pq`, `log_e_qp`}{Log-scale values of the e-processes, clipped
#'  at log(clip_max).}
#'  }
#'
#'
#' @section Rejection rule:
#' At level `alpha`: reject \eqn{H_0^w(p, q)} (conclude `p` outperforms `q`)
#' when `e_pq >= 2/alpha`; reject \eqn{H_0^w(q, p)} (conclude `q` outperforms
#' `p`) when `e_qp >= 2/alpha`. Use `eprocess_rejections()` to extract the
#' first crossing time for each.
#'
#' @details
#'   VARIANCE PROCESS: The intrinsic time V_hat_t uses NO floor (unlike the
#'   EB CS). The GE mixture m(s, v) is well-defined at v=0 (returns 1 when
#'   s=0), so no floor is needed. Adding a floor would yield less power in
#'   the e-process.
#'
#'   SCALE CONVENTION: c is the sub-exponential scale parameter such that
#'   |hat_delta_i| <= c/2. This is the Theorems 2 & 3 convention from CR24.
#'   For Brier score differences in `[-1,1]`: c = 2.
#'   For Winkler scores (bounded above by 1): c = 2.
#'
#'   LOG-SPACE: E-process values are computed in log-space and clipped before
#'   exponentiating to avoid numerical overflow.
#'
#' @examples
#' scores1 <- c(-0.04, -0.09, -0.01, -0.16)
#' scores2 <- c(-0.09, -0.16, -0.04, -0.25)
#' ep <- eprocess(scores1, scores2, alpha = 0.05)
#' head(ep)
#'
#' @export
eprocess <- function(scores1, scores2,
                     alpha     = 0.05,
                     c         = 2,
                     v_opt     = 10,
                     alpha_opt = NULL,
                     gammas    = NULL,
                     clip_max  = 1e7) {

  stopifnot(
    length(scores1) == length(scores2),
    length(scores1) >= 1,
    alpha > 0, alpha < 1,
    c > 0,
    v_opt > 0,
    clip_max > 0
  )

  # Default alpha_opt: half of alpha for two-sided test
  if (is.null(alpha_opt)) alpha_opt <- alpha / 2

  xs <- scores1 - scores2
  T_ <- length(xs)

  # Predictable centering sequence
  if (is.null(gammas)) {
    gammas <- make_gammas(xs, lag = 1)
  } else {
    stopifnot(length(gammas) == T_)
  }

  # Tuning parameter rho from v_opt and alpha_opt
  rho <- rho_from_vopt(v_opt = v_opt, alpha = alpha_opt)

  # Compute shared variance process (sign-invariant)
  V_shared <- intrinsic_time(xs, gammas, floor = FALSE)
  S_pq     <- cumsum(xs)
  S_qp     <- -S_pq

  log_e_pq <- log_ge_mixture_from_sv(S_pq, V_shared, rho, c)
  log_e_qp <- log_ge_mixture_from_sv(S_qp, V_shared, rho, c)

  # Clip and exponentiate
  e_pq <- clip_eprocess(log_e_pq, clip_max = clip_max)
  e_qp <- clip_eprocess(log_e_qp, clip_max = clip_max)

  data.frame(
    t        = seq_len(T_),
    e_pq     = e_pq,
    e_qp     = e_qp,
    log_e_pq = pmin(log_e_pq, log(clip_max)),
    log_e_qp = pmin(log_e_qp, log(clip_max))
  )
}

#' Determine rejection times for an e-process output
#'
#' @param ep      data.frame. Output of eprocess().
#' @param alpha   Numeric. Significance level. Threshold is 2/alpha.
#'
#' @return Named list with elements:
#' * `threshold` — rejection threshold (`2 / alpha`).
#' * `tau_pq` — first `t` where `e_pq >= threshold` (`NA` if never crossed).
#' * `tau_qp` — first `t` where `e_qp >= threshold` (`NA` if never crossed).
#' * `reject_pq` — logical: was \eqn{H_0^w(p,q)} ever rejected?
#' * `reject_qp` — logical: was \eqn{H_0^w(q,p)} ever rejected?
#'
#' @examples
#' scores1 <- c(-0.04, -0.09, -0.01, -0.16)
#' scores2 <- c(-0.09, -0.16, -0.04, -0.25)
#' ep <- eprocess(scores1, scores2, alpha = 0.05)
#' eprocess_rejections(ep, alpha = 0.05)
#'
#' @export
eprocess_rejections <- function(ep, alpha = 0.05) {
  threshold <- 2 / alpha

  tau_pq <- which(ep$e_pq >= threshold)
  tau_qp <- which(ep$e_qp >= threshold)

  list(
    threshold  = threshold,
    tau_pq     = if (length(tau_pq) > 0) tau_pq[1] else NA_integer_,
    tau_qp     = if (length(tau_qp) > 0) tau_qp[1] else NA_integer_,
    reject_pq  = length(tau_pq) > 0,
    reject_qp  = length(tau_qp) > 0
  )
}

#' Betting-style e-process for the strong null hypothesis
#'
#' Implements the product-form test martingale
#' \deqn{E_t = \prod_{r=1}^{t} (1 + \lambda_r \hat\delta_r)}
#' for testing the strong null \eqn{H_0^s(p, q): \delta_t \le 0} for all t.
#'
#' @param scores1 Numeric vector. Scores S(p_t, y_t) for forecaster 1.
#' @param scores2 Numeric vector. Scores S(q_t, y_t) for forecaster 2.
#' @param c_t Numeric scalar or vector (same length as scores) of predictable bounds
#'   such that |scores1 - scores2| <= c_t / 2 almost surely at every step.
#' @param lambda_t Optional numeric vector of predictable betting fractions in
#'   `[0, 1/c_t]`. If `NULL` (default), uses the fixed fraction `lambda_t = 1 / (2 * c_t)`.
#' @param clip_max Numeric. Maximum e-process value before clipping. Default: 1e7.
#'
#' @return data.frame with columns t, e_pq, e_qp, log_e_pq, log_e_qp.
#'
#' @export
eprocess_betting <- function(scores1, scores2, c_t, lambda_t = NULL, clip_max = 1e7) {
  stopifnot(
    length(scores1) == length(scores2),
    length(scores1) >= 1,
    clip_max > 0
  )

  t_len <- length(scores1)
  xs <- scores1 - scores2

  if (length(c_t) == 1L) {
    c_t <- rep(c_t, t_len)
  }

  if (length(c_t) != t_len) {
    stop("c_t must be a scalar or a vector of the same length as scores1/scores2.")
  }
  if (any(c_t <= 0)) {
    stop("c_t must be strictly positive at every step.")
  }

  if (is.null(lambda_t)) {
    lambda_t <- 1 / (2 * c_t)
  }
  stopifnot(length(lambda_t) == t_len)

  if (any(lambda_t < 0) || any(lambda_t > 1 / c_t + 1e-8)) {
    stop("lambda_t must lie in [0, 1/c_t] at every step.")
  }

  terms_pq <- 1 + lambda_t * xs
  terms_qp <- 1 - lambda_t * xs

  if (any(terms_pq <= 0) || any(terms_qp <= 0)) {
    stop("A betting factor was non-positive; check that |scores1 - scores2| <= c_t / 2 at every step.")
  }

  log_e_pq <- cumsum(log(terms_pq))
  log_e_qp <- cumsum(log(terms_qp))

  data.frame(
    t        = seq_len(t_len),
    e_pq     = clip_eprocess(log_e_pq, clip_max = clip_max),
    e_qp     = clip_eprocess(log_e_qp, clip_max = clip_max),
    log_e_pq = pmin(log_e_pq, log(clip_max)),
    log_e_qp = pmin(log_e_qp, log(clip_max))
  )
}

#' Adaptive betting fraction for quantile-forecast strong-null tests
#'
#' Implements the quantile-specific adaptive betting scheme of Arnold et al. (2026),
#' translating their log-scale loss convention to seqcomp's positively-oriented scores.
#'
#' @note
#' **Scale Translation:** This function assumes `p_t`, `q_t`, and `delta_hat_lag1`
#' are calculated on the raw, linear scale. To replicate the exact log-scale bounds
#' used in the Arnold et al. (2026) Covid-19 case study, the forecast vectors
#' passed to this function must be log-transformed prior to evaluation.
#'
#' @param p_t Numeric vector. Quantile forecasts of the first forecaster.
#' @param q_t Numeric vector. Quantile forecasts of the second forecaster.
#' @param tau Numeric scalar in (0, 1). The quantile level.
#' @param delta_hat_lag1 Numeric vector. The *previous* step's score difference.
#'   Must have `delta_hat_lag1[1] = 0`.
#' @param eps Numeric. Safeguard against division by zero. Default: 1e-8.
#'
#' @return A list with `c_t` and `lambda_t` vectors for `eprocess_betting()`.
#'
#' @export
lambda_betting_quantile <- function(p_t, q_t, tau, delta_hat_lag1 = NULL, eps = 1e-8) {
  t_len <- length(p_t)
  if (length(q_t) != t_len) stop("p_t and q_t must have the same length.")
  if (tau <= 0 || tau >= 1) stop("tau must lie strictly between 0 and 1.")

  if (is.null(delta_hat_lag1)) {
    delta_hat_lag1 <- c(0, rep(NA_real_, t_len - 1))
  }
  if (length(delta_hat_lag1) != t_len) stop("delta_hat_lag1 must have the same length as p_t.")
  if (t_len > 1 && anyNA(delta_hat_lag1[-1])) {
    stop("delta_hat_lag1 must supply the previous step's score difference for t >= 2.")
  }

  c_t <- 2 * max(tau, 1 - tau) * abs(p_t - q_t)

  u <- abs(tau - 0.5)
  K_t <- ((2 - u) / (1 + u)) * ((3 * pi / 2 + atan(delta_hat_lag1)) / pi)

  lambda_t <- 1 / (K_t * c_t + eps)

  list(c_t = c_t, lambda_t = lambda_t)
}

