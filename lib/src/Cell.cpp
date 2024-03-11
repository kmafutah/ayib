#include "Cell.h"
#include <cmath>
#include <algorithm>
#include <vector>
#include <numeric>

Cell::Cell(int num_inputs) :
    weights(num_inputs, 0.0), // Initialize weights (replace 0.0 if needed)
    bias(0.0)  // Initialize bias 
{
    // Initialization (if needed)
}

Cell::~Cell() {
    // Cleanup (if needed)
}

// Setters
void Cell::setWeights(const std::vector<double>& new_weights) {
    weights = new_weights;
}

void Cell::setBias(double new_bias) {
    bias = new_bias;
}

// Output calculation
double Cell::calculateOutput(const std::vector<double>& inputs) {
    if (inputs.size() != weights.size()) {
        // Handle error: input size mismatch
        return 0.0; 
    }

    double sum = 0.0;
    for (int i = 0; i < inputs.size(); ++i) {
        sum += inputs[i] * weights[i];
    }
    sum += bias;

    return sigmoid(sum); 
}

void Cell::processTick(const Tick& tick) {
    static Tick last_tick;  // Static variable to keep track of the last tick
    static bool first_tick = true;  // Flag to indicate the first tick

    if (first_tick) {
        // On the first tick, just store it and return
        last_tick = tick;
        first_tick = false;
        return;
    }

    // Calculate OHLCV data if we have enough ticks
     // Calculate OHLCV data if we have enough ticks
   if (outputData.ohlcv_data.size() >= period) {
       // Calculate OHLCV data based on the collected ticks
       OHLCV ohlcv;
       ohlcv.open = outputData.ohlcv_data.front().open;
       ohlcv.high = (*max_element(outputData.ohlcv_data.begin(), outputData.ohlcv_data.end(), [](const OHLCV& a, const OHLCV& b) { return a.high < b.high; })).high;
       ohlcv.low = (*min_element(outputData.ohlcv_data.begin(), outputData.ohlcv_data.end(), [](const OHLCV& a, const OHLCV& b) { return a.low < b.low; })).low;
    //    ohlcv.high = (*max_element(outputData.ohlcv_data.begin(), outputData.ohlcv_data.end(), [](const OHLCV& a, const OHLCV& b) { return a.high < b.high; })).high;
    //    ohlcv.low = (*min_element(outputData.ohlcv_data.begin(), outputData.ohlcv_data.end(), [](const OHLCV& a, const OHLCV& b) { return a.low < b.low; })).low;
       ohlcv.close = last_tick.bid;  // Close price is the bid price of the last tick
       ohlcv.volume = accumulate(outputData.ohlcv_data.begin(), outputData.ohlcv_data.end(), 0, [](int sum, const OHLCV& bar) { return sum + bar.volume; });

       // Add the calculated OHLCV data to the outputData
       outputData.ohlcv_data.push_back(ohlcv);

       // Remove the oldest tick from the data
       outputData.ohlcv_data.erase(outputData.ohlcv_data.begin());
   }

    // Store the current tick for the next iteration
    last_tick = tick;
}


