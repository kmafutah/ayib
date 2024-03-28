import yfinance as yf
import pandas as pd
import os
from talib import RSI, STOCH, CCI, ADX, MOM, MACD, STOCHRSI, WILLR, PPO, ULTOSC

def generate_md_file(data, pivot_data, timeframe,symbol):
    md_file_path = f'data/{symbol}_Technical_Analysis_{timeframe}.md'
    
    with open(md_file_path, 'w') as md_file:
        md_file.write(f"# {symbol} Technical Analysis\n\n")
        md_file.write(f"**Timeframe:** {timeframe}\n\n")
        
        # Summary section
        md_file.write("## Summary\n\n")
        md_file.write("* **Overall:** Neutral\n\n")
        
        # Oscillators section
        md_file.write("## Oscillators\n\n")
        md_file.write(f"| Indicator Name                   | {timeframe}            |\n")
        md_file.write("|----------------------------------|------------------|\n")
        
        # Populate oscillators data (assuming data is provided)
        oscillators_data = {
            "Relative Strength Index (14)": data['RSI'].iloc[-1],
            "Stochastic %K (14, 3, 3)": data['%K'].iloc[-1],
            "Commodity Channel Index (20)": data['CCI'].iloc[-1],
            "Average Directional Index (14)": data['ADX'].iloc[-1],
            "Awesome Oscillator": data['AO'].iloc[-1],
            "Momentum (10)": data['MOM'].iloc[-1],
            "MACD Level (12, 26)": data['MACD'].iloc[-1],
            "Stochastic RSI Fast (3, 3, 14, 14)": data['%K_RSI'].iloc[-1],
            "Williams Percent Range (14)": data['WILLR'].iloc[-1],
            "Bull Bear Power": data['BullBearPower'].iloc[-1],
            "Ultimate Oscillator (7, 14, 28)": data['UltimateOsc'].iloc[-1],
        }
        
        for indicator, value in oscillators_data.items():
            md_file.write(f"| {indicator:<32} | {value:<16} |\n")
        
        md_file.write("\n")
        
        # Moving Averages section
        md_file.write("## Moving Averages\n\n")
        md_file.write(f"| Indicator Name                          | {timeframe}            |\n")
        md_file.write("|-----------------------------------------|------------------|\n")
        
        # Populate moving averages data (assuming data is provided)
        moving_averages_data = {
            "Exponential Moving Average (10)": data['EMA10'].iloc[-1],
            "Simple Moving Average (10)": data['SMA10'].iloc[-1],
            "Exponential Moving Average (20)": data['EMA20'].iloc[-1],
            "Simple Moving Average (20)": data['SMA20'].iloc[-1],
            "Exponential Moving Average (30)": data['EMA30'].iloc[-1],
            "Simple Moving Average (30)": data['SMA30'].iloc[-1],
            "Exponential Moving Average (50)": data['EMA50'].iloc[-1],
            "Simple Moving Average (50)": data['SMA50'].iloc[-1],
            "Exponential Moving Average (100)": data['EMA100'].iloc[-1],
            "Simple Moving Average (100)": data['SMA100'].iloc[-1],
            "Exponential Moving Average (200)": data['EMA200'].iloc[-1],
            "Simple Moving Average (200)": data['SMA200'].iloc[-1],
            "Ichimoku Base Line (9, 26, 52, 26)": data['Ichimoku'].iloc[-1],
            "Volume Weighted Moving Average (20)": data['VWMA20'].iloc[-1],
            "Hull Moving Average (9)": data['HullMA9'].iloc[-1],
        }
        
        for indicator, value in moving_averages_data.items():
            md_file.write(f"| {indicator:<41} | {value:<16} |\n")
        
        md_file.write("\n")
                        
        # Pivots section
        md_file.write(f"## Pivots for {timeframe}\n\n")
        md_file.write("| Pivot         | Classic | Fibonacci | Camarilla | Woodie | DM      |\n")
        md_file.write("|---------------|---------|-----------|-----------|--------|---------|\n")

        # Check if pivot_data is a DataFrame
        if isinstance(pivot_data, pd.DataFrame):
            # Pivot levels to include in the table
            pivot_levels = ['S3', 'S2', 'S1', 'Pivot (P)', 'R1', 'R2', 'R3']
            
            # Populate pivots data
            for pivot_level in pivot_levels:
                classic_pivot = pivot_data[f'Classic_{pivot_level}'].iloc[-1]
                fibonacci_pivot = pivot_data[f'Fibonacci_{pivot_level}'].iloc[-1]
                camarilla_pivot = pivot_data[f'Camarilla_{pivot_level}'].iloc[-1]
                woodie_pivot = pivot_data[f'Woodie_{pivot_level}'].iloc[-1]
                dm_pivot = pivot_data[f'DM_{pivot_level}'].iloc[-1]
                md_file.write(f"| {pivot_level:<14} | {classic_pivot:<7} | {fibonacci_pivot:<9} | {camarilla_pivot:<9} | {woodie_pivot:<6} | {dm_pivot:<7} |\n")
        else:
            # Handle the case when pivot_data is not a DataFrame
            # You can write a message or take appropriate action
            md_file.write("Pivot data is not in the expected format.\n")




