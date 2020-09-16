# Sampling of ETFs ------------------------------------------------------
# https://etfdb.com/compare/market-cap/
library(readr)
library(quantmod)
library(PerformanceAnalytics)
companylist <- read_csv("ETFsTop100.csv") # prepared in excel
head(companylist)
stockSymbols <- companylist["Symbol"]

numberStocks <- nrow(stockSymbols)
idx <- sample(1:numberStocks, 10)
idx
sampledStocks <- stockSymbols[, "Symbol"] # add idx if do sampling
sampledStocks

stocksEnv <- new.env()
getSymbols(sampledStocks$Symbol, env = stocksEnv, 
           from = "2020-01-01", src = "yahoo")


# Candle charts for stocks ------------------------------------------------

for (stock in sampledStocks$Symbol) {
  candleChart(stocksEnv[[stock]], name = stock)
}


# Screening stocks by return and std --------------------------------------

goodCandidate <- data.frame()

for (stock in sampledStocks$Symbol) {
  dret <- dailyReturn(stocksEnv[[stock]])
  pret <- Return.cumulative(dret)
  if (sd(dret) < 0.10 && as.numeric(pret) > 0.10) {
    tmp <- data.frame(Symbol = stock, 
                      sd = round(sd(dret), 3), 
                      ret = round(as.numeric(pret), 3))
    goodCandidate <- rbind(goodCandidate, tmp)
    
  }
}

# check the list
goodCandidate
