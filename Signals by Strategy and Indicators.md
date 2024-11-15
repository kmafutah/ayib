{
  "BreakoutTradingStrategy": {
    "entry_signal": "Price closes above resistance on high volume (SMA and OBV confirm uptrend)",
    "hold_signal": "Price stays above breakout level with momentum (ATR remains stable or expands)",
    "exit_signal": "Price falls below breakout level or Stochastic reaches overbought"
  },
  "DiversificationStrategy": {
    "entry_signal": "Allocate across sectors with stocks near support levels (PivotPoints and FibonacciRetracement indicate support)",
    "hold_signal": "Hold until rebalancing schedule or significant changes in sector indicators",
    "exit_signal": "Sector allocation exceeds target balance or indicators suggest re-evaluation"
  },
  "DollarCostAveragingStrategy": {
    "entry_signal": "Scheduled buy as per fixed amount (EMA and TSI show long-term growth potential)",
    "hold_signal": "Hold as long as EMA remains above a long-term threshold (e.g., 200-day EMA)",
    "exit_signal": "No specific exit—review only in case of long-term fundamental changes"
  },
  "FundamentalAnalysisStrategy": {
    "entry_signal": "Price reaches undervalued levels based on fundamentals (PPO or ADL suggests stability)",
    "hold_signal": "Price remains aligned with target valuation (Ichimoku cloud indicates support)",
    "exit_signal": "Change in fundamental value or price moves to overvaluation based on target price"
  },
  "MomentumInvestingStrategy": {
    "entry_signal": "ROC and RSI both indicate strong upward momentum",
    "hold_signal": "Momentum persists with TSI remaining above a certain level",
    "exit_signal": "TSI or RSI indicate waning momentum (RSI crosses below 70 or TSI reverses)"
  },
  "MovingAverageCrossoverStrategy": {
    "entry_signal": "Golden cross occurs (50-day SMA crosses above 200-day SMA) and ROC confirms",
    "hold_signal": "Price remains above the 200-day SMA and ATR expands",
    "exit_signal": "Death cross or price falls below recent swing low"
  },
  "RSIStrategy": {
    "entry_signal": "RSI crosses below 30 (indicating oversold) and price is near support (LatestPivots)",
    "hold_signal": "RSI moves towards 50, indicating recovery without overbought conditions",
    "exit_signal": "RSI reaches overbought level (above 70) or fails to break resistance"
  },
  "ScalpingStrategy": {
    "entry_signal": "Price breaks above recent high with support from volume (VWAP and tight spread)",
    "hold_signal": "Price continues moving in trade direction without retracement beyond VWAP",
    "exit_signal": "Price retracts to VWAP or small profit target reached"
  },
  "TrendFollowingStrategy": {
    "entry_signal": "Ichimoku confirms trend alignment and TSI indicates positive momentum",
    "hold_signal": "Price stays above Ichimoku cloud with trend intact (ChandelierExit distance confirms trend strength)",
    "exit_signal": "Price closes below Ichimoku cloud or trend reverses as indicated by GannLines"
  },
  "ValueInvestingStrategy": {
    "entry_signal": "Price is below intrinsic value and above major support (confirmed by FibonacciRetracement and PPO)",
    "hold_signal": "Price remains near intrinsic value or continues trending upward",
    "exit_signal": "Price reaches target valuation or CCI indicates overbought condition"
  }
}
