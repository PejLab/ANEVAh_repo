
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ANEVA-h

<!-- badges: start -->

#### Haplotype-Based ANEVA

Created by [Eric Song](esong@ucsd.edu) [Paul Hoffman](phoffman@nygenome.org) A toolkit for quantifying genetic variation in gene dosage from allelic
expression (AE) data. anevah implements the ANEVA method for haplotype-based AE data generated from phASER. 

A tutorial for generating Vg estimates from raw data can be found with
`vignette("anevah")`

## Installation

You can install anevah from GitHub with:

``` r
if (!requireNamespace('remotes', quietly = TRUE) {
  install.packages('remotes')
}
remotes::install_github('PejLab/anevah', build_vignettes = TRUE)
```
