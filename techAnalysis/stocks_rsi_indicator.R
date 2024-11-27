library(quantmod)
library(TTR)
getSymbols("AAPL")
chartSeries(AAPL, TA=NULL)
data=AAPL[,4]
AAPL$rsi = TTR::RSI(data)
AAPL$dema = TTR::DEMA(data)
hist(AAPL$rsi)

coredata(tail((RSI(Cl(AAPL))), 1))
     