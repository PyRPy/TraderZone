from stock_analysis.stock_analyzer import StockAnalyzer 
from stock_analysis.plotter import StockPlotter 
# before run the program check the dependencies
# pip install -r requirements.txt

def main():
    filename = "data/Data_SPY2.csv"
    analyzer = StockAnalyzer(filename)
    analyzer.calculate_sma()
    # analyzer.detect_signals() 
    StockPlotter.plot_candlestick_chart(analyzer.data.loc["2024-02-01":"2025-02-10"])
 

if __name__ == "__main__":
    main()