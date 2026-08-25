# =============================================================================
# compare_multiple_forecasts.R
# High-level wrapper for sequential comparison of multiple probabilistic forecasters
#
# This file provides a user-facing pipeline around the multi-model SMCS building
# blocks. It abstracts away the matrix/array wrangling and directly returns
# inclusion matrices for the evaluated models over time.
#
# 1. Computes pointwise scores for all models,
# 2. Automatically constructs bounding arrays for conditionally bounded rules (e.g. tick),
# 3. Constructs the Sequential Model Confidence Set (SMCS) under the strong null,
# 4. Constructs the SMCS under the weak null (for uniformly bounded rules).
# =============================================================================

#' Compare Multiple Sequential Forecasters (SMCS)
#'
#' Evaluates an arbitrary number of candidate forecasters simultaneously,
#' constructing Sequential Model Confidence Sets (SMCS) that maintain
#' family-wise error rate control over time.
#'
#' This is a high-level wrapper that automates pointwise score calculation,
#' boundary generation, and multiplicity corrections via [smcs_strong()] and
#' [smcs_weak()]. For conditionally bounded rules like `"tick"` loss, it
#' automatically builds the dynamic 3D arrays required for adaptive betting.
#'
#' @param forecasts A \eqn{T \times m} matrix of forecasts. For binary/categorical
#'   probability forecasts, these should be matrices of probabilities. For quantile
#'   forecasts, these should be raw predicted quantiles.
#'   *Note:* to replicate the log-scale bounds of the Arnold et al. (2026)
#'   Covid-19 study, pass log-transformed forecasts and outcomes.
#' @param outcomes A numeric vector of \eqn{T} realised outcomes.
#' @param scoring_rule Character. Scoring rule used to compare forecasts.
#'   Currently supports `"brier"`, `"spherical"`, and `"tick"`.
#' @param cs_method Character. Confidence sequence method for the weak null:
#'   `"bernstein"` or `"hoeffding"`. Default is `"bernstein"`.
#' @param tau Numeric in `(0, 1)`. The quantile level. Required only if
#'   `scoring_rule = "tick"`.
#' @param alpha Numeric in `(0, 1)`. Family-wise significance level. Default is `0.05`.
#' @param v_opt Numeric > 0. Intrinsic time at which the weak-null confidence sequence
#'   is tuned to be tightest. Default is `10`.
#' @param clip_max Numeric. Maximum e-process value before clipping in the strong-null
#'   test. Default is `1e7`.
#'
#' @return A list containing:
#' \describe{
#'   \item{`scores`}{A \eqn{T \times m} matrix of evaluated pointwise scores.}
#'   \item{`smcs_strong`}{A \eqn{T \times m} logical matrix tracking inclusion in the
#'     strong-null SMCS over time (permanent exclusions).}
#'   \item{`smcs_weak`}{A \eqn{T \times m} logical matrix tracking inclusion in the
#'     weak-null SMCS over time (models can exit and re-enter). Currently `NULL`
#'     for `"tick"` loss.}
#' }
#'
#' @examples
#' set.seed(42)
#' T_sim <- 100
#' y <- rbinom(T_sim, 1, 0.5)
#'
#' # Create 3 forecasters:
#' # M1 is a perfect oracle (always predicts the true y)
#' # M2 is slightly noisy (adds small uniform noise to y)
#' # M3 is an anti-oracle (predicts the exact opposite of y)
#' fcsts <- matrix(NA, nrow = T_sim, ncol = 3)
#' fcsts[, 1] <- y
#' fcsts[, 2] <- abs(y - runif(T_sim, 0, 0.1))
#' fcsts[, 3] <- 1 - y
#' colnames(fcsts) <- c("M1", "M2", "M3")
#'
#' out <- compare_multiple_forecasts(fcsts, y, scoring_rule = "brier")
#'
#' # Print the object to see exclusions (M3 will be dropped rapidly)
#' out
#'
#' # View how the set sizes shrink over time
#' summary(out)
#'
#' @export
compare_multiple_forecasts <- function(forecasts, outcomes,
                                       scoring_rule = c("brier", "spherical", "tick"),
                                       cs_method = c("bernstein", "hoeffding"),
                                       tau = NULL, alpha = 0.05,
                                       v_opt = 10, clip_max = 1e7) {
  scoring_rule <- match.arg(scoring_rule)
  cs_method <- match.arg(cs_method)
  Tt <- nrow(forecasts)
  m <- ncol(forecasts)
  stopifnot(length(outcomes) == Tt)

  scores_mat <- matrix(0, nrow = Tt, ncol = m)
  colnames(scores_mat) <- colnames(forecasts)
  if (is.null(colnames(scores_mat))) {
    colnames(scores_mat) <- paste0("Model_", seq_len(m))
  }

  for (i in seq_len(m)) {
    if (scoring_rule == "brier") {
      scores_mat[, i] <- brier_score(forecasts[, i], outcomes)
    } else if (scoring_rule == "spherical") {
      scores_mat[, i] <- spherical_score(forecasts[, i], outcomes)
    } else if (scoring_rule == "tick") {
      if (is.null(tau)) stop("tau must be provided for tick_loss.")
      scores_mat[, i] <- tick_loss(forecasts[, i], outcomes, tau)
    }
  }

  if (scoring_rule %in% c("brier", "spherical")) {
    c_param_strong <- 2
    c_param_weak <- if (cs_method == "hoeffding") 1 else 2

    smcs_s <- smcs_strong(scores_mat, alpha = alpha, method = "betting",
                          c_param = c_param_strong, clip_max = clip_max)
    smcs_w <- smcs_weak(scores_mat, alpha = alpha, cs_method = cs_method,
                        c_param = c_param_weak, v_opt = v_opt)

  } else if (scoring_rule == "tick") {
    bnds <- build_quantile_betting_arrays(forecasts, scores_mat, tau)
    smcs_s <- smcs_strong(
      scores_mat, alpha = alpha, method = "betting",
      c_param = bnds$c_array, lambda_param = bnds$lambda_array, clip_max = clip_max
    )

    warning("smcs_weak is currently omitted for unbounded tick loss in this wrapper (requires transformation).")
    smcs_w <- NULL
  }

  result <- list(
    scores       = scores_mat,
    smcs_strong  = smcs_s$smcs,
    smcs_weak    = if (!is.null(smcs_w)) smcs_w$smcs else NULL,
    alpha        = alpha,
    scoring_rule = scoring_rule
  )
  class(result) <- "seqcomp_multi"
  return(result)
}

