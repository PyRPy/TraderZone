import mplfinance as mpf

class StockPlotter:
    @staticmethod
    def plot_candlestick_chart(data):
        sma_short_series = data["SMA_Short"].astype(float)
        sma_long_series = data["SMA_Long"].astype(float)
        # overlay the other moving average plot
        apds = [
            mpf.make_addplot(sma_short_series, color="blue"),
            mpf.make_addplot(sma_long_series, color="red"),
        ]
        print(data[["Open", "High", "Low","Close", "Volume"]].head())
        # generate candestick plot 
        mpf.plot(
            data[["Open", "High", "Low","Close", "Volume"]],
            type="candle",
            style="charles",
            addplot=apds,
            title="Candlestick Chart with SMA",
            ylabel="Price",
            volume=True,
            figratio=(10, 5),
        )