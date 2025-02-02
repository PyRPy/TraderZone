
library(readr)
library(quantmod)
library(PerformanceAnalytics)
library(dplyr)
library(lubridate)
library(TTR)

companylist <- read_csv("My30Symbols_20250201.csv") # prepared in excel
head(companylist)
stockSymbols <- companylist["Symbol"]

# last 5 months or 100 trading days approximately
start_date = today() %m-% months(12)

numberStocks <- nrow(stockSymbols)

# simple random sampling of n stocks, such as n = 50
# srs_stocks <- function(n = 50, numberStocks = numberStocks) {
#   idx <- sample(1:numberStocks, n)
# }

# idx = srs_stocks(100, numberStocks)
idx <- c(1:numberStocks)
# idx = 1:503
sampledStocks <- stockSymbols[idx, "Symbol"]



tickers = sampledStocks$Symbol


# downlaod stocks into a new environment
data_env = new.env()
getSymbols(tickers,
           from = start_date,
           env = data_env,
           auto.assign = TRUE)

# tickers <- sampledStocks[!(Symbol %in% c("INFO", "KSU", "COG"))]
# tickers <- filter(sampledStocks,
#                   Symbol != "INFO" & Symbol != "KSU" & Symbol != "COG" &
#                     Symbol != "NLOK" & Symbol != "ANTM" & Symbol != "ABMD" &
#                     Symbol != "LB" & Symbol != "DISCA" & Symbol != "XLNX" &
#                     Symbol != "TWTR" & Symbol != "BF.B")



switch_test <- function(y){
  n <- length(y)
  y_lag <- c(NA, y[1:(n-1)])
  y_lag_2 <- c(NA, NA, y[1:(n-2)])
  sum(sign(y-y_lag) != sign(y_lag-y_lag_2), na.rm=TRUE)
}

# remove symbols that are not downloaded
valid_symbols = data.frame()
for (stock in tickers) {
  if (is.null(data_env[[stock]]) == FALSE) {
    temp = data.frame(Symbol = stock)
    valid_symbols <- rbind(valid_symbols, temp)
  }
}



strategy_table = data.frame()
for (stock in valid_symbols$Symbol) {
  dret <- dailyReturn(data_env[[stock]])
  pret <- Return.cumulative(dret)
  dret <- coredata(dret)
  rate_of_switches <- sum(sign(dret) != sign(lag(dret)), na.rm=TRUE) / (length(dret) - 1)
  num_drop = 0
  num_up = 0
  num_drop_up = 0
  for (i in 2:nrow(dret)) {
    if (dret[i] < 0) {
      num_drop = num_drop + 1
    } else
    {
      num_up = num_up + 1
    }

    if ((dret[i] > 0 && dret[i-1] < 0) == TRUE) {
      # cat(stock," ", i, "YES ", "\n")
      num_drop_up = num_drop_up + 1
    }
  }

  prob_drop_then_up = num_drop_up/num_drop


  # calculate RSI
  stock_rsi =  coredata(tail(TTR::RSI(Cl(data_env[[stock]])), 1))

  # cat(stock, " prob drop then up ", prob_drop_then_up, " return ",pret, "\n")
  table_temp = data.frame(Symbol = stock,
                    num_drop = num_drop,
                    num_up = num_up,
                    num_drop_up = num_drop_up,
                    prob_drop_up = prob_drop_then_up,
                    cum_return = as.numeric(pret),
                    sd = round(sd(dret), 3),
                    price_close = tail(Cl(data_env[[stock]]), 1)[[1]],
                    SMA20 = tail(SMA(Cl(data_env[[stock]]), n = 20), 1)$SMA[[1]],
                    rate_of_switches = rate_of_switches,
                    stock_rsi = stock_rsi

  )
  strategy_table = rbind(strategy_table, table_temp)

}


# write.csv(strategy_table, "strategy_table_djis.csv")
hist(strategy_table$prob_drop_up)
hist(strategy_table$cum_return)

# barplot for returns
barplot(strategy_table$cum_return, names.arg = strategy_table$Symbol)

for (stock in valid_symbols$Symbol) {
  chartSeries(data_env[[stock]],
              theme="white",
              name = stock,
              TA="addSMA(20); addSMA(50); addVo();addRSI(14)")

  #candleChart(data_env[[stock]], name = stock)
}

# write.csv(stocks_potentials, "stocks_potentials_004.csv")


# debugging on drops and rises --------------------------------------------

getSymbols("PG",
           from = '2024-01-01')
chartSeries(PG,
            theme="white",
            name = "",
            TA="addSMA(20); addSMA(50); addVo();addRSI(14)")
