
companylist %>% filter(`GICS Sub-Industry` == "Movies & Entertainment") %>% 
  select(Symbol, `GICS Sector`)

movie_list <- c("FOXA", "FOX", "LYV", "NFLX", "VIAC", "DIS")
stocksEnv <- new.env()
getSymbols(movie_list, env = stocksEnv, 
           from = "2021-01-01", src = "yahoo")


for (stock in sampledStocks$Symbol) {
  candleChart(stocksEnv[[stock]], name = stock)
}

for (sub in sort(companylist$`GICS Sub-Industry`)[1:5]) {
  cat(sub, '----- \n')
  get_data_sub(sub, '2021-01-01', 0.05, 0.01)
  
}

# find the keywords in sectors
grep('Cable', companylist$`GICS Sub-Industry`)

companylist[grep('Cable', companylist$`GICS Sub-Industry`), ]
