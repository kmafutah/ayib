# CMake vcpkg project example

An example on how to setup a CMake project with vcpkg and its [manifest](https://vcpkg.readthedocs.io/en/latest/specifications/manifests/) (`vcpkg.json`) experimental feature

## Getting Started
Clone the repo with the `--recurse-submodules` flag
```bash
git clone --recurse-submodules https://github.com/miredirex/cmake-vcpkg-example.git
```  

Run `./vcpkg/bootstrap-vcpkg.sh` or `.\vcpkg\bootstrap-vcpkg.bat`

Fetch the dependencies (see [vcpkg.json](vcpkg.json)):  
(_This is optional, CMake should run `vcpkg install` anyway_)
```bash
./vcpkg/vcpkg --feature-flags=manifests install
```

Build the project using your IDE/build tool of choice or manually:

```bash
cmake -B build -S .
```
```bash
cmake --build build
```

## For CLion users
To avoid long file indexing, you might want to exclude the `vcpkg` directory:
1. Right click on `vcpkg` in the Project window
2. Mark Directory as -> _Library Files_ or _Excluded_ (I recommend choosing the latter)

## Troubleshooting

If you're getting
```
Could not find a package configuration file provided by "fmt" with any of
  the following names:
 
  ...
```
or similar, try deleting cmake's build directory and rebuilding the project
# ayib

------------------------------------------------------------------------------------------------------------------

# BTCUSD Technical Analysis

**Timeframes:** 1m, 5m, 15m, 30m, 1H, 2H, 4H, 1D, 1W, 1M

## Summary

* **Overall:** Neutral

## Oscillators

| Indicator Name                   | 1m | 5m | 15m | 30m | 1H | 2H | 4H | 1D | 1W | 1M |
|----------------------------------|----|----|-----|-----|----|----|----|----|----|----|
| Relative Strength Index (14)     | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Stochastic %K (14, 3, 3)         | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Commodity Channel Index (20)     | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Average Directional Index (14)   | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Awesome Oscillator               | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Momentum (10)                    | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| MACD Level (12, 26)              | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Stochastic RSI Fast (3, 3, 14, 14)| -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Williams Percent Range (14)      | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Bull Bear Power                  | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Ultimate Oscillator (7, 14, 28)  | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |

## Moving Averages

| Indicator Name                          | 1m | 5m | 15m | 30m | 1H | 2H | 4H | 1D | 1W | 1M |
|-----------------------------------------|----|----|-----|-----|----|----|----|----|----|----|
| Exponential Moving Average (10)          | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Simple Moving Average (10)              | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Exponential Moving Average (20)          | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Simple Moving Average (20)              | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Exponential Moving Average (30)          | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Simple Moving Average (30)              | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Exponential Moving Average (50)          | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Simple Moving Average (50)              | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Exponential Moving Average (100)         | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Simple Moving Average (100)             | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Exponential Moving Average (200)         | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Simple Moving Average (200)             | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Ichimoku Base Line (9, 26, 52, 26)       | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Volume Weighted Moving Average (20)      | X  | X  | X   | X   | X  | X  | X  | X  | X  | X  |
| Hull Moving Average (9)                  | O  | O  | O   | O   | O  | O  | O  | O  | O  | O  |


## Pivots

#### Classic
| Pivot         | 1m | 5m | 15m | 30m | 1H | 2H | 4H | 1D | 1W | 1M |
|---------------|----|----|-----|-----|----|----|----|----|----|----|
| S3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Pivot (P)     | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |

#### Fibonacci
| Pivot         | 1m | 5m | 15m | 30m | 1H | 2H | 4H | 1D | 1W | 1M |
|---------------|----|----|-----|-----|----|----|----|----|----|----|
| S3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Pivot (P)     | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |

#### Camarilla
| Pivot         | 1m | 5m | 15m | 30m | 1H | 2H | 4H | 1D | 1W | 1M |
|---------------|----|----|-----|-----|----|----|----|----|----|----|
| S3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Pivot (P)     | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |

#### Woodie
| Pivot         | 1m | 5m | 15m | 30m | 1H | 2H | 4H | 1D | 1W | 1M |
|---------------|----|----|-----|-----|----|----|----|----|----|----|
| S3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Pivot (P)     | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
#### DM
| Pivot         | 1m | 5m | 15m | 30m | 1H | 2H | 4H | 1D | 1W | 1M |
|---------------|----|----|-----|-----|----|----|----|----|----|----|
| S3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| S1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| Pivot (P)     | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R1            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R2            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |
| R3            | -  | -  | -   | -   | -  | -  | -  | -  | -  | -  |


---- OUTPUT ----
```
{
  "BreakoutTradingStrategy": {
    "signal": "buy",  
    "volume": "calculate_based_on_risk_tolerance", 
    "stop_loss": "below_breakout_level", 
    "take_profit": "multiple_of_breakout_level" 
  },
  "DiversificationStrategy": {
    "signal": "allocate_across_sectors", 
    "volume": "proportional_to_portfolio_size", 
    "stop_loss": "not_directly_applicable",
    "take_profit": "based_on_rebalancing_schedule" 
  },
  "DollarCostAveragingStrategy": {
    "signal": "buy", 
    "volume": "fixed_investment_amount", 
    "stop_loss": "not_directly_applicable",
    "take_profit": "long_term_hold" 
  },
  "FundamentalAnalysisStrategy": {
    "signal": "buy_or_sell_based_on_valuation",
    "volume": "calculate_based_on_risk_tolerance", 
    "stop_loss": "below_support_or_change_in_fundamentals",  
    "take_profit": "target_price_based_on_valuation" 
  },
  "MomentumInvestingStrategy": { 
    "signal": "buy",
    "volume": "calculate_based_on_risk_tolerance",
    "stop_loss": "trailing_stop_below_recent_lows", 
    "take_profit": "when_momentum_fades" 
  },
  "MovingAverageCrossoverStrategy": {
    "signal": "buy_on_golden_cross_sell_on_death_cross",
    "volume": "calculate_based_on_risk_tolerance",
    "stop_loss": "below_recent_swing_low", 
    "take_profit": "multiple_of_average_true_range" 
  },
  "RSIStrategy": {
    "signal": "buy_oversold_sell_overbought",
    "volume": "calculate_based_on_risk_tolerance",
    "stop_loss": "below_recent_swing_low", 
    "take_profit": "trailing_profit_as_RSI_moves_favorably"
  }, 
  "ScalpingStrategy": { 
    "signal": "frequent_buy_and_sell_based_on_small_moves",
    "volume": "dependent_on_liquidity_and_bid_ask_spread",
    "stop_loss": "tight_stops_to_limit_risk", 
    "take_profit": "small_profit_targets" 
  },
  "TrendFollowingStrategy": { 
    "signal": "follow_trend_direction",
    "volume": "calculate_based_on_risk_tolerance",
    "stop_loss": "trailing_stop_based_on_trend_indicators", 
    "take_profit": "when_trend_reverses"
  },
  "ValueInvestingStrategy": {
    "signal": "buy_undervalued_stocks",
    "volume": "calculate_based_on_risk_tolerance", 
    "stop_loss": "below_support_or_change_in_fundamentals", 
    "take_profit": "target_price_based_on_intrinsic_value"
  }
}
```

------------------------------------------------------------------------------------------------------------------

# BTCUSD Technical Analysis

---- INPUT ----

**Timeframes:** (Your specified timeframes)

## Summary

* **Overall:** Neutral

## Oscillators

| Indicator Name                   | Your Timeframes |
|----------------------------------|-----------------|
| Relative Strength Index (14)     | 57 (Neutral)    |
| Stochastic %K (14, 3, 3)         | 69 (Neutral)    |
| Commodity Channel Index (20)     | 55 (Neutral)    |
| Average Directional Index (14)   | 30 (Neutral)    |
| Awesome Oscillator               | 3372 (Neutral)  |
| Momentum (10)                    | 903 (Sell)      |
| MACD Level (12, 26)              | 2025 (Sell)     |
| Stochastic RSI Fast (3, 3, 14, 14)| 40 (Neutral)   |
| Williams Percent Range (14)      | -35 (Neutral)   |
| Bull Bear Power                  | 5152 (Neutral)  |
| Ultimate Oscillator (7, 14, 28)  | 49 (Neutral)    |

## Moving Averages

| Indicator Name                          | Your Timeframes |
|-----------------------------------------|-----------------|
| Exponential Moving Average (10)          | 67754 (Buy)     |
| Simple Moving Average (10)              | 66703 (Buy)     |
| Exponential Moving Average (20)          | 66610 (Buy)     |
| Simple Moving Average (20)              | 68200 (Buy)     |
| Exponential Moving Average (30)          | 64792 (Buy)     |
| Simple Moving Average (30)              | 66586 (Buy)     |
| Exponential Moving Average (50)          | 61004 (Buy)     |
| Simple Moving Average (50)              | 60112 (Buy)     |
| Exponential Moving Average (100)         | 54056 (Buy)     |
| Simple Moving Average (100)             | 51529 (Buy)     |
| Exponential Moving Average (200)         | 46109 (Buy)     |
| Simple Moving Average (200)             | 42446 (Buy)     |
| Ichimoku Base Line (9, 26, 52, 26)       | 66554 (Neutral)|
| Volume Weighted Moving Average (20)      | 68462 (Buy)     |
| Hull Moving Average (9)                  | 70450 (Sell)    |

## Pivots

| Pivot         | Classic | Fibonacci | Camarilla | Woodie | DM      |
|---------------|---------|-----------|-----------|--------|---------|
| S3            | 11391   | 33532     | 55072     | 27950  | —       |
| S2            | 33532   | 41990     | 57102     | 34904  | —       |
| S1            | 47347   | 47215     | 59131     | 50091  | 51510   |
| Pivot (P)     | 55673   | 55673     | 55673     | 57045  | 57755   |
| R1            | 69488   | 64131     | 63191     | 72232  | 73651   |
| R2            | 77814   | 69356     | 65220     | 79186  | —       |
| R3            | 99955   | 77814     | 67250     | 94373  | —       |

---- OUTPUT ----
```
{
  "symbol": "NQ=F",
  "timestamp": "2024-03-27T09:45:00-04:00",
  "signal": "buy",
  "strategy": "RSI",
  "indicators": {
    "RSI_20": 59.4898664521678 
  },
  "price_data": {
    "open": 18480.0,
    "high": 18480.0,
    "low": 18470.5,
    "close": 18473.25,
    "volume": 2246
  },
  "targets": {
    "entry": 18475.0, // Example entry suggestion
    "take_profit": 18600.0,
    "stop_loss": 18400.0
  },
  "confidence": 0.65 
}
```
