# Crypto prices -----------------------------------------------------------

library(quantmod)
portfolio = c("BTC-USD","ETH-USD","LTC-USD","SHIB-USD","DOGE-USD")
getSymbols(portfolio, src="yahoo", from="2019-01-01")

chartSeries(`BTC-USD`)
chartSeries(`BTC-USD`,
            TA="addVo();addBBands();addRSI();addDEMA()")


chartSeries(`DOGE-USD`, subset='2021-01::')
chartSeries(`SHIB-USD`, subset='2021-01::')


# Blockchain related ETFs -------------------------------------------------

blockchainETFs = c("BITQ", "BITO", "BITS", "BLOK", "BLCN")
getSymbols(blockchainETFs, src="yahoo")

chartSeries(BITO)
chartSeries(BITQ)
chartSeries(BITS)
chartSeries(BLOK)
chartSeries(BLCN)
