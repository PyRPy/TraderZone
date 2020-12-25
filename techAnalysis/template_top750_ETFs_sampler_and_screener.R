# Sampling of ETFs ------------------------------------------------------
# https://etfdb.com/compare/market-cap/
# upto tab 83
library(readr)
library(quantmod)
library(PerformanceAnalytics)
library(dplyr)
companylist <- read_csv("etfdb_full_list.csv") # prepared in excel
colnames(companylist) <- c("Symbol", "ETF_name", "Asset_class", 
                           "Total_assets", "YTD_Price_Change", 
                           "Daily_Volume", "Close_price", "Pro")
head(companylist)
# clean up
companylist["Pro"] <- NULL
companylist$Total_assets <- as.numeric(gsub('[$,]', '', 
                                            companylist$Total_assets))
companylist$Asset_class <- as.factor(companylist$Asset_class)

table(companylist$Asset_class)
companylist <- companylist %>% 
  filter(Total_assets >= 500 & Asset_class == "Equity")
  
stockSymbols <- companylist["Symbol"]
# general random sampling
numberStocks <- nrow(stockSymbols)
idx <- sample(1:numberStocks, 10)

# specific samplings on key words
# idx_no_bond <- !grepl('Bond', companylist$Name) & 
# !grepl('Securities', companylist$Name)
idx_gold <- grepl('Gold', companylist$ETF_name) & 
  !grepl('Goldman', companylist$ETF_name)
idx_clean <- grepl('Clean', companylist$ETF_name) | 
  grepl('Solar', companylist$ETF_name) | 
  grepl('Battery', companylist$ETF_name)
idx_ai <- grepl('Artificial', companylist$ETF_name) 
idx_utilities <- grepl('Utilities', companylist$ETF_name) 
idx_energy <- grepl('Energy', companylist$ETF_name) 
idx_cyber <- grepl('Cyber', companylist$ETF_name)
sampledStocks <- stockSymbols[idx_cyber, "Symbol"] # add idx with sampling
sampledStocks

stocksEnv <- new.env()
getSymbols(sampledStocks$Symbol, env = stocksEnv, 
           from = "2020-01-01", src = "yahoo")


# Candle charts for stocks ------------------------------------------------

for (stock in sampledStocks$Symbol) {
  candleChart(stocksEnv[[stock]], name = stock)
}

companylist_idx <- companylist[idx_cyber, ]
# Screening stocks by return and std --------------------------------------

goodCandidate <- data.frame()

for (stock in sampledStocks$Symbol) {
  dret <- dailyReturn(stocksEnv[[stock]])
  pret <- Return.cumulative(dret)
  if (sd(dret) < 0.1 && as.numeric(pret) > 0.08) {
    tmp <- data.frame(Symbol = stock, 
                      sd = round(sd(dret), 3), 
                      ret = round(as.numeric(pret), 3))
    goodCandidate <- rbind(goodCandidate, tmp)
    
  }
}

# check the list
goodCandidate

# weekly return
goodCandidate <- data.frame()

for (stock in sampledStocks$Symbol) {
  wret <- weeklyReturn(stocksEnv[[stock]])
  pret <- Return.cumulative(wret)
  if (sd(wret) < 0.15 && as.numeric(pret) > 0.08) {
    tmp <- data.frame(Symbol = stock, 
                      sd = round(sd(wret), 3), 
                      ret = round(as.numeric(pret), 3))
    goodCandidate <- rbind(goodCandidate, tmp)
    
  }
}

# check the list
goodCandidate
