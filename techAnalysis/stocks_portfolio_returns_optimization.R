# https://www.kenwuyang.com/en/post/portfolio-optimization-and-returns/

library(tidyquant)
library(PerformanceAnalytics)
library(PortfolioAnalytics)
library(tidyverse)
library(xts)

# Get the stock returns in portfolio --------------------------------------

# Create a vector of ticker symbols
symbols <- c("SPY", "EFA", "IJS", "EEM", "AGG")

# Load data from 2012 to today
# Specify the "to = " argument to specify an end date
prices <- quantmod::getSymbols(
  Symbols = symbols,
  src = "yahoo",
  from = "2012-12-31",
  auto.assign = TRUE,
  warnings = FALSE
) %>%
  # The map function takes an anonymous function and will return a list of five
  # The function Ad() extracts the daily adjusted price series
  purrr::map(.f = ~ quantmod::Ad(get(x = .x))) %>%
  # Use reduce() to merge the elements of .x interactively
  purrr::reduce(.f = merge) %>%
  # Use a replacement function to set column names to ticker symbols
  # This function is in prefix form
  # It is equivalent to colnames(x = prices) <- value
  `colnames<-`(value = symbols)

# Keep only the last reading of each month
# We could have chosen to keep only the first reading of each month
asset_returns_xts <- xts::to.monthly(
  x = prices,
  drop.time = TRUE,
  indexAt = "lastof",
  OHLC = FALSE
) %>%
  # Compute simple returns
  # Log returns are time-additive but not portfolio additive
  PerformanceAnalytics::Return.calculate(method = "discrete") %>%
  # Drop the first row since we lose 12/31/2012
  stats::na.omit()

# Keep only the xts returns, ticker symbols, and the prices series
rm(list = setdiff(x = ls(), y = c("symbols", "prices", "asset_returns_xts")))

# Create Portfolio object -------------------------------------------------
# Examine the monthly simple returns for our five ETF's
head(x = asset_returns_xts, 5)

# Create Portfolio object which is essentially a list object
min_var_portfolio <- PortfolioAnalytics::portfolio.spec(assets = symbols)
typeof(min_var_portfolio)


# Add constraints to the portfolio object ---------------------------------
# Add the full investment constraint that specifies that the weights must sum to 1
min_var_portfolio <- PortfolioAnalytics::add.constraint(
  portfolio = min_var_portfolio,
  type = "full_investment"
)

# Examine the constraint element by extracting min_var_portfolio[["constraints"]][[1]]
str(pluck(.x = min_var_portfolio, "constraints", 1))

# Add the box constraint that ensure the weights are between 0.1 and 0.6
min_var_portfolio <- PortfolioAnalytics::add.constraint(
  portfolio = min_var_portfolio,
  type = "box", min = 0.05, max = 0.6
)
# Examine the constraint element by extracting min_var_portfolio[["constraints"]][[2]]
str(pluck(.x = min_var_portfolio, "constraints", 2))


# Add objective function --------------------------------------------------
# Add objective to minimize variance
min_var_portfolio <- PortfolioAnalytics::add.objective(
  portfolio = min_var_portfolio,
  # Minimize risk
  type = "risk",
  # A character corresponding to a function name, var()
  name = "var"
)

# Optimization ------------------------------------------------------------

# Run the optimization
global_min_portfolio <- PortfolioAnalytics::optimize.portfolio(
  R = asset_returns_xts,
  portfolio = min_var_portfolio,
  # This defaults to the "quadprog" solver
  optimize_method = "quadprog",
  # Return additional information on the path or portfolios searched
  trace = TRUE
)
# Examine returned portfolio list object
global_min_portfolio


# Optimal Weights for portfolio maximum expected return -------------------
# Create portfolio object

max_exp_return_portfolio <- PortfolioAnalytics::portfolio.spec(assets = symbols)

# Add the full investment constraint that specifies the weights must sum to 1
max_exp_return_portfolio <- PortfolioAnalytics::add.constraint(
  portfolio = max_exp_return_portfolio,
  type = "full_investment"
)

