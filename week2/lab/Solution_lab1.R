## Lab 1 solution 
## Brett R. Dunn & Mahyar Kargar
## MFE R Programming workshop 2017

## Function to get the Black-Scholes price of an option
myBSPrice <- function(s0,K,r,sigma,T) {
    d1 <- (log(s0/K)+(r+sigma^2/2)*T)/(sigma*sqrt(T))
    d2 <- (log(s0/K)+(r-sigma^2/2)*T)/(sigma*sqrt(T))

    ## pnorm is the CDF in R
    call_price <- s0*pnorm(d1)-exp(-r*T)*K*pnorm(d2)

    call_price
}

inT <- 1
inr <- .04
insigma <- .25
inK <- 95
ins0 <- 100

## make sure your parameters are in the right order
myBSPrice(ins0,inK,inr,insigma,inT)

library(qrmtools)
Black_Scholes(t = 0, S = ins0, sigma = insigma, K = inK, r = inr, T = inT, type = "call")

## now do it for a set of K values
## note that were already vectorized!
Kvals <- 75:125
myBSPrice(ins0,Kvals,inr,insigma,inT)
Black_Scholes(t = 0, S = ins0, sigma = insigma, K = Kvals, r = inr, T = inT, type = "call")

## and on a grid of points
Tvals <- seq(1/12,2,by=1/12)

## this works for doing it across both sets of values
grid_results <- sapply(Tvals,
                       function(t) {
                           myBSPrice(ins0,Kvals,inr,insigma,t)
                       })

data.table(grid_results)

## read in optionsdata.csv
optdata <- read.csv("./optionsdata.csv", header = TRUE, stringsAsFactors = FALSE)
optdata_dt <- fread("./optionsdata.csv")

## calculate the Black-Scholes price for each row of data and put it in a new columns
optdata$bsPrice <- mapply(myBSPrice, optdata$S0, optdata$K, optdata$r, optdata$sigma, optdata$T)
optdata_dt[,CallPrice := myBSPrice(s0 = S0, K = K, r = r, sigma = sigma,T = T)]

## save as a csv file
write.csv(optdata, file="./week1/lab/optionsdataSol.csv")
fwrite(optdata_dt,"./optionsdataSol_dt.csv")