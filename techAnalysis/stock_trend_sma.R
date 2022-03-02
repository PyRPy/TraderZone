# checking extreme returns for SPY
library(quantmod)
getSymbols("SPY", from = "2019-01-01")

chartSeries(SPY, 
            subset = "2021-07-01::",
            theme="white", 
            TA="addVo();addBBands();addRSI(14); 
            addSMA(20); addSMA(50); addSMA(200)")

ret_spy = diff(log(Cl(SPY)))
plot(ret_spy)

# plot(dailyReturn(SPY))

ret_spy_losses = - ret_spy

ret_spy_extremes = ret_spy_losses[ret_spy_losses > 0.025]
head(ret_spy_extremes)

plot(ret_spy_extremes, type = "h", auto.grid = FALSE)
