# Sampling of stocks ------------------------------------------------------

library(readr)
library(quantmod)
companylist <- read_csv("symbols500.csv") # prepared in excel
head(companylist)
stockSymbols <- companylist["Symbol"]

numberStocks <- nrow(stockSymbols)
idx <- sample(1:numberStocks, 50)
idx
sampledStocks <- stockSymbols[idx, "Symbol"]
sampledStocks

# store data in a new environment
stocksEnv <- new.env()
getSymbols(sampledStocks$Symbol, env = stocksEnv, 
           from = "2020-01-01", src = "yahoo")


for (stock in sampledStocks$Symbol) {
  candleChart(stocksEnv[[stock]], name = stock)
}

selected50 <- companylist[idx, ]
