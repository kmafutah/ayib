import yfinance as yf
import pandas as pd
import matplotlib.pyplot as plt
import mplfinance as mpf
import os
from talib import RSI, STOCH, CCI, ADX, MOM, MACD, STOCHRSI, WILLR, PPO, ULTOSC, MINUS_DI,PLUS_DI
global buy_counter
global neutral_counter
global sell_counter

def generate_md_file(data, pivot_data, timeframe,symbol):
    buy_counter = 0
    neutral_counter = 0
    sell_counter = 0
    md_file_path = f'data/{symbol}_Technical_Analysis_{timeframe}.md'
    with open(md_file_path, 'w') as md_file:
        md_file.write(f"# {symbol} Technical Analysis\n\n")
        md_file.write(f"**Timeframe:** {timeframe}\n\n")
        
        
        # Oscillators section
        md_file.write("## Oscillators\n\n")
        md_file.write(f"| Indicator Name                   | {timeframe}            |\n")
        md_file.write("|----------------------------------|------------------|\n")
        # print( determine_signal('RSI',data) )
        # Populate oscillators data (assuming data is provided)
        oscillators_data = {
            "Relative Strength Index (14)": str(data['RSI'].iloc[-1]) + '(' + determine_signal('RSI', data,sell_counter,buy_counter,neutral_counter) + ')',
            "Stochastic %K (14, 3, 3)": str(data['%K'].iloc[-1]) + '(' + determine_signal('%K', data,sell_counter,buy_counter,neutral_counter) + ')',
            "Commodity Channel Index (20)": str(data['CCI'].iloc[-1]) + '(' + determine_signal('CCI', data,sell_counter,buy_counter,neutral_counter) + ')',
            "Average Directional Index (14)": str(data['ADX'].iloc[-1]) + '(' + determine_signal('ADX', data,sell_counter,buy_counter,neutral_counter) + ')',
            "Awesome Oscillator": str(data['AO'].iloc[-1]) + '(' + determine_signal('AO', data,sell_counter,buy_counter,neutral_counter) + ')',
            "Momentum (10)": str(data['MOM'].iloc[-1]) + '(' + determine_signal('MOM', data,sell_counter,buy_counter,neutral_counter) + ')',
            "MACD Level (12, 26)": str(data['MACD'].iloc[-1]) + '(' + determine_signal('MACD', data,sell_counter,buy_counter,neutral_counter) + ')',
            "Stochastic RSI Fast (3, 3, 14, 14)": str(data['%K_RSI'].iloc[-1]) + '(' + determine_signal('%K_RSI', data,sell_counter,buy_counter,neutral_counter) + ')',
            "Williams Percent Range (14)": str(data['WILLR'].iloc[-1]) + '(' + determine_signal('WILLR', data,sell_counter,buy_counter,neutral_counter) + ')',
            "Bull Bear Power": str(data['BullBearPower'].iloc[-1]) + '(' + determine_signal('BullBearPower', data,sell_counter,buy_counter,neutral_counter) + ')',
            "Ultimate Oscillator (7, 14, 28)": str(data['UltimateOsc'].iloc[-1]) + '(' + determine_signal('UltimateOsc', data,sell_counter,buy_counter,neutral_counter) + ')',
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
            "Exponential Moving Average 9": str(data['EMA9'].iloc[-1]) + '(' + determine_signal_ma('EMA9', data['EMA9'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Exponential Moving Average 10": str(data['EMA10'].iloc[-1]) + '(' + determine_signal_ma('EMA10', data['EMA10'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Simple Moving Average 10": str(data['SMA10'].iloc[-1]) + '(' + determine_signal_ma('SMA10', data['SMA10'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Exponential Moving Average 20": str(data['EMA20'].iloc[-1]) + '(' + determine_signal_ma('EMA20', data['EMA20'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Exponential Moving Average 26": str(data['EMA26'].iloc[-1]) + '(' + determine_signal_ma('EMA26', data['EMA26'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Simple Moving Average 20": str(data['SMA20'].iloc[-1]) + '(' + determine_signal_ma('SMA20', data['SMA20'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Exponential Moving Average 30": str(data['EMA30'].iloc[-1]) + '(' + determine_signal_ma('EMA30', data['EMA30'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Simple Moving Average 30": str(data['SMA30'].iloc[-1]) + '(' + determine_signal_ma('SMA30', data['SMA30'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Exponential Moving Average 50": str(data['EMA50'].iloc[-1]) + '(' + determine_signal_ma('EMA50', data['EMA50'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Simple Moving Average 50": str(data['SMA50'].iloc[-1]) + '(' + determine_signal_ma('SMA50', data['SMA50'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Exponential Moving Average 100": str(data['EMA100'].iloc[-1]) + '(' + determine_signal_ma('EMA100', data['EMA100'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Simple Moving Average 100": str(data['SMA100'].iloc[-1]) + '(' + determine_signal_ma('SMA100', data['SMA100'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Exponential Moving Average 200": str(data['EMA200'].iloc[-1]) + '(' + determine_signal_ma('EMA200', data['EMA200'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Simple Moving Average 200": str(data['SMA200'].iloc[-1]) + '(' + determine_signal_ma('SMA200', data['SMA200'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Ichimoku Cloud": str(data['Ichimoku'].iloc[-1]) + '(' + determine_signal_ma('Ichimoku Cloud', data['Ichimoku'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Volume Weighted Moving Average 20": str(data['VWMA20'].iloc[-1]) + '(' + determine_signal_ma('Volume Weighted Moving Average 20', data['VWMA20'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
            "Hull Moving Average 9": str(data['HullMA9'].iloc[-1]) + '(' + determine_signal_ma('Hull Moving Average 9', data['HullMA9'].iloc[-1], data['Close'].iloc[-1],sell_counter,buy_counter,neutral_counter) + ')',
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

        # Summary section
        md_file.write("## Summary\n\n")
        md_file.write(f"* **Overall:** Buy Count: {buy_counter}, Neutral Count: {neutral_counter}, Sell Count: {sell_counter}\n\n")

def calculate_ao(high, low, fast_period=5, slow_period=34):
    median_price = (high + low) / 2
    fast_sma = median_price.rolling(window=fast_period).mean()
    slow_sma = median_price.rolling(window=slow_period).mean()
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

def determine_signal_ma(indicator_name, ma_value, close_price,sell_counter,buy_counter,neutral_counter):
    if indicator_name in ['Ichimoku Cloud', 'Volume Weighted Moving Average 20', 'Hull Moving Average 9']:
        if close_price > ma_value:
            buy_counter += 1
            return 'Buy'
        elif close_price < ma_value:
            sell_counter += 1
            return 'Sell'
        else:
            neutral_counter += 1
            return 'Neutral'
    else:
        if close_price > ma_value:
            buy_counter += 1
            return 'Buy'
        elif close_price < ma_value:
            sell_counter += 1
            return 'Sell'
        else:
            neutral_counter += 1
            return 'Neutral'


def determine_signal(indicator, data,sell_counter,buy_counter,neutral_counter):
    signal = ''    
    if indicator == 'RSI':
        rsi = data['RSI'].iloc[-1]
        if rsi > 70:
            sell_counter += 1
            signal = 'Sell'
        elif rsi < 30:
            buy_counter += 1
            signal = 'Buy'
        else:
            neutral_counter += 1
            signal = 'Neutral'

    elif indicator == '%K':
        k = data['%K'].iloc[-1]
        d = data['%D'].iloc[-1]
        if k > d and k > 80:
            sell_counter += 1
            signal = 'Sell'
        elif k < d and k < 20:
            buy_counter += 1
            signal = 'Buy'
        else:
            neutral_counter += 1
            signal = 'Neutral'
    elif indicator == 'CCI':
        cci = data['CCI'].iloc[-1]
        if cci > 100:
            sell_counter += 1
            signal = 'Sell'
        elif cci < -100:
            buy_counter += 1
            signal = 'Buy'
        else:
            neutral_counter += 1
            signal = 'Neutral'

    elif indicator == 'ADX':
        adx = data['ADX'].iloc[-1]
        plus_di = data['PLUS_DI'].iloc[-1]
        minus_di = data['MINUS_DI'].iloc[-1]
        
        if adx > 25 and plus_di > minus_di:
            buy_counter += 1
            signal = 'Buy'  # Strong trend with +DI crossing above -DI
        elif adx > 25 and plus_di < minus_di:
            sell_counter += 1
            signal = 'Sell'  # Strong trend with -DI crossing above +DI
        else:
            neutral_counter += 1
            signal = 'Neutral'

    elif indicator == 'AO':
        ao = data['AO'].iloc[-1]
        if ao > 0:
            buy_counter += 1
            signal = 'Buy'
        elif ao < 0:
            sell_counter += 1
            signal = 'Sell'
        else:
            neutral_counter += 1
            signal = 'Neutral'
    elif indicator == 'MOM':
        mom = data['MOM'].iloc[-1]
        if mom > 0:
            buy_counter += 1
            signal = 'Buy'
        elif mom < 0:
            sell_counter += 1
            signal = 'Sell'
        else:
            neutral_counter += 1
            signal = 'Neutral'
    elif indicator == 'MACD':
        macd = data['MACD'].iloc[-1]
        if macd > 0:
            buy_counter += 1
            signal = 'Buy'
        elif macd < 0:
            sell_counter += 1
            signal = 'Sell'
        else:
            neutral_counter += 1
            signal = 'Neutral'
    elif indicator == '%K_RSI':
        k_rsi = data['%K_RSI'].iloc[-1]
        d_rsi = data['%D_RSI'].iloc[-1]
        if k_rsi > d_rsi and k_rsi > 80:
            sell_counter += 1
            signal = 'Sell'
        elif k_rsi < d_rsi and k_rsi < 20:
            buy_counter += 1
            signal = 'Buy'
        else:
            neutral_counter += 1
            signal = 'Neutral'
    elif indicator == 'WILLR':
        willr = data['WILLR'].iloc[-1]
        if willr > -20:
            sell_counter += 1
            signal = 'Sell'
        elif willr < -80:
            buy_counter += 1
            signal = 'Buy'
        else:
            neutral_counter += 1
            signal = 'Neutral'
    elif indicator == 'BullBearPower':
        bbp = data['BullBearPower'].iloc[-1]
        if bbp > 0:
            buy_counter += 1
            signal = 'Buy'
        elif bbp < 0:
            sell_counter += 1
            signal = 'Sell'
        else:
            neutral_counter += 1
            signal = 'Neutral'
    elif indicator == 'UltimateOsc':
        uo = data['UltimateOsc'].iloc[-1]
        if uo > 70:
            sell_counter += 1
            signal = 'Sell'
        elif uo < 30:
            buy_counter += 1
            signal = 'Buy'
        else:
            neutral_counter += 1
            signal = 'Neutral'
    
    return signal


def main():
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
        data['MINUS_DI'] = MINUS_DI(data['High'], data['Low'], data['Close'], timeperiod=14) 
        data['PLUS_DI'] = PLUS_DI(data['High'], data['Low'], data['Close'], timeperiod=14) 
        data['AO'] = calculate_ao(data['High'], data['Low'])
        data['MOM'] = MOM(data['Close'], timeperiod=10)
        data['MACD'], data['MACD_Signal'], data['MACD_Hist'] = MACD(data['Close'], fastperiod=12, slowperiod=26, signalperiod=9)
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
        # print(data.columns)
        # # Calculate pivot points
        pivot_data = calculate_pivots(data['High'], data['Low'], data['Close'], data.index)    

        # Generate Markdown file
        generate_md_file(data, pivot_data, timeframe, symbol)

        # Plot charts
        # plot_charts(data)

def plot_charts(data):
    # Create a figure and axes for subplots
    fig, axes = plt.subplots(2, 1, figsize=(12, 8))

    # Plot Candlestick Chart
    mpf.plot(data, ax=axes[0], type='candle', volume=False, style='yahoo')
    axes[0].set_title('Candlestick Chart')

    # Plot Point and Figure Chart
    mpf.plot(data, ax=axes[1], type='pnf', volume=False, style='yahoo')
    axes[1].set_title('Point and Figure Chart')

    # Adjust spacing between subplots
    plt.tight_layout()

    # Show the plot
    plt.show()

if __name__ == "__main__":
    main()
