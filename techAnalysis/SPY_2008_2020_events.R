
# SPY_2008_2020_events.R --------------------------------------------------

library(readr)
library(quantmod)

sampledStocks <- data.frame(Symbol = "SPY")

# store data in a new environment
stocksEnv <- new.env()
getSymbols(sampledStocks$Symbol, env = stocksEnv, 
           from = "2005-01-01", src = "yahoo")


# Overall trend since 2005 ------------------------------------------------
for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2005-01-01", 
                     end = "2022-07-01"),
              theme="white", 
              name = stock,
              time.scale = "Monthly",
              TA="addVo(); 
                  addSMA(50, col='blue'); 
                  addSMA(200, col='black')")
}


# 2008 crisis trend -------------------------------------------------------

for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2007-01-01", 
                     end = "2013-01-01"),
              theme="white", 
              name = stock,
              TA="addVo();
                  addBBands();addRSI(14); 
                  addSMA(20, col='red'); 
                  addSMA(50, col='blue'); 
                  addSMA(200, col='black')")
}


# 2020 covid-19 crisis ----------------------------------------------------

for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2019-01-01", 
                     end = "2021-01-01"),
              theme="white", 
              name = stock,
              TA="addVo();addBBands();addRSI(14); 
                  addSMA(20, col='red'); 
                  addSMA(50, col='blue'); 
                  addSMA(200, col='black')")
}



# Inflation and Europe Crisis ---------------------------------------------

for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2021-01-01", 
                     end = "2022-07-01"),
              theme="white", 
              name = stock,
              TA="addVo();addBBands();addRSI(14); 
                  addSMA(20, col='red');  
                  addSMA(50, col='blue'); 
                  addSMA(200, col='black')")
}

# Overall trend since 2005 ------------------------------------------------
for (stock in sampledStocks$Symbol) {
  chartSeries(window(stocksEnv[[stock]], 
                     start = "2005-01-01", 
                     end = "2022-07-01"),
              theme="white", 
              name = stock,
              time.scale = "Monthly",
              TA="addVo(); 
                  addSMA(50, col='blue'); 
                  addSMA(200, col='black')")
}
