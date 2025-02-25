import mplfinance as mpf
import matplotlib.pyplot as plt

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
        # print(data[["Open", "High", "Low","Close", "Volume"]].head())
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

    @staticmethod
    def plot_stock_data(data, forecast_df=None):
        df = data

        # Plot historical stock prices
        plt.figure(figsize=(10, 6))
        plt.plot(df.index, df["Close"], label="Historical Prices", color="blue")

        # If forecast data is provided, plot it
        if forecast_df is not None:
            plt.plot(forecast_df["Date"], forecast_df["Predicted_Close"], 
                    marker="o", linestyle="dashed", color="red", label="ARIMA Forecast")

        # Labels and legend
        plt.title("Stock Price Trend with Forecast")
        plt.xlabel("Date")
        plt.ylabel("Stock Price")
        plt.legend()
        plt.grid(True)

        plt.show()
    @staticmethod
    def plot_trend_with_anomalies(data):
        """
        Plots the stock price trend along with detected anomalies.
        :param data: DataFrame containing 'Close' prices and 'Anomaly' labels (-1 for anomalies, 1 for normal)
        """
        plt.figure(figsize=(12, 6))
        plt.plot(data.index, data['Close'], label='Stock Price', color='blue', linewidth=2)
        
        # Plot anomalies
        anomalies = data[data['Anomaly'] == -1]
        plt.scatter(anomalies.index, anomalies['Close'], color='red', label='Anomalies', marker='o', s=80)
        
        plt.xlabel('Date')
        plt.ylabel('Stock Price')
        plt.title('Stock Price Trend with Anomalies')
        plt.legend()
        plt.grid()
        plt.show()

