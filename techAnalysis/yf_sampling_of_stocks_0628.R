# Sampling of stocks ------------------------------------------------------

library(readr)
library(quantmod)
companylist <- read_csv("quotes0628.csv") # prepared in excel
head(companylist)
stockSymbols <- companylist["Symbol"]

numberStocks <- nrow(stockSymbols)
# idx <- sample(1:numberStocks, 41)
# idx
# sampledStocks <- stockSymbols[idx, "Symbols"]
sampledStocks <- stockSymbols
sampledStocks
# store data in a new environment
stocksEnv <- new.env()
getSymbols(sampledStocks$Symbol, env = stocksEnv, from = "2020-01-01", src = "yahoo")

failed <- c("GFLU", "IEX", "MRCY", "MLHR", "FLOW", "SXI", "HEES", "KELYB")
for (stock in sampledStocks$Symbol) {
  if (stock %in% failed) {
    next
  }
  candleChart(stocksEnv[[stock]], name = stock)
}
