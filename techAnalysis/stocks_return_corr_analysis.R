
# Stocks trend and return analysis ----------------------------------------
# load the libraries
library(readr)
library(quantmod)
library(PerformanceAnalytics)
library(fpp2)
library(corrplot)

# load data from tickers --------------------------------------------------

tickers = c("GNR", "HDRO", "HSY", "JETS",  "NUSI", 
            "TCHP", "UBER", "VNM", "MO")
data_env = new.env()
getSymbols(tickers, 
           from = "2021-01-01", 
           env = data_env, 
           auto.assign = TRUE)
head(data_env$GNR)


# Merge stock and find returns --------------------------------------------

adjusted_list = lapply(data_env, Ad)
adjusted = do.call(merge, adjusted_list)
colnames(adjusted) = c("UBER", "JETS", "MO", "TCHP", "HSY", 
                       "NUSI", "HDRO", "GNR", "VNM")
round(cor(adjusted), 2)

# HDRO is a new ETF
corrplot(cor(adjusted["2021-03-10::"]), 
         method = "number", 
         type = "upper")


# Trends and indicators ---------------------------------------------------

for (stock in tickers) {
  chartSeries(data_env[[stock]], 
              theme="white", 
              name = stock,
              TA="addVo();
              addBBands();
              addRSI(14); 
              addSMA(20, col='red'); 
              addSMA(50, col='blue'); 
              addSMA(200, col='black')")
}

# Stock returns -----------------------------------------------------------
ret_adj = Return.calculate(adjusted)
ret_adj = ret_adj[(-1), ] # remove the first day

# boxplot for returns distributions
boxplot(ret_adj, names = c("UBER", "JETS", "MO", "TCHP", "HSY", 
                           "NUSI", "HDRO", "GNR", "VNM"))


# Return summary table ----------------------------------------------------

summary_table <- data.frame()

for (stock in tickers) {
  dret <- dailyReturn(data_env[[stock]])
  dret <- window(dret, from = "2022-02-01")
  pret <- Return.cumulative(dret)
  tmp <- data.frame(Symbol = stock, 
                    sd = round(sd(dret), 3), 
                    ret = round(as.numeric(pret), 3))
  summary_table <- rbind(summary_table, tmp)
}
summary_table
