## Week 2 Lab Solution 
## MFE Programming workshop 2017
## Mahyar Kargar/Brett Dunn

library(lubridate)
library(xts)

rm(list=ls())
## To read in the data I copied it into a file using excel
## saved it to a csv and then imported it
## note: you should change the working directly to the relevant one on your computer
datain <- read.csv("./mfeR2017/week4/lab2/lab2data.csv") 
 
## just get a single subset of the data, the last row
dataset <- tail(datain, n = 1)
## alternatively, you can do this:
## dataset <- datain[nrow(datain),]

## grab the date of my observation
firstdate <- mdy(dataset[,1])

## now drop the date
yields <- dataset[1,-1]

## being fancy cleaning up the maturities of the yields
## you could just manually create the durations but this
## is kind of fun... 
maturity <- names(yields)
## replace the . with a space
maturity <- gsub("\\."," ",maturity)
## replace the X with nothing
maturity <- gsub("X","",maturity)
## change to years and months
maturity <- gsub("mo","month",maturity)
maturity <- gsub("yr","year",maturity)

## split at the space
maturity <- strsplit(maturity, " ")

## convert to durations using lubridate
## durations are in seconds
durations <- sapply(maturity,function(x) duration(as.numeric(x[1]),x[2]))

## finally get the start date plus the duration
## I round down to the nearest day because it also adds on time of day
outdates <- floor_date(firstdate+seconds(durations),"day")

## create the XTS object
## also note that I convert the yeilds to a vector
yielddata <- as.xts(as.numeric(yields),order.by=outdates)

## now plot
plot(yielddata, main = sprintf("Yield Curve for %s",firstdate))

## get a sequence of all of the dates
firstdate <- start(yielddata)
lastdate <- end(yielddata)
alldates <- seq(firstdate,lastdate,by="1 day")

## create an empty xts object
fullsample <- xts(order.by = alldates)
## merge in the known data
fullsample <- merge(fullsample,yielddata)

## and now get the approximations
fullsample_linear <- na.approx(fullsample)
fullsample_spline <- na.spline(fullsample)

## merge together and plot with zoo
allseries <- merge(yielddata, fullsample_linear)
allseries <- merge(allseries, fullsample_spline)

## Set a color scheme:
tsRainbow <- rainbow(ncol(allseries))

## Plot the series with plot.zoo which is better
## for plotting multiple series
plot.zoo(x = allseries, 
         col = tsRainbow, screens = 1)

legend(x = "topleft", legend = c("Original", "Linear", "Spline"), 
       lty = 1,col = tsRainbow)

