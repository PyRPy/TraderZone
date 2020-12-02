# reference from youtube 
# https://www.youtube.com/channel/UC0Amh8UkHvIVxPbxsrEBRMg
# load packages
library(quantmod)
library(PerformanceAnalytics)
# Stock watch list --------------------------------------------------------

# Sector ETFs -------------------------------------------------------------

# a collection of ETFs in sectors
sector_ETFs = c("XLE", "XLF", "XLU", "XLI", "XLK",
                "XLV", "XLP", "XLY", "GDX", "IYR")

# XLE	Energy Select Sector SPDR Fund
# XLF	Financial Select Sector SPDR Fund
# XLU	Utilities Select Sector SPDR Fund
# XLI	Industrial Select Sector SPDR Fund
# XLK	Technology Select Sector SPDR Fund
# XLV	Health Care Select Sector SPDR Fund
# XLP	Consumer Staples Select Sector SPDR Fund
# XLY	Consumer Discretionary Select Sector SPDR Fund
# GDX	VanEck Vectors Gold Miners ETF
# IYR	iShares U.S. Real Estate ETF

# https://www.cnbc.com/funds-and-etfs/

# store data in a new environment
stocksEnv <- new.env()
getSymbols(sector_ETFs, env = stocksEnv, from = "2020-01-01", src = "yahoo")


for (stock in sector_ETFs) {
  candleChart(stocksEnv[[stock]], name = stock)
}


# Commodities ETFs --------------------------------------------------------

# GLD	SPDR Gold Shares
# SLV	iShares Silver Trust
# UNG	United States Natural Gas Fund
# USO	United States Oil Fund, LP
# IAU	iShares Gold Trust
# DBC	Invesco DB Commodity Index Tracking Fund

commodity_ETFs = c("GLD", "SLV", "UNG", "USO", "IAU", "DBC")
stocksEnv2 <- new.env()
getSymbols(commodity_ETFs, env = stocksEnv2, from = "2020-01-01", src = "yahoo")

for (stock in commodity_ETFs) {
  candleChart(stocksEnv2[[stock]], name = stock)
}


# Currency ETFs -----------------------------------------------------------

# UUP	Invesco DB US Dollar Index Bullish Fund
# FXE	Invesco CurrencyShares Euro Trust
# FXY	Invesco CurrencyShares Japanese Yen Trust
# FXB	Invesco CurrencyShares British Pound Strlng Tr
# EUO	ProShares UltraShort Euro
# YCS	ProShares UltraShort Yen

currency_ETFs = c("UUP", "FXE", "FXY", "FXB", "EUO", "YCS")
stocksEnv3 <- new.env()
getSymbols(currency_ETFs, env = stocksEnv3, from = "2020-01-01", src = "yahoo")

for (stock in currency_ETFs) {
  candleChart(stocksEnv3[[stock]], name = stock)
}


# Popular ETFs ------------------------------------------------------------

# SPY	SPDR S&P 500 ETF Trust
# QQQ	Invesco QQQ Trust
# IWM	iShares Russell 2000 ETF
# DIA	SPDR Dow Jones Industrial Average ETF Trust
# MDY	SPDR S&P Midcap 400 ETF
# EEM	iShares MSCI Emerging Markets ETF
# EFA	iShares MSCI EAFE ETF
# IVV	iShares Core S&P 500 ETF
# VTI	Vanguard Total Stock Market Index Fund ETF Shares
# IJR	iShares Core S&P Small-Cap ETF
# SSO	ProShares Ultra S&P500
# TQQQ	ProShares UltraPro QQQ
# SQQQ	ProShares UltraPro Short QQQ
# EDC	Direxion Daily MSCI Emerging Markets Bull 3X Shares

pop_ETFs = c("SPY", "QQQ", "IWM", "DIA", "MDY", 
             "EEM", "EFA", "IVV", "VTI", "IJR",
             "SSO", "TQQQ", "SQQQ", "EDC")
stocksEnv4 <- new.env()
getSymbols(pop_ETFs, env = stocksEnv4, from = "2020-01-01", src = "yahoo")

for (stock in pop_ETFs) {
  candleChart(stocksEnv4[[stock]], name = stock)
}


# my ETFs -----------------------------------------------------------------

# ETFs data and canle charts

myETFs <- c("EWJ", "IWD", "PPA", "GLD", "SPY", "INDA", "AIA", "MCHI")
stocksEnv5 <- new.env()
getSymbols(myETFs, env = stocksEnv5, from = "2020-01-01", src = "yahoo")


for (stock in myETFs) {
  candleChart(stocksEnv5[[stock]], name = stock)
}

# read data

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
