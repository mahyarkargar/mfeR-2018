## MFE Programming Workshop 
## Lab3 Solution (data.table)
## Brett Dunn and Mahyar Kargar

library(lubridate)
library(data.table)
library(reshape2)
library(ggplot2)
## need zoo for as.yearmon
library(zoo)

## set the working directly to the folder that contains the .csv files 
setwd("directory with the csv files")

## read in the returns to the 25 fama-french portfolios
ffports <- fread("./FFports.csv")

## clean up the Dates
ffports[,Date:=ymd(paste(ffports$Date,"01",sep=""))]
## convert the Date to month using zoo:::as.yearmon
ffports[,Date:=as.yearmon(Date)]

## convert to long form using melt
ffportslong <- melt(ffports,id.vars="Date",variable.name="portfolio",value.name="ret")

## read in the risk factors
## and clean up the Dates
ff <- fread("./FFfactors.csv")
ff[,Date:=as.yearmon(ymd(paste(Date,"01",sep="")))]

## merge everything together
all <- merge(ffportslong,ff,all.x=TRUE,by="Date")

## calculate excess returns
all[,excess:=ret - RF]

## get a subset
start <- as.yearmon(ymd("1963-01-01"))
end <- as.yearmon(ymd("2013-12-31"))
subs <- all[Date <= end & Date >= start,]

## get a time series beta and an average excess return
## note that the j argument in data.table can be an express
## as long as it returns a list (in this case a data.frame)
## then data.table will make the output into a data.table
portvals <- subs[,
{
    mymod <- lm(excess ~ MktRF)
    coefs <- coef(mymod)
    out <- data.frame(intercept=coefs[1],
                      MktRF=coefs[2],
                      meanexcess=mean(excess,na.rm = TRUE),
                      meanMktRF = mean(MktRF))
    out
},
by=portfolio]

portvals[,predval:=MktRF*meanMktRF]

portvals

## I'm going to use ggplot, but you could obviously just plot the
## two data series with plot. You may need to install ggplot2
## for this to work
ggplot(portvals) + geom_text(aes(MktRF,meanexcess,label=portfolio)) + theme_bw() +
  xlab("Market Beta") +  ylab("Realized Mean Return")  + 
  theme(axis.text.x = element_text(size=12,face="plain"), axis.text.y = element_text(size=12,face="plain"),
        axis.title.x = element_text(size=12,face="plain"), axis.title.y = element_text(size=12,face="plain"))

ggplot(portvals) + geom_text(aes(predval,meanexcess,label=portfolio)) + geom_abline(color="blue", size = .6) + theme_bw() +
  xlab("Predicted Expected Return") +  ylab("Realized Mean Return") + 
  scale_x_continuous(limits = c(0.2,1.2), breaks = seq(0,1.2,by = .2)) +
  scale_y_continuous(limits = c(0.2,1.2), breaks = seq(0,1.2,by = .2)) +
  theme(axis.text.x = element_text(size=12,face="plain"), axis.text.y = element_text(size=12,face="plain"),
        axis.title.x = element_text(size=12,face="plain"), axis.title.y = element_text(size=12,face="plain"))

## do a similar thing, but for the FF model
## also get the factor means over the same sample period
## for each portfolio
portvalsff <- subs[,
{
    mymod <- lm(excess ~ MktRF + SMB + HML)
    out <- data.frame(t(coef(mymod)),
                      meanexcess=mean(excess,na.rm = TRUE),
                      meanMktRF=mean(MktRF),
                      meanHML=mean(HML),                      
                      meanSMB=mean(SMB))
    out
},
by=portfolio]

## now get the predicted value
portvalsff[,predval:=MktRF*meanMktRF+HML*meanHML+SMB*meanSMB]

portvalsff

## make the plot
ggplot(portvalsff) + geom_text(aes(predval,meanexcess,label=portfolio)) + geom_abline(color="blue", size = .6) + theme_bw() +
  xlab("Predicted Expected Return") +  ylab("Realized Mean Return") + 
  scale_x_continuous(limits = c(0.2,1.2), breaks = seq(0,1.2,by = .2)) +
  scale_y_continuous(limits = c(0.2,1.2), breaks = seq(0,1.2,by = .2)) +
  theme(axis.text.x = element_text(size=12,face="plain"), axis.text.y = element_text(size=12,face="plain"),
        axis.title.x = element_text(size=12,face="plain"), axis.title.y = element_text(size=12,face="plain"))

