# reference from youtube 
# https://www.youtube.com/channel/UC0Amh8UkHvIVxPbxsrEBRMg
# load packages
library(quantmod)
library(PerformanceAnalytics)
# Stock watch list --------------------------------------------------------

# a collection of stocks
mystocks <- c("GE", "JNJ", "MSFT", "WMT", "CMI", "SBUX", "ZM", "^DJI")

# read data
getSymbols(mystocks, from = "2015-01-01", src = "yahoo")
# getSymbols('ZM',src='csv')
# getSymbols('MSFT',src='csv')

# Daily return and charts -------------------------------------------------

lineChart(DJI, subset = '2015::2020')
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
zoomChart(DJI, subset = "2020")

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
zoomChart(ZM, subset = "2020-06")

candleChart(GE, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
zoomChart(ZM, subset = "2020-06")

candleChart(CMI, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
zoomChart(ZM, subset = "2020-06")

getSymbols("BBY", from = "2015-01-01", src = "yahoo")
candleChart(BBY, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(BBY)

getSymbols("INO", from = "2015-01-01", src = "yahoo") # pass
candleChart(INO, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(INO)

getSymbols("PLUG", from = "2015-01-01", src = "yahoo") # pass
candleChart(PLUG, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(INO)

getSymbols("SSL", from = "2015-01-01", src = "yahoo") # pass
candleChart(SSL, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(INO)

getSymbols("XBI", from = "2015-01-01", src = "yahoo") # pass
candleChart(XBI, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(XBI)

getSymbols("MCHI", from = "2015-01-01", src = "yahoo") # buy
candleChart(MCHI, subset = "2020")
addSMA(n = 10, col = "white")
addSMA(n = 50, col = "blue")
addSMA(n = 200, col = "red")
addRSI(n = 14, maType = "EMA")
addBBands(n = 20, sd = 2)
addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
lineChart(XBI)
