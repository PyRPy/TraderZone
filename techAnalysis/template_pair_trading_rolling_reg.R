# Rolling Regression and Pairs Trading in R
# https://www.r-bloggers.com/2021/01/rolling-regression-and-pairs-trading-in-r/

# Rolling Regression with Co-Integrated Pairs
library(rollRegres)
library(tidyverse)
library(tseries)
library(quantmod)

mySymbols <- c('AMZN', 'NFLX')

myStocks <-lapply(mySymbols, function(x) {getSymbols(x, 
                                                     from = "2020-01-01", 
                                                     to = "2021-01-03",
                                                     periodicity = "daily",
                                                     auto.assign=FALSE)} )


names(myStocks)<-mySymbols


closePrices <- lapply(myStocks, Cl)
closePrices <- do.call(merge, closePrices)

names(closePrices)<-sub("\\.Close", "", names(closePrices))

# get the logarithm of the prices
closePrices<-log(closePrices)
head(closePrices)

# Run the Rolling Regression with a moving window of 30 observations 
# and get the intercept and the beta coefficient.
my_rollregression<-roll_regres(NFLX ~ AMZN, closePrices, width = 30,
                               do_compute = c("sigmas", "r.squareds", "1_step_forecasts"))

tail(my_rollregression$coefs)


# Get the Rolling Betas in Chart ------------------------------------------
my_coef<-as.data.frame(my_rollregression$coefs)
my_coef<-rownames_to_column(my_coef, "Date")%>%na.omit()
my_coef$Date<-as.Date(my_coef$Date)
my_coef%>%ggplot(aes(x=Date, y=AMZN))+
  geom_point()+geom_line()+ylab("Rolling Beta")+
  ggtitle("Rolling Beta of NFLX vs AMZN")
