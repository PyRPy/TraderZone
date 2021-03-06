# Sampling of ETFs ------------------------------------------------------
# https://etfdb.com/compare/market-cap/
library(readr)
library(quantmod)
library(PerformanceAnalytics)
library(dplyr)
companylist <- read_csv("ETFsTop100.csv") # prepared in excel
head(companylist)
stockSymbols <- companylist["Symbol"]

numberStocks <- nrow(stockSymbols)
idx <- sample(1:numberStocks, 10)
idx_no_bond <- !grepl('Bond', companylist$Name) & !grepl('Securities', companylist$Name)

sampledStocks <- stockSymbols[idx_no_bond, "Symbol"] # add idx with sampling
sampledStocks

stocksEnv <- new.env()
getSymbols(sampledStocks$Symbol, env = stocksEnv, 
           from = "2020-01-01", src = "yahoo")

# reverse order of symbols in data.frame for convenience
sampledStocks <- sampledStocks[rev(seq_len(nrow(sampledStocks))), , 
                               drop = FALSE]
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
