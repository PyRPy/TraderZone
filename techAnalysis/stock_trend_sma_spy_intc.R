# checking extreme returns for SPY
library(quantmod)

# SPY trend and variations ------------------------------------------------

getSymbols(c("SPY", "INTC"), from = "2019-01-01")

chartSeries(SPY, 
            subset = "2020-01-01::",
            theme="white", 
            TA="addVo();addBBands();addRSI(14); 
            addSMA(20); addSMA(50); addSMA(200)")

plot(dailyReturn(SPY))

# INTC trend and variations -----------------------------------------------
chartSeries(INTC, 
            subset = "2020-01-01::",
            theme="white", 
            TA="addVo();addBBands();addRSI(14); 
            addSMA(20); addSMA(50); addSMA(200)")

plot(dailyReturn(INTC))


# Simple compare ----------------------------------------------------------
par(mfrow = c(2, 1))
plot(dailyReturn(SPY), ylim=c(-0.2, 0.2))
plot(dailyReturn(INTC), ylim = c(-0.2, 0.2))

par(mfrow = c(1, 1))
plot(dailyReturn(SPY), ylim=c(-0.2, 0.2), main = "INTC - RED")
lines(dailyReturn(INTC), 
      ylim = c(-0.2, 0.2), 
      col = "red")
