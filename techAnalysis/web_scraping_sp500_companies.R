# Web scraping S&P 500 companies table from wikipedia ---------------------

# load libraries
library(tidyverse)
library(rvest)

# target webpage contaning table you need
url500 <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
mytable <- read_html(url500)
table500 <- html_table(mytable, fill = TRUE)

# first table 
table500 <- table500[[1]]

# check table content and overview
head(table500)

# convert to factor from 'character'
table500$`GICS Sector` <- as.factor(table500$`GICS Sector`)

# show how many companies in each sector (11)
table500 %>% ggplot(aes(x=`GICS Sector`)) +
  geom_bar() + 
  coord_flip() # show text clearly
