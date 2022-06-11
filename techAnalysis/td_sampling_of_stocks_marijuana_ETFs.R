# Sampling of stocks ------------------------------------------------------

library(readr)
library(quantmod)

stockSymbols <- c("MJ", 
                  "MSOS", 
                  "YOLO", 
                  "POTX", 
                  "THCX", 
                  "CNBS", 
                  "TOKE")

sampledStocks <- stockSymbols
sampledStocks

# store data in a new environment
stocksEnv <- new.env()
getSymbols(sampledStocks, env = stocksEnv, 
           from = "2022-01-01", src = "yahoo")


for (stock in sampledStocks) {
  chartSeries(stocksEnv[[stock]], 
              theme="white", 
              name = stock,
              TA="addVo();addBBands();
                  addRSI(14); 
                  addSMA(20, col='red'); 
                  addSMA(50, col='blue'); 
                  addSMA(200, col='black')")
}