void Cell::processOHLCV(const OHLCV& ohlcv) {
 // Calculate technical indicators based on the accumulated data
outputData.rsi = calculateRSI(outputData.ohlcv_data, 14 /* Default RSI period */);
outputData.sma = calculateSMA(outputData.ohlcv_data, 20 /* Default SMA period */);
outputData.cci = calculateCCI(outputData.ohlcv_data, 20 /* Default CCI period */);
StochResult tempStock = calculateStoch(outputData.ohlcv_data, 14 /* Default Stoch period */, 3 /* Default K smoothing period */, 3 /* Default D smoothing period */);
MACDResult tempMacd =  calculateMACD(outputData.ohlcv_data, 12 /* Default MACD short period */, 26 /* Default MACD long period */, 9 /* Default MACD signal period */);
outputData.macd_histo = tempMacd.macd_histo;
outputData.macd_main= tempMacd.macd_line;
outputData.macd_signal = tempMacd.macd_signal;
outputData.stoch_main= tempStock.stoch_main;
outputData.stoch_signal = tempStock.stoch_signal;

outputData.ao = calculateAO(outputData.ohlcv_data, 5 /* Default AO short period */, 34 /* Default AO long period */);
outputData.ac = calculateAC(outputData.ohlcv_data, 5 /* Default AC short period */, 34 /* Default AC long period */);
outputData.perfecttrend = calculatePerfectTrend(outputData.ohlcv_data, 5 /* Default Perfect Trend period */);
outputData.supertrend = calculateSuperTrend(outputData.ohlcv_data, 7 /* Default SuperTrend period */, 3.0 /* Default SuperTrend multiplier */);
outputData.halftrend = calculateHalfTrend(outputData.ohlcv_data, 20 /* Default Half Trend period */, 2.0 /* Default Half Trend multiplier */);

}

void Cell::processDataBundle(const DataBundle& bundle) {
    outputData = bundle; // Initialize with input
    
    if (bundle.is_ohlcv) {
        for (const auto& ohlcv : bundle.ohlcv_data) {
            processOHLCV(ohlcv);
        }
    } else {
        for (const auto& tick : bundle.abv_data) {
            processTick(tick);
        }
    }

}

const DataBundle& Cell::getOutputData() const {
    return outputData;
}

// Placeholder implementations - you would replace these with your
// actual calculations of technical indicators
double calculateRSI(const std::vector<OHLCV>& ohlcv_data) {
    // Placeholder logic for RSI calculation
    const int period = 14; // RSI period

    if (ohlcv_data.size() < period + 1) {
        // Not enough data to calculate RSI
        return 0.0;
    }

    std::vector<double> gain;
    std::vector<double> loss;

    // Calculate gains and losses
    for (int i = 1; i < ohlcv_data.size(); ++i) {
        double price_diff = ohlcv_data[i].close - ohlcv_data[i - 1].close;
        if (price_diff >= 0) {
            gain.push_back(price_diff);
            loss.push_back(0.0);
        } else {
            gain.push_back(0.0);
            loss.push_back(-price_diff);
        }
    }

    // Calculate average gain and average loss
    double avg_gain = 0.0;
    double avg_loss = 0.0;
    for (int i = 0; i < period; ++i) {
        avg_gain += gain[i];
        avg_loss += loss[i];
    }
    avg_gain /= period;
    avg_loss /= period;

    // Calculate RS (Relative Strength)
    double rs = (avg_loss == 0) ? 1.0 : (avg_gain / avg_loss);

    // Calculate RSI (Relative Strength Index)
    double rsi = 100.0 - (100.0 / (1.0 + rs));

    return rsi;
}

double calculateATR(const std::vector<OHLCV>& ohlcv_data, int period) {
    if (ohlcv_data.size() < period) {
        // Not enough data to calculate ATR
        return 0.0;
    }

    // Calculate True Range for each period
    std::vector<double> true_ranges;
    for (size_t i = 1; i < ohlcv_data.size(); ++i) {
        double high_low = std::abs(ohlcv_data[i].high - ohlcv_data[i].low);
        double high_close = std::abs(ohlcv_data[i].high - ohlcv_data[i - 1].close);
        double low_close = std::abs(ohlcv_data[i].low - ohlcv_data[i - 1].close);
        double true_range = std::max({high_low, high_close, low_close});
        true_ranges.push_back(true_range);
    }

    // Calculate the ATR using exponential moving average (EMA)
    double atr = 0.0;
    for (int i = 0; i < period; ++i) {
        atr += true_ranges[i];
    }
    atr /= period;

    for (size_t i = period; i < true_ranges.size(); ++i) {
        atr = ((period - 1) * atr + true_ranges[i]) / period;
    }

    return atr;
}

