#' BLN Likelihood
#'
#' Calculate the negative total log-likelihood from a Binomial-Logit-Normal
#' (BLN) distribution
#'
#' @inheritParams bln::dbln
#' @param ref_counts Reference counts
#' @param total_counts Total counts
#'
#' @return The negative log-likelihood
#'
#' @importFrom bln dbln
#' @importFrom pracma logit
#'
#' @keywords internal
#'
bln_likelihood <- function(ref_counts, total_counts, sd) {
  l <- dbln(x = ref_counts, size = total_counts, mean = logit(x = 0.5), sd = sd)
  nll <- -sum(log(x = l))
  return(nll)
}

#' Fit BLN
#'
#' Optimizer for finding sigma
#'
#' @inheritParams bln_likelihood
#'
#' @return Returns the estimate of the standard deviation of our BLN data (sigma)
#'
#' @importFrom stats optim
#'
#' @keywords internal
#'
fit_bln <- function(ref_counts, total_counts) {
  # start <- 0L
  mle_optim <- optim(
    par = 0L,
    fn = bln_likelihood,
    ref_counts = ref_counts,
    total_counts = total_counts,
    lower = 0.01,
    upper = 1.75,
    method = 'L-BFGS-B'
  )
  return(mle_optim$par)
}
