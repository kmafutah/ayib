import json
import random
import datetime
from typing import Dict, List, Any

class TradingPersonaTrainingDataGenerator:
    def __init__(self):
        self.personas = {
            "The Savvy Zebra Stockbroker": {
                "primary_instrument": "STOCK",
                "secondary_instruments": ["INDICES", "OPTIONS"],
                "strategy": "TrendFollowingStrategy",
                "description": "Focuses on stocks with trend-following approach"
            },
            "The Elephant Economist": {
                "primary_instrument": "BONDS",
                "secondary_instruments": ["FUNDS", "FOREX"],
                "strategy": "DollarCostAveragingStrategy",
                "description": "Conservative bond-focused investor"
            },
            "The Meerkat Venture Capitalist": {
                "primary_instrument": "FUNDS",
                "secondary_instruments": ["STRUCTURED_PRODUCTS", "ETPS"],
                "strategy": "DiversificationStrategy",
                "description": "Diversified fund investor"
            },
            "The Cheetah Day Trader": {
                "primary_instrument": "FOREX",
                "secondary_instruments": ["CFDS", "DERIVATIVES"],
                "strategy": "ScalpingStrategy",
                "description": "Fast-paced forex scalper"
            },
            "The Lion Hedge Fund Manager": {
                "primary_instrument": "FUNDS",
                "secondary_instruments": ["OPTIONS", "DERIVATIVES"],
                "strategy": "ValueInvestingStrategy",
                "description": "Sophisticated value investor"
            },
            "The Rhino Real Estate Mogul": {
                "primary_instrument": "REITS",
                "secondary_instruments": ["BONDS", "STRUCTURED_PRODUCTS"],
                "strategy": "FundamentalAnalysisStrategy",
                "description": "Real estate focused investor"
            },
            "The Pangolin Cryptocurrency Enthusiast": {
                "primary_instrument": "CRYPTO",
                "secondary_instruments": ["CFDS", "DERIVATIVES"],
                "strategy": "RSIStrategy",
                "description": "Crypto momentum trader"
            }
        }
        
        self.timeframes = ["1m", "5m", "15m", "30m", "1H", "2H", "4H", "1D", "1W", "1M"]
        self.indicators = [
            "Relative Strength Index (14)", "Stochastic %K (14, 3, 3)", 
            "Commodity Channel Index (20)", "Average Directional Index (14)",
            "Awesome Oscillator", "Momentum (10)", "MACD Level (12, 26)",
            "Stochastic RSI Fast (3, 3, 14, 14)", "Williams Percent Range (14)",
            "Bull Bear Power", "Ultimate Oscillator (7, 14, 28)"
        ]
        
        self.moving_averages = [
            "Exponential Moving Average (10)", "Simple Moving Average (10)",
            "Exponential Moving Average (20)", "Simple Moving Average (20)",
            "Exponential Moving Average (30)", "Simple Moving Average (30)",
            "Exponential Moving Average (50)", "Simple Moving Average (50)",
            "Exponential Moving Average (100)", "Simple Moving Average (100)",
            "Exponential Moving Average (200)", "Simple Moving Average (200)",
            "Ichimoku Base Line (9, 26, 52, 26)", "Volume Weighted Moving Average (20)",
            "Hull Moving Average (9)"
        ]
        
        self.pivot_types = ["Classic", "Fibonacci", "Camarilla", "Woodie", "DM"]
        self.pivot_levels = ["S3", "S2", "S1", "Pivot (P)", "R1", "R2", "R3"]
        
        self.strategies = {
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

    def generate_multi_timeframe_analysis(self, symbol: str, persona: str) -> str:
        """Generate multi-timeframe technical analysis input"""
        analysis = f"# {symbol} Technical Analysis\n\n"
        analysis += f"**Timeframes:** {', '.join(self.timeframes)}\n\n"
        
        # Summary
        overall_sentiment = random.choice(["Buy", "Sell", "Neutral"])
        analysis += "## Summary\n\n"
        analysis += f"* **Overall:** {overall_sentiment}\n\n"
        
        # Oscillators
        analysis += "## Oscillators\n\n"
        analysis += "| Indicator Name                   | " + " | ".join(self.timeframes) + " |\n"
        analysis += "|----------------------------------|" + "|".join(["----" for _ in self.timeframes]) + "|\n"
        
        for indicator in self.indicators:
            signals = []
            for _ in self.timeframes:
                signal = random.choice(["Buy", "Sell", "Neutral"])
                value = random.uniform(0, 100)
                signals.append(f"{value:.1f} ({signal})")
            analysis += f"| {indicator:<32} | " + " | ".join(signals) + " |\n"
        
        analysis += "\n## Moving Averages\n\n"
        analysis += "| Indicator Name                          | " + " | ".join(self.timeframes) + " |\n"
        analysis += "|-----------------------------------------|" + "|".join(["----" for _ in self.timeframes]) + "|\n"
        
        for ma in self.moving_averages:
            signals = []
            for _ in self.timeframes:
                signal = random.choice(["Buy", "Sell", "Neutral"])
                value = random.uniform(10000, 100000)
                signals.append(f"{value:.0f} ({signal})")
            analysis += f"| {ma:<41} | " + " | ".join(signals) + " |\n"
        
        # Pivots
        for pivot_type in self.pivot_types:
            analysis += f"\n#### {pivot_type}\n"
            analysis += "| Pivot         | " + " | ".join(self.timeframes) + " |\n"
            analysis += "|---------------|" + "|".join(["----" for _ in self.timeframes]) + "|\n"
            
            for level in self.pivot_levels:
                values = []
                for _ in self.timeframes:
                    value = random.uniform(10000, 100000)
                    values.append(f"{value:.0f}")
                analysis += f"| {level:<14} | " + " | ".join(values) + " |\n"
        
        return analysis

    def generate_single_timeframe_analysis(self, symbol: str, timeframe: str) -> str:
        """Generate single timeframe technical analysis input"""
        analysis = f"# {symbol} Technical Analysis\n\n"
        analysis += f"---- INPUT ----\n\n"
        analysis += f"**Timeframes:** {timeframe}\n\n"
        
        # Summary
        overall_sentiment = random.choice(["Buy", "Sell", "Neutral"])
        analysis += "## Summary\n\n"
        analysis += f"* **Overall:** {overall_sentiment}\n\n"
        
        # Oscillators
        analysis += "## Oscillators\n\n"
        analysis += f"| Indicator Name                   | {timeframe} |\n"
        analysis += "|----------------------------------|-------------|\n"
        
        for indicator in self.indicators:
            signal = random.choice(["Buy", "Sell", "Neutral"])
            value = random.uniform(0, 100)
            analysis += f"| {indicator:<32} | {value:.1f} ({signal}) |\n"
        
        analysis += "\n## Moving Averages\n\n"
        analysis += f"| Indicator Name                          | {timeframe} |\n"
        analysis += "|-----------------------------------------|-------------|\n"
        
        for ma in self.moving_averages:
            signal = random.choice(["Buy", "Sell", "Neutral"])
            value = random.uniform(10000, 100000)
            analysis += f"| {ma:<41} | {value:.0f} ({signal}) |\n"
        
        # Pivots
        analysis += "\n## Pivots\n\n"
        analysis += "| Pivot         | Classic | Fibonacci | Camarilla | Woodie | DM      |\n"
        analysis += "|---------------|---------|-----------|-----------|--------|---------|\n"
        
        for level in self.pivot_levels:
            values = []
            for _ in range(5):
                value = random.uniform(10000, 100000)
                values.append(f"{value:.0f}")
            analysis += f"| {level:<14} | " + " | ".join(values) + " |\n"
        
        analysis += "\n---- OUTPUT ----\n"
        return analysis

    def generate_strategy_recommendations_output(self) -> str:
        """Generate strategy recommendations output for multi-timeframe analysis"""
        return json.dumps(self.strategies, indent=2)

    def generate_specific_signal_output(self, symbol: str, persona: str) -> str:
        """Generate specific trading signal output for single timeframe analysis"""
        persona_data = self.personas[persona]
        strategy = persona_data["strategy"]
        
        # Generate realistic price data
        base_price = random.uniform(100, 50000)
        open_price = base_price
        high_price = base_price * random.uniform(1.001, 1.05)
        low_price = base_price * random.uniform(0.95, 0.999)
        close_price = random.uniform(low_price, high_price)
        volume = random.randint(1000, 100000)
        
        # Calculate targets based on strategy
        if strategy == "TrendFollowingStrategy":
            signal = random.choice(["buy", "sell"])
            entry = close_price
            if signal == "buy":
                take_profit = close_price * random.uniform(1.02, 1.08)
                stop_loss = close_price * random.uniform(0.92, 0.98)
            else:
                take_profit = close_price * random.uniform(0.92, 0.98)
                stop_loss = close_price * random.uniform(1.02, 1.08)
        elif strategy == "RSIStrategy":
            signal = "buy" if random.random() > 0.5 else "sell"
            entry = close_price
            take_profit = close_price * random.uniform(1.01, 1.05)
            stop_loss = close_price * random.uniform(0.95, 0.99)
        else:
            signal = random.choice(["buy", "sell", "hold"])
            entry = close_price
            take_profit = close_price * random.uniform(1.01, 1.05)
            stop_loss = close_price * random.uniform(0.95, 0.99)
        
        confidence = random.uniform(0.3, 0.95)
        
        output = {
            "symbol": symbol,
            "timestamp": datetime.datetime.now().isoformat(),
            "signal": signal,
            "strategy": strategy,
            "indicators": {
                "RSI_20": random.uniform(20, 80),
                "MACD": random.uniform(-100, 100),
                "SMA_50": close_price * random.uniform(0.95, 1.05)
            },
            "price_data": {
                "open": round(open_price, 2),
                "high": round(high_price, 2),
                "low": round(low_price, 2),
                "close": round(close_price, 2),
                "volume": volume
            },
            "targets": {
                "entry": round(entry, 2),
                "take_profit": round(take_profit, 2),
                "stop_loss": round(stop_loss, 2)
            },
            "confidence": round(confidence, 2)
        }
        
        return json.dumps(output, indent=2)

    def generate_training_data(self, num_samples: int = 100) -> List[Dict[str, str]]:
        """Generate training data for all personas"""
        training_data = []
        
        symbols = ["BTC-USD", "ETH-USD", "AAPL", "GOOGL", "MSFT", "EURUSD", "GBPUSD", "GOLD", "SPY", "QQQ"]
        
        for _ in range(num_samples):
            # Generate multi-timeframe analysis
            symbol = random.choice(symbols)
            persona = random.choice(list(self.personas.keys()))
            
            # Type 1: Multi-timeframe analysis → Strategy recommendations
            input_1 = self.generate_multi_timeframe_analysis(symbol, persona)
            output_1 = self.generate_strategy_recommendations_output()
            
            training_data.append({
                "input": input_1,
                "output": output_1,
                "type": "multi_timeframe_strategy",
                "persona": persona,
                "symbol": symbol
            })
            
            # Type 2: Single timeframe analysis → Specific signal
            timeframe = random.choice(self.timeframes)
            input_2 = self.generate_single_timeframe_analysis(symbol, timeframe)
            output_2 = self.generate_specific_signal_output(symbol, persona)
            
            training_data.append({
                "input": input_2,
                "output": output_2,
                "type": "single_timeframe_signal",
                "persona": persona,
                "symbol": symbol,
                "timeframe": timeframe
            })
        
        return training_data

    def save_training_data(self, training_data: List[Dict[str, str]], filename: str = "trading_persona_training_data.json"):
        """Save training data to JSON file"""
        with open(filename, 'w') as f:
            json.dump(training_data, f, indent=2)
        print(f"Training data saved to {filename}")

def main():
    generator = TradingPersonaTrainingDataGenerator()
    
    # Generate training data
    print("Generating training data for trading personas...")
    training_data = generator.generate_training_data(num_samples=50)  # 100 total samples (50 each type)
    
    # Save to file
    generator.save_training_data(training_data)
    
    # Print sample
    print("\nSample training data:")
    print("=" * 50)
    for i, sample in enumerate(training_data[:2]):
        print(f"\nSample {i+1} ({sample['type']} - {sample['persona']}):")
        print(f"Input: {sample['input'][:200]}...")
        print(f"Output: {sample['output'][:200]}...")
        print("-" * 30)

if __name__ == "__main__":
    main()