\name{crime}
\alias{crime}
\docType{data}
\title{
Data on crimes in the U.S.
}
\description{
This dataset gives rates of various crimes in each of the 50 U. S. states in 1977.
originally from the United States Statistical Abstracts. The data
were comes from the \emph{SAS User's Guide: Statistics}, "The PRINCOMP Procedure",
and were later reanalyzed by Friendly (1991). 
}
\usage{data("crime")}
\format{
  A data frame with 50 observations on the following 10 variables.
  \describe{
    \item{\code{state}}{state name, a character vector}
    \item{\code{murder}}{a numeric vector}
    \item{\code{rape}}{a numeric vector}
    \item{\code{robbery}}{a numeric vector}
    \item{\code{assault}}{a numeric vector}
    \item{\code{burglary}}{a numeric vector}
    \item{\code{larceny}}{a numeric vector}
    \item{\code{auto}}{auto thefts, a numeric vector}
    \item{\code{st}}{state abbreviation, a character vector}
    \item{\code{region}}{region of the U.S., a factor with levels \code{Northeast} \code{South} \code{North Central} \code{West}}
  }
}
%\details{
%%  ~~ If necessary, more details than the __description__ above ~~
%}
\source{
The data are originally from the United States Statistical Abstracts (1970).
}
\references{

Friendly, M. (1991). \emph{SAS System for Statistical Graphics}. SAS Institute.

Hartigan, J. A. (1975). \emph{Clustering Algorithms}. John Wiley and Sons.
}
\examples{
data(crime)
## maybe str(crime) ; plot(crime) ...
}
\keyword{datasets}
