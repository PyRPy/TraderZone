# reference from youtube 
# https://www.youtube.com/channel/UC0Amh8UkHvIVxPbxsrEBRMg
# load packages
library(quantmod)
library(PerformanceAnalytics)
# Stock watch list --------------------------------------------------------

# 2020-07-05 --------------------------------------------------------------

# a collection of stocks
mystocks <- c("AEP", "XOM", "WM", "JCI", "J", "AAL", "UAL", "RTX")

# read data
getSymbols(mystocks, from = "2015-01-01", src = "yahoo")
# getSymbols('ZM',src='csv')
# getSymbols('MSFT',src='csv')

candleChart(AEP, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")

candleChart(XOM, subset = "2020") # buy
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")

getSymbols("WM", from = "2015-01-01", src = "yahoo")
candleChart(WM, subset = "2020") # 
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(WM)

getSymbols("JCI", from = "2015-01-01", src = "yahoo")
candleChart(JCI, subset = "2020") # 
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(JCI)

getSymbols("J", from = "2015-01-01", src = "yahoo")
candleChart(J, subset = "2020") # 
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(J)

getSymbols("AAL", from = "2015-01-01", src = "yahoo")
candleChart(AAL, subset = "2020") # 
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")

getSymbols("UAL", from = "2015-01-01", src = "yahoo")
candleChart(UAL, subset = "2020") # 
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(UAL)

candleChart(RTX, subset = "2020") # 
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(RTX)
