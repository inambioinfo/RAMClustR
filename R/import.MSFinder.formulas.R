#' import.msfinder.formulas
#'
#' After running MSFinder on .mat or .msp files, import the formulas that were predicted and their scores 
#' @param ramclustObj R object - the ramclustR object which was used to write the .mat or .msp files
#' @param mat.dir optional path to .mat directory
#' @param msp.dir optional path to .msp directory
#' @param database.priority character.  Can be set to a single or multiple database names.  must match database names as they are listed in MSFinder precisily. Can also be set to 'all' (note that MSFinder reports all databases matched, not just selected databases).  If any database is set, the best formula match to that (those) database(s) is selected, rather than the best formula match overall.  
#' @details this function imports the output from the MSFinder program to annotate the ramclustR object
#' @return new slots at $msfinder.formula, $msfinder.formula.score, and $msfinder.formula.details
#' @references Broeckling CD, Afsar FA, Neumann S, Ben-Hur A, Prenni JE. RAMClust: a novel feature clustering method enables spectral-matching-based annotation for metabolomics data. Anal Chem. 2014 Jul 15;86(14):6812-7. doi: 10.1021/ac501530d.  Epub 2014 Jun 26. PubMed PMID: 24927477.
#' @references Broeckling CD, Ganna A, Layer M, Brown K, Sutton B, Ingelsson E, Peers G, Prenni JE. Enabling Efficient and Confident Annotation of LC-MS Metabolomics Data through MS1 Spectrum and Time Prediction. Anal Chem. 2016 Sep 20;88(18):9226-34. doi: 10.1021/acs.analchem.6b02479. Epub 2016 Sep 8. PubMed PMID: 7560453.
#' @references Tsugawa H, Kind T, Nakabayashi R, Yukihira D, Tanaka W, Cajka T, Saito K, Fiehn O, Arita M. Hydrogen Rearrangement Rules: Computational MS/MS Fragmentation and Structure Elucidation Using MS-FINDER Software. Anal Chem. 2016 Aug 16;88(16):7946-58. doi: 10.1021/acs.analchem.6b00770. Epub 2016 Aug 4. PubMed PMID: 27419259.
#' @keywords 'ramclustR' 'RAMClustR', 'ramclustR', 'metabolomics', 'mass spectrometry', 'clustering', 'feature', 'xcms', 'MSFinder'
#' @author Corey Broeckling
#' @export