def calculate_ao(high, low, fast_period=5, slow_period=34):
    # Calculate the SMA of the median price for the fast and slow periods
    fast_sma = (high + low) / 2.0
    slow_sma = (high + low) / 2.0
    
    for i in range(1, fast_period):
        fast_sma += (high.shift(-i) + low.shift(-i)) / 2.0
    
    for i in range(1, slow_period):
        slow_sma += (high.shift(-i) + low.shift(-i)) / 2.0
    
    fast_sma /= fast_period
    slow_sma /= slow_period
    
    # Calculate the Awesome Oscillator (AO)
    ao = fast_sma - slow_sma
    return ao

def calculate_bull_bear_power(close, sma_period=14):
    # Calculate the Simple Moving Average (SMA) for the specified period
    sma = close.rolling(window=sma_period).mean()

    # Calculate the Bull/Bear Power indicator
    bull_bear_power = close - sma

    return bull_bear_power

def calculate_hullma(close, window=9):
    weighted_moving_avg = close.rolling(window=window).apply(lambda x: (x * (window // 2)).sum() / (window * (window + 1) // 2), raw=True)
    hull_moving_avg = weighted_moving_avg.rolling(window=int(window ** 0.5)).mean()
    return hull_moving_avg

def calculate_pivots(high, low, close, index):
    pivot_data = pd.DataFrame(index=index)

    # Calculate Classic pivot points
    pivot_data['Classic_Pivot (P)'] = (high + low + close) / 3
    pivot_data['Classic_S3'] = pivot_data['Classic_Pivot (P)'] - 2 * (high - pivot_data['Classic_Pivot (P)'])
    pivot_data['Classic_S2'] = pivot_data['Classic_Pivot (P)'] - (high - low)
    pivot_data['Classic_S1'] = 2 * pivot_data['Classic_Pivot (P)'] - high
    pivot_data['Classic_R1'] = 2 * pivot_data['Classic_Pivot (P)'] - low
    pivot_data['Classic_R2'] = pivot_data['Classic_Pivot (P)'] + (high - low)
    pivot_data['Classic_R3'] = pivot_data['Classic_Pivot (P)'] + 2 * (high - pivot_data['Classic_Pivot (P)'])

    # Calculate Fibonacci pivot points
    pivot_data['Fibonacci_Pivot (P)'] = (high + low + close) / 3
    pivot_data['Fibonacci_S3'] = pivot_data['Fibonacci_Pivot (P)'] - 2 * (high - pivot_data['Fibonacci_Pivot (P)'])
    pivot_data['Fibonacci_S2'] = pivot_data['Fibonacci_Pivot (P)'] - (high - low) * 0.618
    pivot_data['Fibonacci_S1'] = pivot_data['Fibonacci_Pivot (P)'] - (high - low) * 0.382
    pivot_data['Fibonacci_R1'] = pivot_data['Fibonacci_Pivot (P)'] + (high - low) * 0.382
    pivot_data['Fibonacci_R2'] = pivot_data['Fibonacci_Pivot (P)'] + (high - low) * 0.618
    pivot_data['Fibonacci_R3'] = pivot_data['Fibonacci_Pivot (P)'] + 2 * (high - pivot_data['Fibonacci_Pivot (P)'])

    # Calculate Camarilla pivot points
    pivot_data['Camarilla_S3'] = close - (0.55 * (high - low))
    pivot_data['Camarilla_S2'] = close - (0.72 * (high - low))
    pivot_data['Camarilla_S1'] = close - (1.09 * (high - low))
    pivot_data['Camarilla_Pivot (P)'] = (high + low + close) / 3
    pivot_data['Camarilla_R1'] = close + (0.55 * (high - low))
    pivot_data['Camarilla_R2'] = close + (0.72 * (high - low))
    pivot_data['Camarilla_R3'] = close + (1.09 * (high - low))

    # Calculate Woodie pivot points
    pivot_data['Woodie_Pivot (P)'] = (high + low + 2 * close) / 4
    pivot_data['Woodie_S3'] = (2 * pivot_data['Woodie_Pivot (P)']) - high
    pivot_data['Woodie_S2'] = pivot_data['Woodie_Pivot (P)'] - (high - low)
    pivot_data['Woodie_S1'] = (2 * pivot_data['Woodie_Pivot (P)']) - high
    pivot_data['Woodie_R1'] = (2 * pivot_data['Woodie_Pivot (P)']) - low
    pivot_data['Woodie_R2'] = pivot_data['Woodie_Pivot (P)'] + (high - low)
    pivot_data['Woodie_R3'] = pivot_data['Woodie_Pivot (P)'] + 2 * (high - low)

    # Calculate DM pivot points
    pivot_data['DM_Pivot (P)'] = (2 * high + low + close) / 4
    pivot_data['DM_S3'] = pivot_data['DM_Pivot (P)'] - (high - low)
    pivot_data['DM_S2'] = pivot_data['DM_Pivot (P)'] - 2 * (high - low)
    pivot_data['DM_S1'] = (2 * pivot_data['DM_Pivot (P)']) - high
    pivot_data['DM_R1'] = pivot_data['DM_Pivot (P)'] + (high - low)
    pivot_data['DM_R2'] = pivot_data['DM_Pivot (P)'] + 2 * (high - low)
    pivot_data['DM_R3'] = close + (2 * high - low)

    # Replace missing data with placeholder "—"
    pivot_data.fillna(0, inplace=True)
    # Set the index of pivot_data to match the input index
    pivot_data.index = index

    return pivot_data

# Fetch historical data for BTCUSD
symbol = 'BTC-USD'
# timeframes = ['1m', '2m', '5m', '15m', '30m', '60m', '90m', '1h', '1d', '5d', '1wk', '1mo', '3mo']
timeframes = ['1m','2m','5m','15m','1h','90m','5d','1mo','3mo']
# all_data = pd.DataFrame()

# # Create a directory for the symbol if it doesn't exist
symbol_dir = os.path.join('data', symbol)
os.makedirs(symbol_dir, exist_ok=True)

for interval in timeframes:
    if interval in ['1m']:
        data = yf.download(symbol, period="7d", interval=interval)
    elif interval in ['2m','5m', '15m','30m','90m']:
        data = yf.download(symbol, period="60d", interval=interval)
    elif interval == '1h':
        data = yf.download(symbol, period="730d", interval=interval)   
    else:
        data = yf.download(symbol, period="max", interval=interval,)

    # Save data to CSV file in the corresponding directory
    interval_file = os.path.join(symbol_dir, f"{interval}.csv")
    data.to_csv(interval_file)

print("Data saved successfully in the 'data' directory.")

for timeframe in timeframes:
    file_path = f'/Users/kudakwashemafutah/LLM/thisisit/ayibSignal/ayibsignals/data/BTC-USD/{timeframe}.csv'
    data = pd.read_csv(file_path, parse_dates=True, index_col=0)
    # data = pd.read_csv('/Users/kudakwashemafutah/LLM/thisisit/ayibSignal/ayibsignals/data/BTC-USD/1mo.csv',parse_dates=True,index_col='Date')

    # # Calculate technical indicators
    data['RSI'] = RSI(data['Close'], timeperiod=14)
    data['%K'], data['%D'] = STOCH(data['High'], data['Low'], data['Close'], fastk_period=14, slowk_period=3, slowd_period=3)
    data['CCI'] = CCI(data['High'], data['Low'], data['Close'], timeperiod=20)
    data['ADX'] = ADX(data['High'], data['Low'], data['Close'], timeperiod=14)
    data['AO'] = calculate_ao(data['High'], data['Low'])
    data['MOM'] = MOM(data['Close'], timeperiod=10)
    data['MACD'], _, _ = MACD(data['Close'], fastperiod=12, slowperiod=26, signalperiod=9)
    data['%K_RSI'], data['%D_RSI'] = STOCHRSI(data['Close'], timeperiod=14, fastk_period=3, fastd_period=3)
    data['WILLR'] = WILLR(data['High'], data['Low'], data['Close'], timeperiod=14)
    data['BullBearPower'] = calculate_bull_bear_power(data['Close'])
    data['UltimateOsc'] = ULTOSC(data['High'], data['Low'], data['Close'], timeperiod1=7, timeperiod2=14, timeperiod3=28)

    # # Calculate moving averages
    data['EMA9'] = data['Close'].ewm(span=9, adjust=False).mean()
    data['EMA10'] = data['Close'].ewm(span=10, adjust=False).mean()
    data['SMA10'] = data['Close'].rolling(window=10).mean()
    data['EMA20'] = data['Close'].ewm(span=20, adjust=False).mean()
    data['EMA26'] = data['Close'].ewm(span=26, adjust=False).mean()
    data['SMA20'] = data['Close'].rolling(window=20).mean()
    data['EMA30'] = data['Close'].ewm(span=30, adjust=False).mean()
    data['SMA30'] = data['Close'].rolling(window=30).mean()
    data['EMA50'] = data['Close'].ewm(span=50, adjust=False).mean()
    data['SMA50'] = data['Close'].rolling(window=50).mean()
    data['EMA100'] = data['Close'].ewm(span=100, adjust=False).mean()
    data['SMA100'] = data['Close'].rolling(window=100).mean()
    data['EMA200'] = data['Close'].ewm(span=200, adjust=False).mean()
    data['SMA200'] = data['Close'].rolling(window=200).mean()
    data['Ichimoku'] = (data['EMA9'] + data['EMA26'] + data['Close']) / 3
    data['VWMA20'] = (data['Close'] * data['Volume']).rolling(window=20).sum() / data['Volume'].rolling(window=20).sum()
    data['HullMA9'] = calculate_hullma(data['Close'])

    # # Calculate pivot points
    pivot_data = calculate_pivots(data['High'], data['Low'], data['Close'], data.index)

    # Specify the file path where you want to save the Markdown file
    md_file_path = '{symbol}_Technical_Analysis.md'

    # Specify the timeframe for which you want to generate the Markdown file (e.g., '1D', '1W', '1M', etc.)
    timeframe_to_generate = timeframe
    generate_md_file(data, pivot_data, timeframe_to_generate,symbol)
# print(pivot_data.info())
