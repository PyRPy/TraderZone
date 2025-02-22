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
