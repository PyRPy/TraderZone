from stock_analysis.stock_analyzer import StockAnalyzer 
from stock_analysis.plotter import StockPlotter 
# before run the program check the dependencies
# pip install -r requirements.txt

def main():
    filename = "data/Data_SPY.csv"
    analyzer = StockAnalyzer(filename)
    analyzer.calculate_sma()
    analyzer.detect_signals() 

    print(analyzer.data[["Date", "Price", "Signal"]])
    StockPlotter.plot_chart(analyzer.data)

if __name__ == "__main__":
    main()