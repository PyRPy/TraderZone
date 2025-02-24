import pandas as pd

class StockAnalyzer:
    def __init__(self, filename):
        self.filename = filename
        self.data = self.load_stock_data()

    def load_stock_data(self):
        df = pd.read_csv(self.filename, header = 0, names=["Date", "Close", "Volume", "Open", "High", "Low"])
        df["Date"] = pd.to_datetime(df["Date"])
        df.set_index("Date", inplace=True) 
        df.sort_index(inplace=True) # fix the reverse date problem when plotting
        return df

    def calculate_sma(self, short_period=5, long_period=20):
        self.data["SMA_Short"] = self.data["Close"].rolling(window=short_period).mean()
        self.data["SMA_Long"] = self.data["Close"].rolling(window=long_period).mean()

        # Fix: Ensure no NaN values (fill with first valid value)
        self.data["SMA_Short"].fillna(method="bfill", inplace=True)
        self.data["SMA_Long"].fillna(method="bfill", inplace=True)

    # def detect_signals(self):
    #     self.data["Signal"] = ""
    #     for i in range(1, len(self.data)):
    #         if self.data["SMA_Short"][i] > self.data["SMA_Long"][i] and self.data["SMA_Short"][i - 1] <= self.data["SMA_Long"][i - 1]:
    #             self.data.loc[i, "Signal"] = "BUY"
    #         elif self.data["SMA_Short"][i] < self.data["SMA_Long"][i] and self.data["SMA_Short"][i - 1] >= self.data["SMA_Long"][i - 1]:
    #             self.data.loc[i, "Signal"] = "SELL"