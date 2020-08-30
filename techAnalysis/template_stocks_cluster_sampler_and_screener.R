# Sampling of stocks ------------------------------------------------------

library(readr)
library(quantmod)
library(PerformanceAnalytics)
companylist <- read_csv("symbols500.csv") # prepared in excel
head(companylist)

total_num_stocks <- nrow(companylist)
number_stocks <- 50
GICS_sectors <- unique(companylist$`GICS Sector`)
idx <- c()
stocks_sampled_sectors <- data.frame()

# cluster sampling based on sectors, use proportional ratio
for (sector in GICS_sectors) {
  company_sectors <- subset(companylist, `GICS Sector`==sector)
  num_sector <- nrow(company_sectors)
  # cat(num_sector, "\t")
  idx <- sample(1:num_sector, 
                ceiling(number_stocks * num_sector / total_num_stocks))
  # cat(idx, "\t")
  tmp <- company_sectors[idx, ]
  stocks_sampled_sectors <- rbind(stocks_sampled_sectors, tmp)
}

stocks_sampled_sectors

stocksEnv <- new.env()
getSymbols(stocks_sampled_sectors$Symbol, env = stocksEnv, 
           from = "2020-01-01", src = "yahoo")


# Candle charts for stocks ------------------------------------------------

for (stock in stocks_sampled_sectors$Symbol) {
  candleChart(stocksEnv[[stock]], name = stock)
}


# Screening stocks by return and std --------------------------------------

goodCandidate <- data.frame()


for (stock in stocks_sampled_sectors$Symbol) {
  dret <- dailyReturn(stocksEnv[[stock]])
  pret <- Return.cumulative(dret)
  if (sd(dret) < 0.05 && as.numeric(pret) > 0.15) {
    tmp <- data.frame(Symbol = stock, 
                      sd = round(sd(dret), 3), 
                      ret = round(as.numeric(pret), 3))
    goodCandidate <- rbind(goodCandidate, tmp)
    
  }
}

goodCandidate
