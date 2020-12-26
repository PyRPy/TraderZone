# Cross validation with time sequence in Caret ----------------------------
# https://www.r-bloggers.com/2013/01/time-series-cross-validation-5/

# Load the dataset, adjust, and convert to monthly returns

# Data Preparation --------------------------------------------------------

set.seed(42)
library(quantmod)
getSymbols('SPY', from='2018-01-01')
SPY <- adjustOHLC(SPY, symbol.name='SPY')
candleChart(SPY)
Target <- Cl(SPY)
Direction <- ifelse(dailyReturn(SPY) >=0, "UP", "Down")

# Calculate some technical indicators
periods <- c(20, 50)
Lags <- data.frame(lapply(c(1:5), function(x) Lag(Target, x)))
EMAs <- data.frame(lapply(periods, function(x) {
  out <- EMA(Target, x)
  names(out) <- paste('EMA', x, sep='.')
  return(out)
}))
RSIs <- data.frame(lapply(14, function(x) {
  out <- RSI(Cl(SPY), x)
  names(out) <- paste('RSI', x, sep='.')
  return(out)
}))

# DVIs <- data.frame(lapply(periods, function(x) {
#   out <- DVI(Cl(SPY), x)
#   out <- out$dvi
#   names(out) <- paste('DVI', x, sep='.')
#   return(out)
# }))

dat <- data.frame(lag(Direction, -1), Direction, Cl(SPY), Lags, EMAs, RSIs)

# add RSI as a predictor
dat$RSI.14 <- ifelse(dat$RSI.14 > 70, 1, 0)
colnames(dat) <- c("Direction", "UpDown", "Close", "Lag1", "Lag2", "Lag3", 
                   "Lag4", "Lag5", "EMA20", "EMA50", "RSI")
dat <- na.omit(dat)
head(dat)

# add another indicator
dat$EMA <- ifelse(dat$EMA20 > dat$EMA50, 1, 0)

# Logistic Regression -----------------------------------------------------

glm.fit <- glm(Direction ~ UpDown + Close + Lag1 + Lag2 + Lag3 + Lag4 + 
                 Lag5 + EMA + RSI, data=dat, family=binomial)
summary(glm.fit)

glm.probs <- predict(glm.fit, type="response")
glm.probs[1:10]

glm.pred <- rep("Down", nrow(dat))
glm.pred[glm.probs > 0.5] = "Up"

with(data=dat, table(glm.pred, Direction))


# Random Forest -----------------------------------------------------------

library(randomForest)
rf.fit <- randomForest(Direction ~ UpDown + Close + Lag1 + Lag2 + Lag3 + 
                         Lag4 + Lag5 + EMA + RSI, mtry= 5, 
                       data=dat)

rf.pred <- predict(rf.fit, type = "class")
with(data=dat, table(rf.pred, Direction))

library(caret)
with(data = dat,
confusionMatrix(Direction, rf.pred)
)
