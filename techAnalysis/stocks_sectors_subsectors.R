# Sampling of stocks ------------------------------------------------------

library(readr)
library(quantmod)
companylist <- read_csv("quotes.csv") # prepared in excel
head(companylist)
stockSymbols <- companylist["Symbol"]

# store data in a new environment
stocksEnv <- new.env()
getSymbols(stockSymbols$Symbol, env = stocksEnv, 
           from="2021-01-01",
           src = "yahoo")

# define indicators
sma_200_50_20 <- "addVo();
              addBBands();
              addRSI(14); 
              addSMA(20, col='red'); 
              addSMA(50, col='blue');
              addSMA(200, col='black')"

sma_50_20 <- "addVo();
              addBBands();
              addRSI(14); 
              addSMA(20, col='red'); 
              addSMA(50, col='blue');"

# plot stocks, for new stocks, just plot SMA50 and 30, skip 200 day SMA
plot_stocks <- function(){
  for (stock in stockSymbols$Symbol) {
    chartSeries(stocksEnv[[stock]],
                theme="white", 
                name = stock,
                TA= ifelse(nrow(stocksEnv[[stock]]) >= 200, 
                           sma_200_50_20, sma_50_20)
    )
  }
}

# run the plot function
plot_stocks()

# view the companies info
selectedCompanies <- companylist
