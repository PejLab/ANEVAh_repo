
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ANEVA-h

<!-- badges: start -->
[![DOI](https://zenodo.org/badge/967047774.svg)](https://doi.org/10.5281/zenodo.15226574)


#### Haplotype-Based ANEVA

Package authored by [Eric Song](mailto:esong@ucsd.edu) and [Paul Hoffman](mailto:phoffman@nygenome.org) based on the statistical model by [Pejman Mohammadi](pejman.m@gmail.com).

A toolkit for quantifying genetic variation in gene dosage from allelic
expression (AE) data. anevah implements the ANEVA method for haplotype-based AE data generated from phASER. 

## Installation

You can install anevah from GitHub with:

``` r
if (!requireNamespace('remotes', quietly = TRUE) {
  install.packages('remotes')
}
remotes::install_github('PejLab/ANEVAh_repo')
```
