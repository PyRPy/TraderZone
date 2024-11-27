
library(ggplot2) 

ggplot(stocks_potentials_sma_switch_low, aes(x = Symbol, y = rate_of_switches)) + 
  geom_bar(stat="identity")+ 
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))
