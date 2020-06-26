# Sampling of stocks ------------------------------------------------------

library(readr)
library(quantmod)
companylist <- read_csv("mywatchlist.csv") # prepared in excel
head(companylist)
stockSymbols <- companylist["Symbols"]

numberStocks <- nrow(stockSymbols)
idx <- sample(1:numberStocks, 41)
idx
sampledStocks <- stockSymbols[idx, "Symbols"]
sampledStocks

# store data in a new environment
stocksEnv <- new.env()
getSymbols(sampledStocks$Symbols, env = stocksEnv, from = "2020-01-01", src = "yahoo")


for (stock in sampledStocks$Symbols) {
  candleChart(stocksEnv[[stock]], name = stock)
}
