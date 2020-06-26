# reference from youtube 
# https://www.youtube.com/channel/UC0Amh8UkHvIVxPbxsrEBRMg
# load packages
library(quantmod)
library(PerformanceAnalytics)
# Stock watch list --------------------------------------------------------

# a collection of stocks
mystocks <- c("GE", "JNJ", "MSFT", "WMT", "CMI", "MCHI", "ZM", "^DJI")

# read data
getSymbols(mystocks, from = "2015-01-01", src = "yahoo")
# getSymbols('ZM',src='csv')
# getSymbols('MSFT',src='csv')

# Daily return and charts -------------------------------------------------

candleChart(MSFT, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")

candleChart(WMT, subset = "2020") # buy
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")

candleChart(ZM, subset = "2020") # buy
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")

getSymbols("MCHI", from = "2015-01-01", src = "yahoo") # buy
candleChart(MCHI, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")

# 2020-06-26 --------------------------------------------------------------

getSymbols("GPS", from = "2015-01-01", src = "yahoo") # pass
candleChart(GPS, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(XBI)

getSymbols("VODPF", from = "2015-01-01", src = "yahoo") # pass
candleChart(VODPF, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(XBI)

getSymbols("PD", from = "2015-01-01", src = "yahoo") # pass
candleChart(PD, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(PD)

getSymbols("ROYMY", from = "2015-01-01", src = "yahoo") # pass
candleChart(ROYMY, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(ROYMY)

getSymbols("TWOU", from = "2015-01-01", src = "yahoo") # pass
candleChart(TWOU, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(TWOU)