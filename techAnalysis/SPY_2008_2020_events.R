
# SPY_2008_2020_events.R --------------------------------------------------

library(readr)
library(quantmod)

sampledStocks <- data.frame(Symbol = "SPY")

# store data in a new environment
stocksEnv <- new.env()
getSymbols(sampledStocks$Symbol, env = stocksEnv, 
           from = "2005-01-01", src = "yahoo")



# 2008 crisis trend -------------------------------------------------------

for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2007-01-01", 
                     end = "2012-01-01"),
              theme="white", 
              name = stock,
              TA="addVo();addBBands();addRSI(14); 
            addSMA(20, col='red'); addSMA(50, col='blue'); addSMA(200, col='black')")
}


# 2020 covid-19 crisis ----------------------------------------------------

for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2019-01-01", 
                     end = "2021-01-01"),
              theme="white", 
              name = stock,
              TA="addVo();addBBands();addRSI(14); 
            addSMA(20, col='red'); addSMA(50, col='blue'); addSMA(200, col='black')")
}


# Europe crisis -----------------------------------------------------------
for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2021-01-01", 
                     end = "2022-03-11"),
              theme="white", 
              name = stock,
              TA="addVo();addBBands();addRSI(14); 
            addSMA(20, col='red'); addSMA(50, col='blue'); addSMA(200, col='black')")
}


# Comparison for SMA ------------------------------------------------------

for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2007-01-01", 
                     end = "2012-01-01"),
              theme="white", 
              name = stock,
              TA="addBBands(); 
                  addSMA(20, col='red'); 
                  addSMA(50, col='blue'); 
                  addSMA(200, col='black')")
}

for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2019-01-01", 
                     end = "2021-01-01"),
              theme="white", 
              name = stock,
              TA="addBBands(); 
            addSMA(20, col='red'); addSMA(50, col='blue'); addSMA(200, col='black')")
}

for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2021-01-01", 
                     end = "2022-03-11"),
              theme="white", 
              name = stock,
              TA="addBBands();
            addSMA(20, col='red'); addSMA(50, col='blue'); addSMA(200, col='black')")
}


