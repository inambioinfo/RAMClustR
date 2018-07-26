RAMClustR
=========

A feature clustering algorithm for non-targeted mass spectrometric metabolomics data.

To Install from R console:


_if you are on a mac run these lines first 
this seems to prevent an odd Rdisop error during the rest of installation_

source("https://bioconductor.org/biocLite.R")

biocLite("Rdisop")




install.packages("devtools", repos="http://cran.us.r-project.org", dependencies=TRUE) 

library(devtools)  

install_github("cbroeckl/RAMClustR", build_vignettes = TRUE, dependencies = TRUE) 

library(RAMClustR) 

vignette("RAMClustR")

RAMClustR publication:
RAMClust: A Novel Feature Clustering Method Enables Spectral-Matching-Based Annotation for Metabolomics Data
C. D. Broeckling, F. A. Afsar, S. Neumann , A. Ben-Hur, and J. E. Prenni
http://pubs.acs.org/doi/abs/10.1021/ac501530d

