# Building and Testing Stock Portfolios in R ------------------------------
# https://towardsdatascience.com/building-and-testing-stock-portfolios-in-r-d1b7b6f59ac4
library(quantmod)
library(PerformanceAnalytics)
library(dygraphs)

## Writing a function to calculate stock returns
monthly_returns <- function(ticker, base_year)
{
  # Obtain stock price data from Yahoo! Finance
  stock <- getSymbols(ticker, src = "yahoo", auto.assign = FALSE) 
  # Remove missing values
  stock <- na.omit(stock)
  # Keep only adjusted closing stock prices
  stock <- stock[, 6]
  
  # Confine our observations to begin at the base year and end at the last available trading day
  horizon <- paste0(as.character(base_year), "/", as.character(Sys.Date()))
  stock <- stock[horizon]
  
  # Calculate monthly arithmetic returns
  data <- periodReturn(stock, period = "monthly", type = "arithmetic")
  
  # Assign to the global environment to be accessible
  assign(ticker, data, envir = .GlobalEnv)
}

## Using our function and visualizing returns
# Call our function for each stock
monthly_returns("XLE", 2019)
monthly_returns("XLF", 2019)
monthly_returns("INDA", 2019)
monthly_returns("JETS", 2019)
monthly_returns("MJ", 2019)
monthly_returns("DFEN", 2019)

# Get S&P 500 Data
monthly_returns("SPY", 2019)

# Merge all the data and rename columns
returns <- merge.xts(XLE, XLF, INDA, JETS, MJ, DFEN, SPY)
colnames(returns) <- c("XLE", "XLF", "INDA", "JETS", "MJ", "DFEN", "SP500")

# Produce interactive chart of stock returns
dygraph(returns, main = "ETFs vs. S&P 500") %>%
  dyAxis("y", label = "Return", valueRange = c(-1,1)) %>%
  dyRangeSelector(dateWindow = c("2019-01-01", "2020-12-09")) %>%
  dyOptions(colors = RColorBrewer::brewer.pal(4, "Set2")) 

# Print last 5 rows of the data, rounded to 4 decimal places
round(tail(returns, n = 5), 4)


# Analyzing portfolio composition -----------------------------------------

corrplot::corrplot(cor(returns), method = 'number') 


# Building our portfolio and assessing performance ------------------------

# Assign weights
wts <- rep(1/6, 6)

# Construct a portfolio using our returns object and weights
# Only select first few columns to isolate our individual stock data
portfolio_returns <- Return.portfolio(R = returns[,1:6], 
                                      weights = wts, 
                                      wealth.index = TRUE)

# Then isolate our S&P 500 data
benchmark_returns <- Return.portfolio(R = returns[,7], 
                                      wealth.index = TRUE)

# Merge the two
comp <- merge.xts(portfolio_returns, benchmark_returns)
colnames(comp) <- c("Portfolio", "Benchmark")

# Build an interactive graph to compare performance
dygraph(comp, main = "Portfolio Performance vs. Benchmark") %>%
  dyAxis("y", label = "Amount ($)")
