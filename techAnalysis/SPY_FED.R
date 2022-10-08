
# Read the fed interest rate data -----------------------------------------
# https://fred.stlouisfed.org/series/FEDFUNDS
library(readr)
rates <- read_csv("FEDFUNDS_2022sep.csv", 
                  col_types = cols(DATE = col_date(format = "%Y-%m-%d")))
colnames(rates) <- c("Date", "Rate")
rates <- rbind(rates, c("2022-10-01", 3.25))


# Download SPY data -------------------------------------------------------

library(quantmod)
getSymbols("SPY", from = "2017-01-01", src = "yahoo")


# Compare the trends ------------------------------------------------------

par(mfrow = c(2, 1))
plot(rates$Date, rates$Rate, type = "l", main = "Fed Rates %", xlab = "")
plot(SPY$SPY.Close, main = "SPY prices $")


# Key points --------------------------------------------------------------

# two years ultra low interest rates boiled stock markets
# rate hikes started corrections on stocks
# rate hikes may not end yet!
