## MFE Programming Workshop 
## Lab3 Solution (dplyr)
## Brett Dunn and Mahyar Kargar

library(lubridate)
library(ggplot2)
## the hadley packages
library(tidyverse)
# library(dplyr)
# library(readr)
# library(tidyr)
## for linear regression models
library(broom)

## set the working directly to the folder that contains the .csv files 
setwd("E:/Dropbox/PhD/Teaching/5-Fall 2017/mfeR2017/")

## read in the returns to the 25 fama-french portfolios
ffports <- read_csv("./FFports.csv")

## clean up the dates
ffports <- ffports %>%
    gather(portfolio, ret, -Date) %>%
    mutate(Date=ymd(paste(Date,"01",sep="")))
    
## read in the risk factors
## and clean up the Dates
ff <- read_csv("./FFfactors.csv")
ff <- ff %>%
    mutate(Date=ymd(paste(Date,"01",sep="")))

## join and get the excess returns
all <- ffports %>% left_join(ff) %>%
    mutate(excess=ret-RF)

## subset the data
subs <- all %>%
    filter(Date >= ymd("1963-01-01"),
           Date <= ymd("2013-12-31"))

## Get Regression coefficients for the first regression
a <- subs %>%
    group_by(portfolio) %>%
    do(tidy(lm(excess ~ MktRF, .)))

## mean excess returns
b <- subs %>%
    group_by(portfolio) %>%
    summarize(meanexcess=mean(excess,na.rm = TRUE))

## join them together
c <- full_join(a,b) %>% filter(term=="MktRF")

## plot everything
ggplot(c) + geom_text(aes(estimate,meanexcess,label=portfolio)) + theme_bw() +
  xlab("Market Beta") +  ylab("Realized Mean Return")  + 
  theme(axis.text.x = element_text(size=12,face="plain"), axis.text.y = element_text(size=12,face="plain"),
        axis.title.x = element_text(size=12,face="plain"), axis.title.y = element_text(size=12,face="plain"))

## do it the fama-french way
aFF <- subs %>%
    group_by(portfolio) %>%
    do(tidy(lm(excess ~ MktRF + SMB + HML, .))) %>%
    filter(term != "(Intercept)") %>%
    select(portfolio,term,estimate)

bFF <- subs %>%
    group_by(portfolio) %>%
    summarize(meanexcess=mean(excess,na.rm = TRUE),
              meanMktRF=mean(MktRF,na.rm = TRUE),
              meanHML=mean(HML,na.rm = TRUE),
              meanSMB=mean(SMB,na.rm = TRUE))

## spread the term column into the values
aFF <- spread(aFF,term,estimate)

## join and att the predicted value
cFF <- left_join(aFF,bFF) %>%
    mutate(predval=MktRF*meanMktRF+HML*meanHML+SMB*meanSMB)

## make the plot
ggplot(cFF) + geom_text(aes(predval,meanexcess,label=portfolio)) + geom_abline(color="blue", size = .6) + theme_bw() +
  xlab("Predicted Expected Return") +  ylab("Realized Mean Return") + 
  scale_x_continuous(limits = c(0.2,1.2), breaks = seq(0,1.2,by = .2)) +
  scale_y_continuous(limits = c(0.2,1.2), breaks = seq(0,1.2,by = .2)) +
  theme(axis.text.x = element_text(size=12,face="plain"), axis.text.y = element_text(size=12,face="plain"),
        axis.title.x = element_text(size=12,face="plain"), axis.title.y = element_text(size=12,face="plain"))
