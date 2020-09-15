# reference from youtube 
# https://www.youtube.com/channel/UC0Amh8UkHvIVxPbxsrEBRMg
# load packages
library(quantmod)
library(PerformanceAnalytics)
# Stock watch list --------------------------------------------------------

# a collection of stocks
mystocks <- c("AAPL", "ADBE", "AMRC", "CW", "DHR", "EWJ", "F", "FE", "MSFT", 
              "FMCKJ", "GE", "IWD", "MCHI", "PPA", "PYPL", "SQ", "TMO", 
              "WMT", "XOM", "ZM", "CSCO", "WDC", "GLD", "NOVA", "IQ", "AMD", 
              "SPY", "INDA", "UAL", "C", "JNJ")

# store data in a new environment
stocksEnv <- new.env()
getSymbols(mystocks, env = stocksEnv, from = "2020-01-01", src = "yahoo")


for (stock in mystocks) {
  candleChart(stocksEnv[[stock]], name = stock)
}
candleChart(stocksEnv[["MSFT"]])

# ETFs data and canle charts
myETFs <- c("EWJ", "IWD", "PPA", "GLD", "SPY", "INDA", "AIA", "MCHI")
stocksEnv2 <- new.env()
getSymbols(myETFs, env = stocksEnv2, from = "2020-01-01", src = "yahoo")


for (stock in myETFs) {
  candleChart(stocksEnv2[[stock]], name = stock)
}

# read data
getSymbols(mystocks, from = "2019-07-01", src = "yahoo")

getSymbols("SPY", from = "2020-07-01", src = "yahoo")

# Daily return and charts -------------------------------------------------
selected_stock <-SPY
dret <- dailyReturn(selected_stock)
head(dret, n = 5)
tail(dret, n = 5)
plot(window(dret, start = "2020-01-01"))
sd(window(dret, start = "2020-01-01"))
# sd(dret)

# Add moving average 
candleChart(selected_stock, subset = "2020") # 
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(selected_stock)

# Setup -------------------------------------------------------------------

# use SMA to generate both buy signal
price <- Cl(selected_stock)
S <- 10
L <- 50
r <- SMA(price, S) / SMA(price, L) - 1
delta <- 0.005 # threshold
signal <- c()
signal[1:L] <- 0

for (i in (L+1):length(price)) {
  if (r[i] > delta) {
    signal[i] <- 1
  } else
    signal[i] <- 0
}

signal <- reclass(signal, price)

candleChart(selected_stock)
addTA(signal, type = 'S', col = 'red')

trade <- Lag(signal, 1) # lag1 means yesterday's signal
ret2 <- dailyReturn(selected_stock) * trade
names(ret2) <- "SMA"

charts.PerformanceSummary(ret2, main = "SMA")


# SMA and RSI 2------------------------------------------------------------
price <- Cl(selected_stock)
S <- 10
L <- 50
r <- SMA(price, S) / SMA(price, L) - 1
delta <- 0.005 # threshold

n <- 14
rsi <- RSI(price, n) 

signal <- c()
signal[1:L] <- 0

# generate trading signal - avoid over-bought situlation
for (i in (L+1):length(price)) {
  if (r[i] > delta & rsi[i] < 70.5) {
    signal[i] <- 1 
  } else if (rsi[i] >= 75) {
    signal[i] <- -1
  } else
    signal[i] <- 0
}

signal <- reclass(signal, price) 

candleChart(selected_stock)
addTA(signal, type = 'S', col = 'red')

trade <- Lag(signal, 1) # lag1 means yesterday's signal
ret5 <- dailyReturn(selected_stock) * trade
names(ret5) <- "SMA & RSI 2"

charts.PerformanceSummary(ret5, main = "SMA & RSI 2")


# naive method
price <- Cl(selected_stock)
r <- price/Lag(price) - 1
delta <- 0.005 # threshold
signal <- c(0)

# Loop over all days
for (i in 2:length(price)) {
  if (r[i] > delta) {
    signal[i] <- 1
  } else
    signal[i] <- 0
}

# reclass signal
signal <- reclass(signal, price)


# Charting with trading rule ----------------------------------------------

candleChart(selected_stock)
addTA(signal, type = 'S', col = 'red')

# Performance evaluation --------------------------------------------------

# generate the daily gains and losses

# day trading based on yesterday's buy signal
# buy at open
# sell at close
# trading size - all in

trade <- Lag(signal, 1) # lag1 means yesterday's signal
ret1 <- dailyReturn(selected_stock) * trade
names(ret1) <- "filter"

charts.PerformanceSummary(ret1, main = "naive rule")

# RSI ---------------------------------------------------------------------

n <- 14
delta <- 0.005 
price <- Cl(selected_stock)
r <- price/Lag(price) - 1 
rsi <- RSI(price, n) 
signal <- c() 
signal[1:n] <- 0 

# generate trading signal
for (i in (n+1):length(price)) {
  if (r[i] > delta) {
    signal[i] <- 1 
  } else if (rsi[i] > 70) {
    signal[i] <- -1
  } else
    signal[i] <- 0
}

signal <- reclass(signal, price) 

lineChart(selected_stock)
addTA(signal, type = 'S', col = 'red')

trade <- Lag(signal, 1) # lag1 means yesterday's signal
ret3 <- dailyReturn(selected_stock) * trade
names(ret3) <- "RSI"

charts.PerformanceSummary(ret3, main = "RSI")


# SMA and RSI -------------------------------------------------------------
price <- Cl(selected_stock)
S <- 10
L <- 50
r <- SMA(price, S) / SMA(price, L) - 1
delta <- 0.005 # threshold

n <- 14
rsi <- RSI(price, n) 

signal <- c()
signal[1:L] <- 0

# generate trading signal
for (i in (L+1):length(price)) {
  if (r[i] > delta) {
    signal[i] <- 1 
  } else if (rsi[i] > 70) {
    signal[i] <- -1
  } else
    signal[i] <- 0
}

signal <- reclass(signal, price) 

lineChart(selected_stock)
addTA(signal, type = 'S', col = 'red')

trade <- Lag(signal, 1) # lag1 means yesterday's signal
ret4 <- dailyReturn(selected_stock) * trade
names(ret4) <- "SMA & RSI"

charts.PerformanceSummary(ret4, main = "SMA & RSI")

ret_all <- cbind(ret1, ret2, ret3, ret4, ret5)
charts.PerformanceSummary(ret_all, main = "Stratgies Comparison")
charts.PerformanceSummary(cbind(ret2, ret5), main = "Stratgies Comparison")
mean(rsi > 80, na.rm = T) # for ZM 5.17% 