import.msfinder.formulas <- function (
  ramclustObj = NULL,
  mat.dir = NULL,
  msp.dir = NULL,
  database.priority = NULL
) {
  
  home.dir <-getwd()
  
  r<-grep("msfinder", names(ramclustObj))
  if(length(r) > 0) {
    warning("removed previosly assigned MSFinder formulas and sructures", '\n')
    ramclustObj <- ramclustObj[-r]
    rm(r)
  }
  
  if(is.null(mat.dir)) {
    mat.dir = paste0(getwd(), "/spectra/mat")
  }
  
  if(is.null(msp.dir)) {
    msp.dir = paste0(getwd(), "/spectra/msp")
  }
  
  usemat = TRUE
  usemsp = TRUE
  
  if(!dir.exists(mat.dir)) {
    usemat = FALSE
  }
  
  if(!dir.exists(msp.dir)) {
    usemsp = FALSE
  }
  
  if(!usemsp & !usemat) {
    stop("neither of these two directories exist: ", '\n',
         "  ", mat.dir, '\n',
         "  ", msp.dir, '\n')
  }
  
  if(usemsp & usemat) {
    msps<-list.files(msp.dir, recursive  = TRUE)
    mats<-list.files(mat.dir, recursive = TRUE)
    if(length(mats) > length(msps)) {usemsp <- FALSE}
    if(length(msps) > length(mats)) {usemat <- FALSE}
    if(length(msps) == length(mats)) {
      feedback<-readline(prompt="Press 1 for .mat or 2 for .msp to continue")
      if(feedback == 1) {usemsp <- FALSE}
      if(feedback == 2) {usemat <- FALSE}
    }
  }
  
  mat.dir <- c(mat.dir, msp.dir)[c(usemat, usemsp)]
  
  
  do<-list.files(mat.dir, pattern = ".fgt", full.names = TRUE)
  
  cmpd<-gsub(".fgt", "", basename(do))
  
  tmp<-readLines(do[[1]])
  
  if(grepl("Spectral DB search", tmp[2])) {
    stop("these MSFinder contain only spectral search results; please use 'import.MSFinder.search' function instead", '\n')
  }
  
  tags<-c(
    "NAME: ",
    "EXACTMASS: ",
    "ISSELECTED: ",
    "MASSDIFFERENCE: ",
    "TOTALSCORE: ",
    "ISOTOPICINTENSITY[M+1]: ",
    "ISOTOPICINTENSITY[M+2]: ",
    "ISOTOPICDIFF[M+1]: ",
    "ISOTOPICDIFF[M+2]: ",                                                                                                                                 
    "MASSDIFFSCORE: ",                                                                                                                                      
    "ISOTOPICSCORE: ",                                                                                                                                      
    "PRODUCTIONSCORE: ",                                                                                                                                    
    "NEUTRALLOSSSCORE: ",                                                                                                                                   
    "PRODUCTIONPEAKNUMBER: ",                                                                                                                               
    "PRODUCTIONHITSNUMBER: ",                                                                                                                               
    "NEUTRALLOSSPEAKNUMBER: ",                                                                                                                              
    "NEUTRALLOSSHITSNUMBER: ",                                                                                                                              
    "RESOURCENAMES: ",                                                                                                                                       
    "RESOURCERECORDS: ",                                                                                                                                    
    "ChemOntDescriptions: ",                                                                                                                                 
    "ChemOntIDs: ",                                                                                                                                          
    "ChemOntScores: ",                                                                                                                                       
    "ChemOntInChIKeys: ",                                                                                                                                    
    "PUBCHEMCIDS: "
  )
  names(tags)<-tolower(gsub(": ", "", tags))
  
  fill<-matrix(nrow = 0, ncol = length(tags))
  dimnames(fill)[[2]]<-names(tags)
  data.frame(fill, check.names = FALSE, stringsAsFactors = FALSE)
  
  msfinder.formula<-as.list(rep(NA, length(ramclustObj$cmpd)))
  names(msfinder.formula)<-ramclustObj$cmpd
  
  
  for(i in 1:length(do)) {
    tmp<-readLines(do[[i]])
    starts <- grep("NAME: ", tmp)
    if(length(starts) < 1) {
      msfinder.formula[[cmpd[i]]]<- fill
      next
    }
    if(length(starts) > 1) {
      stops <- c(((starts[2:length(starts)])-1), (length(tmp)-1))
    } else {
      stops <- length(tmp)-1
    }
    out<-matrix(nrow = length(starts), ncol = length(tags))
    dimnames(out)[[2]]<-names(tags)
    for(j in 1:length(starts)) {
      d<-tmp[starts[j]:stops[j]]
      vals<-sapply(1:length(tags), FUN = function(x) {
        m<-grep(tags[x], d, fixed = TRUE)
        if(length(m)==0) {
          NA
        } else {
          if(length(m)>1) {
            m<-m[1]
          }
          gsub(tags[x], "", d[m])
        }
      }
      )
      out[j,]<-vals
    }
    out<-data.frame(out, check.names = FALSE, stringsAsFactors = FALSE)
    if(any(out[,"name"] == "Spectral DB search")) {
      out <- out[-grep("Spectral DB search", out[,"name"]), ,drop = FALSE]
    }
    if(nrow(out) == 0) {
      msfinder.formula[[cmpd[i]]]<-fill
    } else {
      msfinder.formula[[cmpd[i]]]<-out
    }
  }
  
  
  dbs<- sapply(1:length(msfinder.formula), FUN = function(x) {
    if(nrow(msfinder.formula[[x]])>0) {
      paste(msfinder.formula[[x]][,"resourcenames"], collapse = ",")
    } else {
      NA
    }
  }
  )
  dbs<-paste(dbs, collapse = ",")  
  dbs<- unlist(strsplit(dbs, ","))
  dbs<-unique(dbs[which(nchar(dbs)>0)])
  
  #   database.priority<- c("KNApSAcK")
  suppressWarnings(
    if(!is.null(database.priority)) {
      if(database.priority == "all") {database.priority <- dbs}
    }
  )
  
  dbmatch<- dbs %in% database.priority
  while (any (!dbmatch)) {
    dbmatch<- database.priority %in% dbs
    for(i in which(!dbmatch)) {
      close <- agrep(database.priority[i], dbs, max.distance = 0.2)
      fix<- readline(prompt = cat(database.priority[i], 
                                  "does not match any database names", 
                                  "please type one of the following names or 'q' to quit:", 
                                  "\n", "\n", dbs, "\n")
      )
      if(fix == "q") {stop("function ended")}
      database.priority[i]<- fix
    }
  }
  
  ramclustObj$msfinder.formula<-sapply(1:length(msfinder.formula), FUN = function(x) {
    if(nrow(msfinder.formula[[x]])>0) {
      if(is.null(database.priority)) {
        msfinder.formula[[x]][1,"name"]
      } else {
        f<-NA
        while(is.na(f)) {
          for(i in 1:nrow(msfinder.formula[[x]])){
            for(j in 1:length(database.priority)) {
              if(grepl(database.priority[j], msfinder.formula[[x]][i,"resourcenames"])) {
                f<-i
                if(!is.na(f)) {break}
              }
              if(!is.na(f)) {break}
            }
            if(!is.na(f)) {break}
          }
          if(i == nrow(msfinder.formula[[x]])) { f <- 1}
        }
        if(!is.na(f)) {msfinder.formula[[x]][f,"name"]} else {NA}
      }
    } else {
      NA
    }
  }
  )
  
  ramclustObj$msfinder.formula.score <- as.numeric(sapply(1:length(msfinder.formula), 
                                                          FUN = function(x) {
                                                            # cat(x)
                                                            if (!is.na(ramclustObj$msfinder.formula[x])) {
                                                              df<-msfinder.formula[[which(msfinder.formula[[x]][, "name"] == ramclustObj$msfinder.formula[x])]]
                                                              if(nrow(df) > 0) {df[1,  "totalscore"]} else {NA}
                                                            } else {
                                                              NA
                                                            }
                                                          }))
  
  ramclustObj$msfinder.formula.details<-msfinder.formula
  
  setwd(home.dir)
  
  return(ramclustObj)
  
}
