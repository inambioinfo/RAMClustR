% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/annotate.R
\name{annotate}
\alias{annotate}
\title{evalute ramSearch, MSFinder mssearch, MSFinder Structure, MSFinder Formula, and findmain output to annotate spectra of ramclustR object}
\usage{
annotate(ramclustObj = NULL,
  msfinder.dir = "C:/MSFinder/MS-FINDER program ver. 2.40",
  standardize.names = FALSE, min.msms.score = 3.5)
}
\arguments{
\item{ramclustObj}{R object - the ramclustR object which was used to write the .mat or .msp files}

\item{msfinder.dir}{full path to MSFinder directory - used for naming refinement}

\item{standardize.names}{logical: if TRUE, use inchikey for standardized chemical name lookup (http://cts.fiehnlab.ucdavis.edu/)}

\item{min.msms.score}{numerical: what is the minimum MSFinder similarity score acceptable.  default = 3.5}
}
\value{
an updated ramclustR object, with the RC$ann and RC$ann.conf slots updated to annotated based on output from 1. ramsearch output, 2. msfinder mssearch, 3. msfinder predicted structure, 4. msfinder predicted formula, and 5. interpretMSSpectrum inferred molecular weight, with listed order as priority.
}
\description{
After running RAMSearch (msp) and MSFinder on .mat or .msp files, import the spectral search results
}
\details{
this function imports the output from the MSFinder program to annotate the ramclustR object
}
\references{
Broeckling CD, Afsar FA, Neumann S, Ben-Hur A, Prenni JE. RAMClust: a novel feature clustering method enables spectral-matching-based annotation for metabolomics data. Anal Chem. 2014 Jul 15;86(14):6812-7. doi: 10.1021/ac501530d.  Epub 2014 Jun 26. PubMed PMID: 24927477.

Broeckling CD, Ganna A, Layer M, Brown K, Sutton B, Ingelsson E, Peers G, Prenni JE. Enabling Efficient and Confident Annotation of LC-MS Metabolomics Data through MS1 Spectrum and Time Prediction. Anal Chem. 2016 Sep 20;88(18):9226-34. doi: 10.1021/acs.analchem.6b02479. Epub 2016 Sep 8. PubMed PMID: 7560453.

Tsugawa H, Kind T, Nakabayashi R, Yukihira D, Tanaka W, Cajka T, Saito K, Fiehn O, Arita M. Hydrogen Rearrangement Rules: Computational MS/MS Fragmentation and Structure Elucidation Using MS-FINDER Software. Anal Chem. 2016 Aug 16;88(16):7946-58. doi: 10.1021/acs.analchem.6b00770. Epub 2016 Aug 4. PubMed PMID: 27419259.

http://cts.fiehnlab.ucdavis.edu/static/download/CTS2-MS2015.pdf
}
\author{
Corey Broeckling
}
\keyword{'MSFinder'}
\keyword{'RAMClustR',}
\keyword{'clustering',}
\keyword{'feature',}
\keyword{'mass}
\keyword{'metabolomics',}
\keyword{'ramclustR'}
\keyword{'ramclustR',}
\keyword{'xcms',}
\keyword{spectrometry',}