// Helper function to calculate Exponential Moving Average (EMA)
double calculateEMA(const std::vector<OHLCV>& ohlcv_data, int period) {
    // Perform EMA calculation based on the closing prices of the OHLCV data
    double ema = 0.0;
    double multiplier = 2.0 / (period + 1);

    // Calculate SMA for the initial EMA value
    for (int i = 0; i < period; ++i) {
        ema += ohlcv_data[i].close;
    }
    ema /= period;

    // Calculate EMA for subsequent periods
    for (int i = period; i < ohlcv_data.size(); ++i) {
        ema = (ohlcv_data[i].close - ema) * multiplier + ema;
    }

    return ema;
}

// Overloaded helper function to calculate EMA of a given value
double calculateEMA(const std::vector<OHLCV>& ohlcv_data, double value, int period) {
    // Perform EMA calculation based on the given value
    double ema = value;
    double multiplier = 2.0 / (period + 1);

    // Calculate EMA for subsequent periods
    for (int i = period; i < ohlcv_data.size(); ++i) {
        ema = (ohlcv_data[i].close - ema) * multiplier + ema;
    }

    return ema;
}

double calculateSMA(const std::vector<OHLCV>& ohlcv_data, int period) {
    if (ohlcv_data.size() < period) {
        // Not enough data to calculate SMA
        return 0.0;
    }

    // Calculate the sum of closing prices over the specified period
    double sum = 0.0;
    for (int i = ohlcv_data.size() - period; i < ohlcv_data.size(); ++i) {
        sum += ohlcv_data[i].close;
    }

    // Calculate the SMA
    double sma = sum / period;

    return sma;
}

MACDResult calculateMACD(const std::vector<OHLCV>& ohlcv_data, int short_period, int long_period, int signal_period) {
    MACDResult result;
    if (ohlcv_data.size() < long_period) {
        // Not enough data to calculate MACD
        result.macd_line = 0.0;
        result.macd_signal = 0.0;
        result.macd_histo = 0.0;
        return result;
    }

    // Calculate Short-term EMA
    double short_ema = calculateEMA(ohlcv_data, short_period);

    // Calculate Long-term EMA
    double long_ema = calculateEMA(ohlcv_data, long_period);

    // Calculate MACD line
    result.macd_line = short_ema - long_ema;

    // Calculate Signal line (EMA of MACD line)
    result.macd_signal = calculateEMA(ohlcv_data, result.macd_line, signal_period);

    // Calculate MACD Histogram
    result.macd_histo = result.macd_line - result.macd_signal;

    return result;
}

double calculateCCI(const std::vector<OHLCV>& ohlcv_data, int period) {
    if (ohlcv_data.size() < period) {
        // Not enough data to calculate CCI
        return 0.0;
    }

    // Calculate Typical Price (TP) for each period
    std::vector<double> typical_prices;
    for (size_t i = 0; i < ohlcv_data.size(); ++i) {
        double typical_price = (ohlcv_data[i].high + ohlcv_data[i].low + ohlcv_data[i].close) / 3.0;
        typical_prices.push_back(typical_price);
    }

    // Calculate Simple Moving Average (SMA) of Typical Prices over the specified period
    double sum_tp = 0.0;
    for (int i = ohlcv_data.size() - period; i < ohlcv_data.size(); ++i) {
        sum_tp += typical_prices[i];
    }
    double sma_tp = sum_tp / period;

    // Calculate Mean Deviation (MD) for each period
    std::vector<double> deviations;
    for (size_t i = ohlcv_data.size() - period; i < ohlcv_data.size(); ++i) {
        double deviation = std::abs(typical_prices[i] - sma_tp);
        deviations.push_back(deviation);
    }

    // Calculate Mean Deviation (MD) Average over the specified period
    double sum_md = 0.0;
    for (double deviation : deviations) {
        sum_md += deviation;
    }
    double mean_deviation = sum_md / period;

    // Calculate CCI
    double cci = (typical_prices.back() - sma_tp) / (0.015 * mean_deviation);

    return cci;
}

