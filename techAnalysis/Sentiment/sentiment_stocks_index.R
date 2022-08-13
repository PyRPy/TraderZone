
# Sentiment index and stocks index ----------------------------------------

library(readr)
library(lubridate)
library(quantmod)
library(ggplot2)
library(dplyr)


# Load the data -----------------------------------------------------------
# https://data.sca.isr.umich.edu/data-archive/mine.php

sentiment <- read_csv("sca-table1-on-2022-Aug-13.csv",
                      col_types = cols(Month = col_integer(),
                      Year = col_integer()), skip = 1)
sentiment <- sentiment[, c(1:3)]

sentiment <- within(sentiment, Year_Month <- sprintf("%d-%02d", Year, Month))

sentiment$Year_Month <- ym(sentiment$Year_Month) # keep year and month

# add the preliminary data on July, August 2022, not complete
new_data <- data.frame(Month=c(7,8), 
                       Year=c(2022, 2022), 
                       Index=c(51.5,55.1), 
                       Year_Month=c("2022-07-01", "2022-08-01"))
sentiment <- rbind(sentiment, new_data)
plot(sentiment$Year_Month, sentiment$Index, type = "l")


# Load stocks data --------------------------------------------------------

stock_list <- c("SPY")
getSymbols(stock_list, from = '2008-01-01', src = "yahoo")

stocks_df <- data.frame(Date = index(SPY), 
                        SPY_Price = as.numeric(Cl(SPY)))
names(stocks_df) <- c("Date", "SPY_Price")
stocks_df$Year_Month <- format(as.Date(stocks_df$Date), "%Y-%m")
stocks_df$Year_Month <- as.factor(stocks_df$Year_Month)
head(stocks_df)

stocks_df %>% ggplot(aes(x = Year_Month, y = SPY_Price, group = Year_Month)) +
  geom_boxplot()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  xlab("")+
  labs(title = "SPY Price Boxplot Monthly")

stocks_month_median <- stocks_df %>% 
  filter(Date <= '2022-08-31') %>% 
  group_by(Year_Month)%>% 
  summarise(Price_Median = median(SPY_Price), Year_Month) %>% 
  unique()


# Plot the sentiment index and stocks index in parallel -------------------

par(mfrow = c(2, 1))
plot(sentiment$Year_Month, sentiment$Index, 
     main = "Consumer Sentiment", type = "l") 
plot(stocks_month_median$Year_Month, stocks_month_median$Price_Median, 
     main="Stocks Index 'SPY'", ylab = "SPY Price ('$')", type="l")


# Correlation between sentiment and stock price ? -------------------------

par(mfrow = c(1, 1))
plot(sentiment$Index, stocks_month_median$Price_Median) 
cor(sentiment$Index, stocks_month_median$Price_Median)  


# What you can tell from these two clusters ? -----------------------------

# combine two data sets 
sentiment_stock <- cbind(sentiment, stocks_month_median$Price_Median)
colnames(sentiment_stock) <- c("Month", "Year", "Index", "Year_Month", "Stock_Price")

# use hierarchical cluster
distance <- dist(sentiment_stock[, c("Index", "Stock_Price")], method = "euclidean")
fit <- hclust(distance, method = "complete")
plot(fit)

# group by distances
clusters <- cutree(fit, h=300) # use $300 as a cutoff price

# Scatter plot with clusters ----------------------------------------------

sentiment_stock_clusters <- cbind(sentiment_stock, clusters)
sentiment_stock_clusters$clusters <- as.factor(sentiment_stock_clusters$clusters)

sentiment_stock_clusters %>% ggplot(aes(x=Index, y=Stock_Price, color = clusters))+
  geom_point()+
  labs(title = "Sentiment Index vs Stock Price - SPY")


# Plots in parallel with clusters in mind ---------------------------------

library(gridExtra)
plt1 <- ggplot(sentiment_stock_clusters, aes(x=Year_Month, y=Stock_Price, color = clusters))+
  geom_point()+
  labs(title = "Stock Price - Clusters")

plt2 <- ggplot(sentiment_stock_clusters, aes(x=Year_Month, y=Index, color = clusters))+
  geom_point()+
  labs(title = "Sentiment Index - Clusters")

grid.arrange(plt1, plt2, ncol=1, nrow=2)
