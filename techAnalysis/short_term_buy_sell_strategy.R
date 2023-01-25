
library(readr)
library(quantmod)
library(PerformanceAnalytics)
library(dplyr)

companylist <- read_csv("SP500_2023_01.csv") # prepared in excel
head(companylist)
stockSymbols <- companylist["Symbol"]

numberStocks <- nrow(stockSymbols)
idx <- sample(1:numberStocks, 50)
idx
sampledStocks <- stockSymbols[idx, "Symbol"]

tickers = sampledStocks$Symbol
data_env = new.env()
getSymbols(tickers, 
           from = "2023-01-01", 
           env = data_env, 
           auto.assign = TRUE)

# tickers <- sampledStocks[!(Symbol %in% c("INFO", "KSU", "COG"))]
tickers <- filter(sampledStocks, 
                  Symbol != "INFO" & Symbol != "KSU" & Symbol != "COG" &
                    Symbol != "NLOK" & Symbol != "ANTM" & Symbol != "ABMD" &
                    Symbol != "LB" & Symbol != "DISCA" & Symbol != "XLNX" &
                    Symbol != "TWTR")
strategy_table = data.frame()
for (stock in tickers$Symbol) {
  dret <- dailyReturn(data_env[[stock]])
  pret <- Return.cumulative(dret)
  dret <- coredata(dret)
  num_drop = 0
  num_drop_up = 0
  for (i in 1:(nrow(dret)-1)) {
    if (dret[i] < 0) {
      num_drop = num_drop + 1
    }
    
    if ((dret[i] < 0) && (dret[i+1] > 0)) {
      # cat(stock," ", i, "YES ", "\n")
      num_drop_up = num_drop_up + 1
    }
  }

  prob_drop_then_up = num_drop_up/num_drop
  # cat(stock, " probability drop then up ", prob_drop_then_up, " return ",pret, "\n")
  table_temp = data.frame(Symbol = stock, 
                          num_drop = num_drop,
                          num_drop_up = num_drop_up,
                          prob_drop_up = prob_drop_then_up,
                          cum_return = as.numeric(pret))
  strategy_table = rbind(strategy_table, table_temp)
  
}

hist(strategy_table$prob_drop_up)
hist(strategy_table$cum_return)

# select stocks with first drop and then up the next day
stocks_potentials = subset(strategy_table, cum_return >0 & prob_drop_up >= 0.80)
stocks_potentials

# create plots for promising stocks
for (stock in stocks_potentials$Symbol) {
  candleChart(data_env[[stock]], name = stock)
}

# write.csv(stocks_potentials, "stocks_potentials_004.csv")
