import pandas as pd
import numpy as np 
from sklearn.linear_model import LinearRegression
from statsmodels.tsa.arima.model import ARIMA

# add LSTM model from pytorch 
import torch 
import torch.nn as nn 
from sklearn.preprocessing import MinMaxScaler

import torch
import torch.nn as nn
import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler

class LSTMModel(nn.Module):
    """ PyTorch LSTM Model for Stock Price Forecasting """
    def __init__(self, input_size=1, hidden_size=50, num_layers=2, output_size=1):
        super(LSTMModel, self).__init__()
        self.lstm = nn.LSTM(input_size, hidden_size, num_layers, batch_first=True)
        self.fc = nn.Linear(hidden_size, output_size)

    def forward(self, x):
        lstm_out, _ = self.lstm(x)
        return self.fc(lstm_out[:, -1, :])  # Return last time step prediction


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

    def forecast_linear_regression(self, days=5):
        if "Close" not in self.data.columns:
            print("Error: 'Close' column not found in data.")
            return None

        df = self.data.copy()
        df["Day"] = np.arange(len(df))  # Create numerical index for regression

        X = df[["Day"]].values  # Feature (Days)
        y = df["Close"].values  # Target (Stock Prices)

        # Train the model
        model = LinearRegression()
        model.fit(X, y)

        # Predict for the next 'days' days
        future_days = np.arange(len(df), len(df) + days).reshape(-1, 1)
        predictions = model.predict(future_days)

        # Create a DataFrame for predicted prices
        forecast_df = pd.DataFrame({
            "Date": pd.date_range(start=df.index[-1] + pd.Timedelta(days=1), periods=days),
            "Predicted_Close": predictions
        })

        return forecast_df

    def forecast_arima(self, days=5):
        if "Close" not in self.data.columns:
            print("Error: 'Close' column not found in data.")
            return None

        df = self.data.copy()
        df = df["Close"].loc["2024-02-01":"2025-02-21"] # Use only the 'Close' price for forecasting

        # Fit the ARIMA model (p=5, d=1, q=0) → These values can be optimized
        model = ARIMA(df, order=(5, 1, 0))  # (p, d, q)
        model_fit = model.fit()

        # Forecast the next 'days' days
        forecast = model_fit.forecast(steps=days)

        # Create a DataFrame for predicted prices
        forecast_df = pd.DataFrame({
            "Date": pd.date_range(start=df.index[-1] + pd.Timedelta(days=1), periods=days),
            "Predicted_Close": forecast
        })

        return forecast_df

    # def detect_signals(self):
    #     self.data["Signal"] = ""
    #     for i in range(1, len(self.data)):
    #         if self.data["SMA_Short"][i] > self.data["SMA_Long"][i] and self.data["SMA_Short"][i - 1] <= self.data["SMA_Long"][i - 1]:
    #             self.data.loc[i, "Signal"] = "BUY"
    #         elif self.data["SMA_Short"][i] < self.data["SMA_Long"][i] and self.data["SMA_Short"][i - 1] >= self.data["SMA_Long"][i - 1]:
    #             self.data.loc[i, "Signal"] = "SELL"

    def forecast_lstm(self, days=5):
        """
        Uses an LSTM model to forecast future stock prices.
        :param days: Number of days to predict
        :return: DataFrame containing predicted prices
        """
        df = self.data.loc["2024-01-01":"2025-02-21"].copy()
        close_prices = df["Close"].values.reshape(-1, 1)

        # Normalize data
        scaler = MinMaxScaler(feature_range=(0, 1))
        scaled_data = scaler.fit_transform(close_prices)

        # Prepare training data
        sequence_length = 50  # Use last 50 days for prediction
        X_train, y_train = [], []
        for i in range(len(scaled_data) - sequence_length):
            X_train.append(scaled_data[i:i + sequence_length])
            y_train.append(scaled_data[i + sequence_length])

        X_train, y_train = np.array(X_train), np.array(y_train)

        # Convert to PyTorch tensors
        X_train_tensor = torch.tensor(X_train, dtype=torch.float32)
        y_train_tensor = torch.tensor(y_train, dtype=torch.float32)

        # Define and train LSTM model
        model = LSTMModel()
        criterion = nn.MSELoss()
        optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

        num_epochs = 20
        for epoch in range(num_epochs):
            model.train()
            optimizer.zero_grad()
            outputs = model(X_train_tensor)
            loss = criterion(outputs, y_train_tensor)
            loss.backward()
            optimizer.step()

        # Prepare last `sequence_length` days for prediction
        model.eval()
        last_sequence = scaled_data[-sequence_length:].reshape(1, sequence_length, 1)
        last_sequence_tensor = torch.tensor(last_sequence, dtype=torch.float32)

        predictions = []
        for _ in range(days):
            with torch.no_grad():
                pred_scaled = model(last_sequence_tensor).item()
            
            pred_actual = scaler.inverse_transform([[pred_scaled]])[0][0]
            predictions.append(pred_actual)

            # Update sequence with new prediction
            new_scaled = np.array([[pred_scaled]])
            last_sequence = np.append(last_sequence[:, 1:, :], new_scaled.reshape(1, 1, 1), axis=1)
            last_sequence_tensor = torch.tensor(last_sequence, dtype=torch.float32)

        # Create DataFrame for predicted prices
        forecast_df = pd.DataFrame({
            "Date": pd.date_range(start=df.index[-1] + pd.Timedelta(days=1), periods=days),
            "Predicted_Close": predictions
        })

        return forecast_df