#' Print method for seqcomp_multi objects
#'
#' @param x A `seqcomp_multi` object.
#' @param ... Additional arguments passed to print.
#' @export
#' @noRd
print.seqcomp_multi <- function(x, ...) {
  Tt <- nrow(x$scores)
  m  <- ncol(x$scores)
  model_names <- colnames(x$scores)
  if (is.null(model_names)) model_names <- paste0("Model_", seq_len(m))

  cat(sprintf("<seqcomp multi-model comparison>\n"))
  cat(sprintf("  %d models, %d time steps, alpha = %.3g, scoring rule = '%s'\n\n",
              m, Tt, x$alpha, x$scoring_rule))

  first_excluded <- function(mat) {
    apply(mat, 2, function(col) {
      idx <- which(!col)
      if (length(idx) == 0) NA_integer_ else idx[1]
    })
  }

  summarise_one <- function(mat, label, is_weak = FALSE) {
    if (is.null(mat)) return(invisible(NULL))
    fe <- first_excluded(mat)

    status <- ifelse(mat[Tt, ], "included", "excluded")

    # Highlight re-entry for the weak null
    if (is_weak) {
      reentered <- mat[Tt, ] & !is.na(fe)
      status[reentered] <- "included (re-entered)"
    }

    df <- data.frame(
      model         = model_names,
      status_at_T   = status,
      first_dropped = ifelse(is.na(fe), "-", fe)
    )

    cat(sprintf("-- %s --\n", label))
    print(df, row.names = FALSE)
    cat(sprintf("   final set size: %d -> %d\n\n", m, sum(mat[Tt, ])))
  }

  summarise_one(x$smcs_strong, "Strong-null SMCS (Permanent Exclusion)", is_weak = FALSE)
  summarise_one(x$smcs_weak,   "Weak-null SMCS (Dynamic Re-entry)", is_weak = TRUE)

  cat("Use `x$smcs_strong` / `x$smcs_weak` for full inclusion matrices, or `x$scores` for pointwise scores.\n")
  invisible(x)
}

#' Summary method for seqcomp_multi objects
#'
#' @param object A `seqcomp_multi` object.
#' @param checkpoints Numeric vector of quantiles for the timeline.
#' @param ... Additional arguments.
#' @export
#' @noRd
summary.seqcomp_multi <- function(object, checkpoints = c(0, 0.25, 0.5, 0.75, 1), ...) {
  Tt  <- nrow(object$scores)
  idx <- unique(pmax(1, round(checkpoints * Tt)))

  set_size <- function(mat) {
    if (is.null(mat)) rep(NA_integer_, length(idx)) else rowSums(mat[idx, , drop = FALSE])
  }

  df <- data.frame(
    t               = idx,
    strong_set_size = set_size(object$smcs_strong),
    weak_set_size   = set_size(object$smcs_weak)
  )
  return(df)
}