# Add the box constraint that ensure the weights are between 0.1 and 0.6
max_exp_return_portfolio <- PortfolioAnalytics::add.constraint(
  portfolio = max_exp_return_portfolio,
  type = "box", min = 0.05, max = 0.6
)

# Add objective to maximize mean returns
max_exp_return_portfolio <- PortfolioAnalytics::add.objective(
  portfolio = max_exp_return_portfolio,
  # Maximize expected returns
  type = "return",
  # A character corresponding to a function name, mean()
  name = "mean"
)

# Run the optimization
global_max_portfolio <- PortfolioAnalytics::optimize.portfolio(
  R = asset_returns_xts,
  portfolio = max_exp_return_portfolio,
  # This defaults to the "glpk" solver
  optimize_method = "glpk",
  # Return additional information on the path or portfolios searched
  trace = TRUE
)

# Examine returned portfolio list object
global_max_portfolio


# Building a portfolio ----------------------------------------------------
# Set optimal weights
weights <- pluck(.x = global_max_portfolio, "weights")

# Check if the weights and symbols align
tibble(weights, symbols)

# Ensure that the weights vector sums up to 1
tibble(weights, symbols) %>%
  dplyr::summarize(total_weight = sum(weights))

# compute portfolio monthly returns using a brute force method:
# Compute by hand
portfolio_returns_by_hand <-
  (weights[[1]] * asset_returns_xts[, 1]) +
  (weights[[2]] * asset_returns_xts[, 2]) +
  (weights[[3]] * asset_returns_xts[, 3]) +
  (weights[[4]] * asset_returns_xts[, 4]) +
  (weights[[5]] * asset_returns_xts[, 5])

# Name the series
portfolio_returns_by_hand <- `names<-`(portfolio_returns_by_hand, "Monthly portfolio returns")

# Examine
head(portfolio_returns_by_hand, 5)

# Compute monthly portfolio returns
portfolio_returns_xts_rebalanced_monthly <-
  PerformanceAnalytics::Return.portfolio(
    R = asset_returns_xts,
    weights = weights,
    # Monthly re-balancing
    reblance_on = "months",
    # Use simple/arithmetic chaining to aggregate returns
    geometric = FALSE
  ) %>%
  `colnames<-`("Monthly_portfolio_returns")

# Examine
head(portfolio_returns_xts_rebalanced_monthly, 5)

# Monthly portfolio returns in tidyquant

# Load data
asset_returns_tq <- tidyquant::tq_get(
  x = symbols,
  get = "stock.prices",
  from = "2012-12-31"
) %>%
  # The asset column is named symbol by default (see body(tidyquant::tq_get))
  dplyr::group_by(symbol) %>%
  # Select adjusted daily prices
  tidyquant::tq_transmute(
    select = adjusted,
    col_rename = "returns",
    # This function is from quantmod
    mutate_fun = periodReturn,
    # These arguments are passed along to the mutate function quantmod::periodReturn
    period = "monthly",
    # Simple returns
    type = "arithmetic",
    # Do not return leading period data
    leading = FALSE,
    # This argument is passed along to xts::to.period, which is wrapped by quantmod::periodReturn
    # We use the last reading of each month to find percentage changes
    indexAt = "lastof"
  ) %>%
  dplyr::rename(asset = symbol) %>%
  na.omit()

# Create a tibble of weights
weights_tibble <- tibble(
  asset = symbols,
  weights = weights
)
head(weights_tibble, 5)

# Map the weights to the returns column using the asset column as the identifier
portfolio_returns_tq_rebalanced_monthly_method_2 <- asset_returns_tq %>%
  tidyquant::tq_portfolio(
    assets_col = asset,
    returns_col = returns,
    weights = weights_tibble,
    col_rename = "Monthly_portfolio_returns",
    rebalance_on = "months"
  )
head(portfolio_returns_tq_rebalanced_monthly_method_2, 5)

# Compare and Contrast the four methods
