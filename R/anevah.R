#' ANEVA-H
#'
#' Fits data to BLN distribution using likelihood function, then estimates Vgs
#'
#' @param ref_table Data frame of reference counts, see below for more details
#' @param alt_table Data frame of alternate counts, see below for more details
#' @param min_occurances Minimum number of people who contain the gene
#' @param min_cases Minimum number of samples for gene expression
#' @param min_expr Minimum expression of a gene
#'
#' @details
#' The reference and alternate counts tables should be data frames. The rows
#' should be genes (must be named) and the columns should be samples (names
#' optional). For example:
#' \preformatted{
#'         Sample1    Sample2
#' gene1        0          3
#' gene2        1          2
#' }
#' \code{ref_table} and \code{alt_table} must have the same dimensions
#'
#' @return A data frame with two columns:
#' \describe{
#'  \item{\dQuote{GENE_ID}}{The gene ID}
#'  \item{\dQuote{Vg}}{The Vg estimate}
#' }
#'
#' @importFrom stats na.omit
#'
#' @export
#'
anevah <- function(
  ref_table,
  alt_table,
  min_occurances = 10L,
  min_cases = 6L,
  min_expr = 30L
) {
  if (!identical(x = dim(x = ref_table), y = dim(x = alt_table))) {
    stop("'ref_table' and 'alt_table' must be the same dimensions")
  }
  if (is.null(x = rownames(x = ref_table)) || is.null(x = rownames(x = alt_table))) {
    stop("Tables are missing gene names")
  }
  if (!identical(x = sort(x = rownames(x = ref_table)), y = sort(x = rownames(x = alt_table)))) {
    stop("Mismatched genes between reference and alternate tables")
  }
  if (anyDuplicated(x = rownames(x = ref_table))) {
    warning("Duplicate gene IDs, making unique", immediate. = TRUE)
    rownames(x = ref_table) <- make.unique(names = rownames(x = ref_table))
    rownames(x = alt_table) <- make.unique(names = rownames(x = alt_table))
  }
  vgs <- vector(mode = 'numeric', length = nrow(x = ref_table))
  names(x = vgs) <- rownames(x = ref_table)
  for (i in seq_along(along.with = vgs)) {
    gene <- rownames(x = ref_table)[i]
    ref_counts <- unlist(x = ref_table[gene, , drop = TRUE])
    alt_counts <- unlist(x = alt_table[gene, , drop = TRUE])
    total_counts <- ref_counts + alt_counts
    if (sum(total_counts > 0) < min_occurances) {
      warning(
        "Not enough expression for ",
        gene,
        call. = FALSE,
        immediate. = TRUE
      )
      vgs[gene] <- NA_real_
      next
    }
    if (sum(total_counts >= min_expr) < min_cases) {
      warning(
        "Not enough samples expressing ",
        gene,
        call. = FALSE,
        immediate. = TRUE
      )
      vgs[gene] <- NA_real_
      next
    }
    nll <- bln_likelihood(
      ref_counts = ref_counts,
      total_counts = total_counts,
      sd = 0L
    )
    if (is.infinite(x = nll)) {
      vgs[gene] <- NA_real_
      next
    }
    message("Calculating Vgs for ", gene)
    sigma <- fit_bln(ref_counts = ref_counts, total_counts = total_counts)
    vg <- estimate_vg(sigma = sigma)
    vgs[gene] <- vg
  }
  vgs <- na.omit(object = vgs)
  return(data.frame(
    GENE_ID = names(x = vgs),
    Vg = vgs
  ))
}
