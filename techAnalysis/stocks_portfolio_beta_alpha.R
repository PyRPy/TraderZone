
# Load libraries ----------------------------------------------------------
# codes from https://www.codingfinance.com/post/2018-04-25-portfolio-beta/
library(tidyquant)
library(timetk)
library(tidyverse)


# load data from tickers --------------------------------------------------

tikers = c("EWC", "HDRO", "NUSI", "TCHP", "UBER", "VNM", "WEAT")
costs = c(753, 933, 817, 1595, 890, 307, 145)
wts = costs / sum(costs)
sum(wts)

price_data <- tq_get(tikers,
                     from = "2021-01-01",
                     to = "2021-12-31",
                     get = "stock.prices")


# returns
ret_data <- price_data %>% 
  group_by(symbol) %>% 
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period="daily",
               col_rename = "ret")

# portfolio returns
port_ret <- ret_data %>% 
  tq_portfolio(assets_col = symbol,
               returns_col = ret,
               weights = wts,
               col_rename = 'port_ret',
               geometric = FALSE)

# benchmark returns using S&P 500 ETF
bench_price <- tq_get('SPY',
                      from = '2021-01-01',
                      to = '2021-12-31',
                      get = 'stock.prices')

bench_ret <- bench_price %>% 
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "daily",
               col_rename = "bench_ret")

# combined return tables
comb_ret <- left_join(port_ret, bench_ret, by='date')
head(comb_ret)

# scatter plot, portfolio returns vs benchmark returns
comb_ret %>%
  ggplot(aes(x = bench_ret,
             y = port_ret)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = 'lm',
              se = FALSE) +
  theme_classic() +
  labs(x = 'Benchmark Returns',
       y = "Portfolio Returns",
       title = "Portfolio returns vs Benchmark returns") +
  scale_x_continuous(breaks = seq(-0.1,0.1,0.01),
                     labels = scales::percent) +
  scale_y_continuous(breaks = seq(-0.1,0.1,0.01),
                     labels = scales::percent)

# Linear model ------------------------------------------------------------
model <- lm(port_ret ~ bench_ret, data = comb_ret)
model_alpha = model$coefficients[1]
model_beta = model$coefficients[2]

# portfolio alpha is 
model_alpha

# portfolio beta is
model_beta

# Cumulative returns ------------------------------------------------------
wts_tbl = tibble(symbol = tikers,
                 wts = wts)

ret_data = left_join(ret_data, wts_tbl, by='symbol')
ret_data <- ret_data %>%
  mutate(wt_return = wts * ret)

port_ret <- ret_data %>%
  group_by(date) %>%
  summarise(port_ret = sum(wt_return))

port_cumulative_ret <- port_ret %>%
  mutate(cr = cumprod(1 + port_ret))

# use tidyquant
port_ret_tidyquant <- ret_data %>%
  tq_portfolio(assets_col = symbol,
               returns_col = ret,
               weights = wts,
               col_rename = 'port_ret',
               geometric = FALSE)

port_cumulative_ret_tidyquant <- port_ret_tidyquant %>%
  mutate(cr = cumprod(1 + port_ret))

port_cumulative_ret %>%
  mutate(port_ret_tidyquant = port_cumulative_ret_tidyquant$cr) %>%
  select(-port_ret) %>%
  rename(long_method = cr) %>%
  gather(long_method,port_ret_tidyquant,
         key = port_method,
         value = cr) %>%
  ggplot(aes(x = date, y = cr, color = port_method)) +
  geom_line() +
  labs(x = 'Date',
       y = 'Cumulative Returns',
       title = 'Portfolio Cumulative Returns') +
  theme_classic() +
  scale_y_continuous(breaks = seq(1,2,0.1)) +
  scale_x_date(date_breaks = 'year',
               date_labels = '%Y')
