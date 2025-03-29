
# load the libaries -------------------------------------------------------

library(readr)
library(quantmod)
library(PerformanceAnalytics)
library(dplyr)
library(lubridate)
library(TTR)


# load DOW 30 stock symbols -----------------------------------------------

companylist <- read_csv("Dow30.csv") # prepared in excel
head(companylist)
stockSymbols <- companylist["Symbol"]

# 5 years duration with weekly data
start_date = today() %m-% months(60)

numberStocks <- nrow(stockSymbols)


# sample or use all the listed symbols ------------------------------------

idx <- c(1:numberStocks)

sampledStocks <- stockSymbols[idx, "Symbol"]

tickers = sampledStocks$Symbol


# download stocks into a new environment
data_env = new.env()
getSymbols(tickers,
           from = start_date,
           periodicity = 'weekly',
           env = data_env,
           auto.assign = TRUE)

# remove symbols that are not downloaded
valid_symbols = data.frame()
for (stock in tickers) {
  if (is.null(data_env[[stock]]) == FALSE) {
    temp = data.frame(Symbol = stock)
    valid_symbols <- rbind(valid_symbols, temp)
  }
}


# plot candle chart with moving average -----------------------------------

for (stock in valid_symbols$Symbol) {
  chartSeries(data_env[[stock]],
              theme="white",
              name = stock,
              TA="addSMA(20, col= 'red'); 
              addSMA(50, col='green'); 
              addSMA(200, col = 'black');
              addVo();
              addRSI(14)")

}


# debugging on drops and rises --------------------------------------------

getSymbols("SPY",
           from = '2021-03-01',
           periodicity = 'weekly')
chartSeries(SPY,
            theme="white",
            name = "",
            TA="addSMA(20); addSMA(50); addSMA(200); addVo();addRSI(14)")
