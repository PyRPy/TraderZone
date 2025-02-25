from stock_analysis.stock_analyzer import StockAnalyzer 
from stock_analysis.plotter import StockPlotter 
# before run the program check the dependencies
# pip install -r requirements.txt

def main():
    filename = "data/Data_SPY2.csv"
    analyzer = StockAnalyzer(filename)
    analyzer.calculate_sma()
    # analyzer.detect_signals() 

    # forecast_df = analyzer.forecast_linear_regression(days=5)

    # if forecast_df is not None:
    #     print("\n 5-Day Stock Price Prediction:")
    #     print(forecast_df)

    # arima_forecast_df = analyzer.forecast_arima(days=5)

    # if arima_forecast_df is not None:
    #     print("\n 5-Day ARIMA Stock Price Prediction:")
    #     print(arima_forecast_df)

    #     # Plot historical data with ARIMA forecast
    #     plotter = StockPlotter()
    #     plotter.plot_stock_data(analyzer.data.loc["2024-01-01":"2025-02-21"], forecast_df=arima_forecast_df)
    
    # plotter.plot_candlestick_chart(analyzer.data.loc["2024-02-01":"2025-02-10"])

    # lstm_forecast_df = analyzer.forecast_lstm(days=5)
    # if lstm_forecast_df is not None:
    #     print("\n 5-Day LSTM Stock Price Prediction:")
    #     print(lstm_forecast_df)

    # plotter = StockPlotter()
    # plotter.plot_stock_data(analyzer.data.loc["2024-01-01":"2025-02-21"], forecast_df=lstm_forecast_df)

    # Predict next day's movement (Up or Down)
    movement_prediction, accuracy = analyzer.predict_next_day_movement()

    if movement_prediction == 1:
        print(f"\n Prediction: Stock will go UP tomorrow (Accuracy: {accuracy:.2%})")
    else:
        print(f"\n Prediction: Stock will go DOWN tomorrow (Accuracy: {accuracy:.2%})")

    # Detect anomalies in stock trends
    anomaly_df = analyzer.detect_anomalies()

    print("\n Anomaly Detection Results:")
    print(anomaly_df[anomaly_df["Anomaly"] == -1])  # Show only detected anomalies
    print(anomaly_df.head())

    # Plot anomalies alongside stock prices
    plotter = StockPlotter()
    plotter.plot_trend_with_anomalies(anomaly_df)


if __name__ == "__main__":
    main()