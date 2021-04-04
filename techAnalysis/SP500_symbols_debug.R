sampledStocks <- subset(companylist, `GICS Sector` == "Energy")

# store data in a new environment
stocksEnv <- new.env()
getSymbols(sampledStocks$Symbol, env = stocksEnv, 
           from = '2021-01-01', src = "yahoo")


# produce return report
goodCandidate <- data.frame()

for (stock in sampledStocks$Symbol) {
  dret <- dailyReturn(stocksEnv[[stock]])
  pret <- Return.cumulative(dret)
  if (sd(dret) < selectedStd && as.numeric(pret) > selectedRtn) {
    tmp <- data.frame(Symbol = stock, 
                      sd = round(sd(dret), 3), 
                      ret = round(as.numeric(pret), 3))
    goodCandidate <- rbind(goodCandidate, tmp)
    
  }
}

# check the list
# goodCandidate

# produce candleChart for selected stocks
for (stock in goodCandidate$Symbol) {
  candleChart(stocksEnv[[stock]], name = stock)
}

goodCandidate

# these two stocks caused trouble
getSymbols("CXO", env = stocksEnv, 
           from = '2021-01-01', src = "yahoo")

getSymbols("COP", env = stocksEnv, 
           from = '2021-01-01', src = "yahoo")
