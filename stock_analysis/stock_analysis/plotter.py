import matplotlib.pyplot as plt

class StockPlotter:
    @staticmethod
    def plot_chart(data):
        plt.figure(figsize=(10, 5))
        plt.plot(data["Date"], data["Price"], label="Stock Price", color="black")
        plt.plot(data["Date"], data["SMA_Short"], label="Short SMA", color="blue", linestyle="dashed")
        plt.plot(data["Date"], data["SMA_Long"], label="Long SMA", color="red", linestyle="dashed")

        buy_signals = data[data["Signal"] == "BUY"]
        sell_signals = data[data["Signal"] == "SELL"]
        plt.scatter(buy_signals["Date"], buy_signals["Price"], label="BUY", marker="^", color="green", s=100)
        plt.scatter(sell_signals["Date"], sell_signals["Price"], label="SELL", marker="v", color="red", s=100)

        plt.legend()
        plt.xlabel("Date")
        plt.ylabel("Price")
        plt.title("Stock Price with SMA Crossover Signals")
        plt.grid()
        plt.show()
