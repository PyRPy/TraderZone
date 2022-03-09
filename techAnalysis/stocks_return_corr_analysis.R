
# Stocks trend and return analysis ----------------------------------------
# load the libraries
library(readr)
library(quantmod)
library(PerformanceAnalytics)
library(PortfolioAnalytics)
library(corrplot)

# load data from tickers --------------------------------------------------

tickers = c("JETS",  "NUSI", "TCHP", "UBER", "VNM", "MO")
data_env = new.env()
getSymbols(tickers, 
           from = "2021-01-01", 
           env = data_env, 
           auto.assign = TRUE)

head(data_env$JETS)


# Merge stock and find returns --------------------------------------------

adjusted_list = lapply(data_env, Ad)
adjusted = do.call(merge, adjusted_list)
adjusted= na.omit(adjusted)
colnames(adjusted) = c("UBER", "JETS", "MO", "TCHP", 
                       "NUSI", "VNM")
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
boxplot(ret_adj, names = c("UBER", "JETS", "MO", "TCHP", 
                           "NUSI", "VNM"))


# Return summary table ----------------------------------------------------

summary_table <- data.frame()

for (stock in tickers) {
  dret <- dailyReturn(data_env[[stock]])
  dret <- window(dret, from = "2022-01-01")
  pret <- Return.cumulative(dret)
  tmp <- data.frame(Symbol = stock, 
                    sd = round(sd(dret), 3), 
                    ret = round(as.numeric(pret), 3))
  summary_table <- rbind(summary_table, tmp)
}
summary_table


# Portfolio analysis ------------------------------------------------------

# equal weight benchmark
n <- ncol(ret_adj)
equal_weights <- rep(1 / n, n)

# start from 2021-03-11, the second day of HDRO IPO
benchmark_returns <- Return.portfolio(R = ret_adj,
                                      weights = equal_weights,
                                      rebalance_on = "months")

colnames(benchmark_returns) <- "benchmark"

# benchmark performance
table.AnnualizedReturns(benchmark_returns)

# Base portfolio definition
base_port_spec <- portfolio.spec(assets = colnames(ret_adj))
base_port_spec <- add.constraint(portfolio = base_port_spec,
                                 type = "full_investment")
base_port_spec <- add.constraint(portfolio = base_port_spec,
                                 type = "long_only")
base_port_spec <- add.objective(portfolio = base_port_spec,
                                type = "risk",
                                name = "StdDev")

# optimization backtest
opt_base <- optimize.portfolio.rebalancing(R = ret_adj,
                                           optimize_method = "ROI",
                                           portfolio = base_port_spec,
                                           rebalance_on = "months",
                                           training_period = 12,
                                           rolling_window = 12
                                            )

# calculate portfolio returns
base_returns <- Return.portfolio(ret_adj,
                                 extractWeights(opt_base))
colnames(base_returns) <- "base"

# optimization backtest
chart.Weights(opt_base)

# merge benmark and portfolio returns
ret <- cbind(benchmark_returns, base_returns)

# annualized performance
table.AnnualizedReturns(ret)

# refine constraints
# backup of portfolio spec
box_port_spec <- base_port_spec
# update the constraint
box_port_spec <- add.constraint(portfolio = box_port_spec,
                                type = "box",
                                min = 0.05,
                                max = 0.4,
                                indexnum = 2)

# backtesting
opt_box <- optimize.portfolio.rebalancing(R = ret_adj,
                                          optimize_method = "ROI",
                                          portfolio = box_port_spec,
                                          rebalance_on = "months",
                                          training_period = 12,
                                          rolling_window = 12)

# calculate portfolio returns
box_returns <- Return.portfolio(ret_adj, extractWeights(opt_box))
colnames(box_returns) <- "box"

# chart the optimal weights
chart.Weights(opt_box)

# analysis refined constraints
# merge box port returns
ret <- cbind(ret, box_returns)
# annualized performance
table.AnnualizedReturns(ret)

#                           benchmark   base    box
# Annualized Return           -0.0490 0.0488 0.1197
# Annualized Std Dev           0.1788 0.1159 0.1272
# Annualized Sharpe (Rf=0%)   -0.2738 0.4205 0.9414