library(quantmod)
library(ggplot2)
library(dplyr)
library(lubridate)

stock_list <- c("SPY", "QQQ", "JETS")

# store data in a new environment
stocksEnv <- new.env()
getSymbols(stock_list, env = stocksEnv, from = "2021-01-01", src = "yahoo")

stock_boxplot <- function(stock) {
  tmp <- Cl(stock)
  names(tmp) <- "Close"
  tmp %>% ggplot(aes(x = time(tmp), y = Close, group = month(tmp))) +
    geom_boxplot() 
}
stock_boxplot(QQQ)


for (stk in stock_list) {
  cat(stk)
  stock_boxplot(stocksEnv[[as.character(stk)]])
}

# not working properly
stock_boxplot(stocksEnv[[QQQ]])