StochResult calculateStoch(const std::vector<OHLCV>& ohlcv_data, int period, int k_smooth, int d_smooth) {
    StochResult result;

    if (ohlcv_data.size() < period) {
        // Not enough data to calculate Stoch
        result.stoch_main = 0.0;
        result.stoch_signal = 0.0;
        return result;
    }

    // Calculate %K values
    std::vector<double> percent_k_values;
    for (size_t i = ohlcv_data.size() - period; i < ohlcv_data.size(); ++i) {
        double highest_high = ohlcv_data[i].high;
        double lowest_low = ohlcv_data[i].low;
        for (size_t j = i - period + 1; j <= i; ++j) {
            highest_high = std::max(highest_high, ohlcv_data[j].high);
            lowest_low = std::min(lowest_low, ohlcv_data[j].low);
        }
        double close = ohlcv_data[i].close;
        double percent_k = ((close - lowest_low) / (highest_high - lowest_low)) * 100.0;
        percent_k_values.push_back(percent_k);
    }

    // Smooth %K values using Simple Moving Average (SMA)
    std::vector<double> smooth_percent_k_values;
    for (size_t i = k_smooth - 1; i < percent_k_values.size(); ++i) {
        double sum = 0.0;
        for (int j = i - k_smooth + 1; j <= i; ++j) {
            sum += percent_k_values[j];
        }
        double smooth_percent_k = sum / k_smooth;
        smooth_percent_k_values.push_back(smooth_percent_k);
    }

    // Calculate %D values using Simple Moving Average (SMA)
    std::vector<double> percent_d_values;
    for (size_t i = d_smooth - 1; i < smooth_percent_k_values.size(); ++i) {
        double sum = 0.0;
        for (int j = i - d_smooth + 1; j <= i; ++j) {
            sum += smooth_percent_k_values[j];
        }
        double percent_d = sum / d_smooth;
        percent_d_values.push_back(percent_d);
    }

    // Set Stoch Main and Stoch Signal in result
    if (percent_d_values.empty()) {
        result.stoch_main = 0.0;
        result.stoch_signal = 0.0;
    } else {
        result.stoch_main = smooth_percent_k_values.back();
        result.stoch_signal = percent_d_values.back();
    }

    return result;
}

double calculateAO(const std::vector<OHLCV>& ohlcv_data, int short_period, int long_period) {
    if (ohlcv_data.size() < long_period) {
        // Not enough data to calculate AO
        return 0.0;
    }

    // Calculate short-term SMA of median prices
    double short_sma = calculateSMA(ohlcv_data, short_period);

    // Calculate long-term SMA of median prices
    double long_sma = calculateSMA(ohlcv_data, long_period);

    // Calculate Awesome Oscillator (AO)
    double ao = short_sma - long_sma;

    return ao;
}

double calculateAC(const std::vector<OHLCV>& ohlcv_data, int short_period, int long_period) {
    if (ohlcv_data.size() < long_period) {
        // Not enough data to calculate AC
        return 0.0;
    }

    // Calculate short-term SMA of median prices
    double short_sma = calculateSMA(ohlcv_data, short_period);

    // Calculate long-term SMA of median prices
    double long_sma = calculateSMA(ohlcv_data, long_period);

    // Calculate Acceleration/Deceleration Oscillator (AC)
    double ac = short_sma - long_sma;

    return ac;
}

double calculatePerfectTrend(const std::vector<OHLCV>& ohlcv_data, int period) {
    if (ohlcv_data.size() < period) {
        // Not enough data to calculate Perfect Trend
        return 0.0;
    }

    // Placeholder logic for calculating Perfect Trend
    // You can implement your own algorithm or conditions here

    // For example, you might calculate the trend based on the difference
    // between the current close price and the close price n periods ago
    double close = ohlcv_data.back().close;
    double close_n_periods_ago = ohlcv_data[ohlcv_data.size() - period].close;
    double perfect_trend = close - close_n_periods_ago;

    return perfect_trend;
}

