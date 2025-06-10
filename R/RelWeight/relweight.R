library(boot)
library(dplyr)

#Need to create a data frame called 'thedata' where the criterion variables come first, followed by the predictors. Here is an example with the attached turnover data.
turnover <- read.csv(here::here("R", "RelWeight", "turnover.csv"))
#The first 2 variables are criterion, the last 4 predictors. They need to be in this order. DVs first then IVs
thedata <- dplyr::select(turnover, jobsat, commit, custom, comm, safety, team)

#Specify the number of criterion and predictors
J <- 4 #Number of predictors
Q <- 2 #Number of criterion

#Everything below this should run 

Labels <- names(thedata)[(Q+1):length(thedata)]
multVarR <- function(mydata){
  numVar<<- NCOL(mydata)
  Variables<<-  names(mydata)[(Q+1):numVar]
  
  mydata <- cor(mydata, use="pairwise.complete.obs")
  
  R <- mydata
  RYY <- R[1:Q,1:Q]
  RXX <- R[(Q+1):numVar, (Q+1):numVar]
  RXY <- R[1:Q,(Q+1):numVar]
  
  RXX.eigen <- eigen(RXX)
  DX <- diag(RXX.eigen$val)
  deltax <- sqrt(DX)
  
  lambdax <- RXX.eigen$vec%*%deltax%*%t(RXX.eigen$vec)
  RYY.eigen <- eigen(RYY)
  DY <- diag(RYY.eigen$val)
  deltay <- sqrt(DY)
  lambday <- RYY.eigen$vec%*%deltay%*%t(RYY.eigen$vec)
  betay <- t(RXY)%*%solve(lambday)
  betax <- solve(lambdax)%*%betay
  lambdax2 <- lambdax^2
  betax2 <- betax^2
  mumatrix <- lambdax2%*%betax2
  mu1 <-  rowSums(mumatrix)/Q
  P2XY<<-sum(mu1)
  MU2 <-  rowSums(mumatrix)
  SUMCC <-  sum(MU2)
  RSMU1 <- (mu1/P2XY)*100
  RSMU2 <- (MU2/SUMCC)*100
  mu1
  P2XY
  MU2
  SUMCC
  RSMU1
  RSMU2
  result<<-data.frame(Variables, Raw.RelWeight=mu1, Rescaled.RelWeight=RSMU1)
}

multBootstrap <- function(mydata, indices){
	mydata <- mydata[indices,]
	multWeights <- multVarR(mydata)
	return(multWeights$Raw.RelWeight)
}

multBootrand <- function(mydata, indices){
	mydata <- mydata[indices,]
	multRWeights <- multVarR(mydata)
	multReps <- multRWeights$Raw.RelWeight
	randWeight <- multReps[length(multReps)]
	randStat <- multReps[-(length(multReps))]-randWeight
	return(randStat)
}

#bootstrapping
mybootci <- function(x){
	boot.ci(multBoot,conf=0.95, type="bca", index=x)
}

runBoot <- function(num){
	INDEX <- 1:num
	test <- lapply(INDEX, FUN=mybootci)
	test2 <- t(sapply(test,'[[',i=4)) #extracts confidence interval
	CIresult<<-data.frame(Variables, CI.Lower.Bound=test2[,4],CI.Upper.Bound=test2[,5])
}
myRbootci <- function(x){
	boot.ci(multRBoot,conf=0.95,type="bca",index=x)
}

runRBoot <- function(num){
	INDEX <- 1:num
	test <- lapply(INDEX,FUN=myRbootci)
	test2 <- t(sapply(test,'[[',i=4))
CIresult<<-data.frame(Labels,CI.Lower.Bound=test2[,4],CI.Upper.Bound=test2[,5])
}



multVarR(thedata)
RW.Results <- result
P2.xy <- P2XY


#Bootstrapped Confidence interval around the individual relative weights
#Please be patient -- This can take a few minutes to run
multBoot <- boot(thedata, multBootstrap, 10000)
multci <- boot.ci(multBoot,conf=0.95, type="bca")
runBoot(length(thedata[,(Q+1):numVar]))
CI.Results <- CIresult

#Bootstrapped Confidence interval tests of Significance
#Please be patient -- This can take a few minutes to run
randVar <- rnorm(length(thedata[,1]),0,1)
randData <- cbind(thedata,randVar)
multRBoot <- boot(randData,multBootrand, 10000)
multRci <- boot.ci(multRBoot,conf=0.95, type="bca")
runRBoot(length(randData[,(Q+1):(numVar-1)]))
CI.Significance <- CIresult


#P2.xy - Multivariate R-sq analog
P2.xy


#The Raw and Rescaled Weights
RW.Results
#BCa Confidence Intervals around the raw weights
CI.Results
#BCa Confidence Interval Tests of significance
#If Zero is not included, Weight is Significant
CI.Significance



