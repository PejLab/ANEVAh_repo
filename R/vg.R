#' @importFrom stats integrate
#'
NULL

#' Calculate Vg Estimates
#'
#' @inheritParams p_sr
#'
#' @return Vg estimates
#'
#' @keywords internal
#'
estimate_vg <- function(sigma) {
  return(integrate(
    f = formula_vg(sigma = sigma),
    lower = -4 * sigma,
    upper = 4 * sigma,
    sigma = sigma
  )$value)
}

#' Expectation Formula
#'
#' Expectation of \eqn{ln(e)} to be used in \code{\link{formula_vg}}
#'
#' @inheritParams p_sr
#'
#' @return A formula function
#'
#' @keywords internal
#'
formula_expectation <- function(sigma) {
  inner_formula <- function(sigma, sr) {
    return(log(x = exp(x = sr) + 1) * p_sr(sigma = sigma, sr = sr))
  }
  return(inner_formula)
}

#' Vg Formula
#'
#' ...
#'
#' @inheritParams p_sr
#'
#' @return A formula function
#'
#' @keywords internal
#'
formula_vg <- function(sigma) {
  inner_formula <- function(sigma, sr) {
    expect <- formula_expectation(sigma = sigma)
    expectation <- integrate(
      f = expect,
      lower = -4 * sigma,
      upper = 4 * sigma,
      sigma = sigma
    )$value
    formula <- ((log(x = exp(x = sr) + 1) - expectation) ^ 2) *
      p_sr(sigma = sigma, sr = sr)
    return(formula)
  }
  return(inner_formula)
}

#' Probability of SR
#'
#' @param sigma Standard deviation
#' @param sr Residual of regulatory variance
#'
#' @return ...
#'
#' @importFrom stats dnorm
#'
#' @keywords internal
#'
p_sr <- function(sigma, sr) {
  return(dnorm(x = sr, mean = 0, sd = sigma) * (1 / 0.999))
}
