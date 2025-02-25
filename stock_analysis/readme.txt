How the project is organized

stock_analysis/
│── data/
│   └── stock_data.txt
│── stock_analysis/
│   ├── __init__.py
│   ├── stock_analyzer.py
│   ├── plotter.py
│── main.py
│── requirements.txt

#--- this example comes from ChatGPT with modifications ---#
Benefits of This Structure
Modular: stock_analyzer.py handles analysis, plotter.py handles visualization.
Reusable: You can reuse StockAnalyzer in other projects.
Scalable: Easily add more indicators like RSI, Bollinger Bands, or real-time APIs.

#--- how to run the analysis ---# 
- before run the program check the dependencies
- pip install -r requirements.txt

#--- main updates and modifications ---#
- 2/25/2205	add logistic regression to predict next day up / down trend
		add anomaly detection Isolation Forest to spot 'outliers' in the price trend 
		update the plotter to highlight the outliers

