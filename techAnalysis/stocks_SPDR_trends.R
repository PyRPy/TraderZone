# Sampling of stocks ------------------------------------------------------
# https://www.cnbc.com/sector-etfs/
library(quantmod)
spdr_list <- c("XLE", "XLF", "XLU", "XLI", "GDX", 
               "XLK", "XLV", "XLY", "XLP", "XLB", 
               "XOP", "IYR", "XHB", "ITB", "VNQ",
               "GDXJ", "IYE", "OIH", "XME", "XRT",
               "SMH", "IBB", "KBE", "KRE", "XTL")

# store data in a new environment
stocksEnv <- new.env()
getSymbols(spdr_list, env = stocksEnv, 
           from = "2021-01-01", src = "yahoo")

# brief description of ETF symbols
description_sectors <- read.csv("sectors_etf.csv")

for (stock in spdr_list) {
  chartSeries(stocksEnv[[stock]], 
              theme="white", 
              name = paste(stock, description_sectors$NAME.[description_sectors$SYMBOL.== stock]),
              TA="addVo();
              addBBands();
              addRSI(14); 
              addSMA(20, col='red'); 
              addSMA(50, col='blue'); 
              addSMA(200, col='black');
              addMACD(fast=12,slow=26,signal=9,type='EMA')")
}


