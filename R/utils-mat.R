#' Matrices
#'
#' Create covariate and sample matrices
#'
#' @param vals Covariate / sample data
#' @param nQuant Number of quantiles
#' @param nb Number of bands
#' @family matrices
#' @name matrices
NULL

#' @export
#' @rdname matrices
#' @family matrices
#' @keywords internal

mat_quant <- function(vals,
                      nQuant,
                      nb) {

  #--- create covariance matrix of the quantiles ---#

  matQ <- matrix(NA, nrow = (nQuant + 1), ncol = nb)

  for (i in 1:nb) {

    #--- calculate min, max, and range of vals for covariates ---#

    maxVal <- max(vals[, i])
    minVal <- min(vals[, i])
    rangeVal <- maxVal - minVal

    #--- determine the width of each quantile ---#

    widthQuant <- rangeVal / nQuant

    #--- populate quantile matrix ---#

    matQ[, i] <- seq(from = minVal, to = maxVal, by = widthQuant)
  }

  return(matQ)
}

#' @export
#' @rdname matrices
#' @family matrices
#' @param matQ Quantile matrix
#' @keywords internal

mat_cov <- function(vals,
                    nQuant,
                    nb,
                    matQ) {
  if (anyNA(vals)) {
    stop("NA values cannot exist in your covariates/samples", call. = FALSE)
  }

  matCov <- matrix(0, nrow = nQuant, ncol = nb)

  #--- create progress text bar ---#

  iterations <- nrow(vals)
  pb <- utils::txtProgressBar(min = 1, max = iterations, style = 3)

  #--- for each row in dataframe ---#

  for (i in 1:nrow(vals)) {
    setTxtProgressBar(pb, i)

    count <- 1

    #--- for each column in dataframe ---#

    for (j in 1:nb) {
      indv <- vals[i, j]

      #--- for each quantile in covariates ---#

      for (k in 1:nQuant) {

        #--- determine upper and lower limits ---#

        limL <- matQ[k, count]

        limU <- matQ[k + 1, count]

        #--- determine whether the sample row fits within the quantile being analyzed ---#

        if (indv >= limL & indv <= limU) {
          matCov[k, count] <- matCov[k, count] + 1
        }
      }

      count <- count + 1
    }
  }

  close(pb)

  return(matCov)
}

#' @export
#' @rdname matrices
#' @family matrices
#' @param matQ Quantile matrix
#' @keywords internal

mat_covNB <- function(vals,
                      nQuant,
                      nb,
                      matQ) {
  if (anyNA(vals)) {
    stop("NA values cannot exist in your covariates/samples", call. = FALSE)
  }

  matCov <- matrix(0, nrow = nQuant, ncol = nb)

  #--- for each row in dataframe ---#

  for (i in 1:nrow(vals)) {
    count <- 1

    #--- for each column in dataframe ---#

    for (j in 1:nb) {
      indv <- vals[i, j]

      #--- for each quantile in covariates ---#

      for (k in 1:nQuant) {

        #--- determine upper and lower limits ---#

        limL <- matQ[k, count]

        limU <- matQ[k + 1, count]

        #--- determine whether the sample row fits within the quantile being analyzed ---#

        if (indv >= limL & indv <= limU) {
          matCov[k, count] <- matCov[k, count] + 1
        }
      }

      count <- count + 1
    }
  }

  return(matCov)
}
