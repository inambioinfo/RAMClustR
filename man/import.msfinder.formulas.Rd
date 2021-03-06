% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import.msfinder.formulas.R
\name{import.msfinder.formulas}
\alias{import.msfinder.formulas}
\title{import.msfinder.formulas}
\usage{
import.msfinder.formulas(ramclustObj = NULL, mat.dir = NULL,
  msp.dir = NULL, database.priority = NULL)
}
\arguments{
\item{ramclustObj}{R object - the ramclustR object which was used to write the .mat or .msp files}

\item{mat.dir}{optional path to .mat directory}

\item{msp.dir}{optional path to .msp directory}

\item{database.priority}{character.  Can be set to a single or multiple database names.  must match database names as they are listed in MSFinder precisily. Can also be set to 'all' (note that MSFinder reports all databases matched, not just selected databases).  If any database is set, the best formula match to that (those) database(s) is selected, rather than the best formula match overall.}
}
\value{
new slots at $msfinder.formula, $msfinder.formula.score, and $msfinder.formula.details
}
\description{
After running MSFinder on .mat or .msp files, import the formulas that were predicted and their scores
}
\details{
this function imports the output from the MSFinder program to annotate the ramclustR object
}
\references{
Broeckling CD, Afsar FA, Neumann S, Ben-Hur A, Prenni JE. RAMClust: a novel feature clustering method enables spectral-matching-based annotation for metabolomics data. Anal Chem. 2014 Jul 15;86(14):6812-7. doi: 10.1021/ac501530d.  Epub 2014 Jun 26. PubMed PMID: 24927477.

Broeckling CD, Ganna A, Layer M, Brown K, Sutton B, Ingelsson E, Peers G, Prenni JE. Enabling Efficient and Confident Annotation of LC-MS Metabolomics Data through MS1 Spectrum and Time Prediction. Anal Chem. 2016 Sep 20;88(18):9226-34. doi: 10.1021/acs.analchem.6b02479. Epub 2016 Sep 8. PubMed PMID: 7560453.

Tsugawa H, Kind T, Nakabayashi R, Yukihira D, Tanaka W, Cajka T, Saito K, Fiehn O, Arita M. Hydrogen Rearrangement Rules: Computational MS/MS Fragmentation and Structure Elucidation Using MS-FINDER Software. Anal Chem. 2016 Aug 16;88(16):7946-58. doi: 10.1021/acs.analchem.6b00770. Epub 2016 Aug 4. PubMed PMID: 27419259.
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