double calculateSuperTrend(const std::vector<OHLCV>& ohlcv_data, int period, double multiplier) {
    if (ohlcv_data.size() < period) {
        // Not enough data to calculate SuperTrend
        return 0.0;
    }

    std::vector<double> basic_upper_bands;
    std::vector<double> basic_lower_bands;

    // Calculate True Range (TR) for each period
    std::vector<double> true_ranges;
    for (size_t i = 1; i < ohlcv_data.size(); ++i) {
        double high_low = std::abs(ohlcv_data[i].high - ohlcv_data[i].low);
        double high_close = std::abs(ohlcv_data[i].high - ohlcv_data[i - 1].close);
        double low_close = std::abs(ohlcv_data[i].low - ohlcv_data[i - 1].close);
        double true_range = std::max({high_low, high_close, low_close});
        true_ranges.push_back(true_range);
    }

    // Calculate Average True Range (ATR) over the specified period
    double atr = calculateATR(ohlcv_data, period);

    // Calculate Basic Upper Band and Basic Lower Band
    for (size_t i = period; i < ohlcv_data.size(); ++i) {
        double basic_upper_band = (ohlcv_data[i].high + ohlcv_data[i].low) / 2.0 + multiplier * atr;
        double basic_lower_band = (ohlcv_data[i].high + ohlcv_data[i].low) / 2.0 - multiplier * atr;
        basic_upper_bands.push_back(basic_upper_band);
        basic_lower_bands.push_back(basic_lower_band);
    }

    // Calculate SuperTrend based on the Basic Upper Band and Basic Lower Band
    double super_trend = 0.0;
    for (size_t i = 1; i < basic_upper_bands.size(); ++i) {
        if (ohlcv_data[i].close > basic_upper_bands[i - 1]) {
            super_trend = basic_upper_bands[i];
        } else if (ohlcv_data[i].close < basic_lower_bands[i - 1]) {
            super_trend = basic_lower_bands[i];
        } else {
            super_trend = super_trend;
        }
    }

    return super_trend;
}

double calculateHalfTrend(const std::vector<OHLCV>& ohlcv_data, int period, double multiplier) {
    if (ohlcv_data.size() < period) {
        // Not enough data to calculate Half Trend
        return 0.0;
    }

    std::vector<double> highs;
    std::vector<double> lows;
    std::vector<double> closes;

    // Extract High, Low, and Close prices from OHLCV data
    for (const OHLCV& data : ohlcv_data) {
        highs.push_back(data.high);
        lows.push_back(data.low);
        closes.push_back(data.close);
    }

    std::vector<double> atr_values;

    // Calculate True Range (TR) for each period
    for (size_t i = 1; i < ohlcv_data.size(); ++i) {
        double high_low = std::abs(highs[i] - lows[i]);
        double high_close = std::abs(highs[i] - closes[i - 1]);
        double low_close = std::abs(lows[i] - closes[i - 1]);
        double true_range = std::max({high_low, high_close, low_close});
        atr_values.push_back(true_range);
    }

    // Calculate Average True Range (ATR) over the specified period
    double atr = calculateATR(ohlcv_data, period);

    std::vector<double> trend_values;

    // Calculate Half Trend values
    for (size_t i = 0; i < ohlcv_data.size(); ++i) {
        double upper_band = ohlcv_data[i].high - multiplier * atr;
        double lower_band = ohlcv_data[i].low + multiplier * atr;
        double trend_value = 0.0;
        if (ohlcv_data[i].close > upper_band) {
            trend_value = 1.0; // Bullish trend
        } else if (ohlcv_data[i].close < lower_band) {
            trend_value = -1.0; // Bearish trend
        }
        trend_values.push_back(trend_value);
    }

    // Find the most recent trend value
    double half_trend = trend_values.back();

    return half_trend;
}


// Implement activation functions
float Cell::sigmoid(float x) {
    return 1.0 / (1.0 + exp(-x)); 
}

float Cell::relu(float x) {
    return std::max(0.0f, x);
}

float Cell::tanh(float x) {
    return (exp(x) - exp(-x)) / (exp(x) + exp(-x));
}
