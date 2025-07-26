import json
import random
import datetime
import pandas as pd
from typing import Dict, List, Any

class RealTrainingDataGenerator:
    def __init__(self):
        self.personas = {
            "The Savvy Zebra Stockbroker": {
                "primary_instrument": "STOCK",
                "secondary_instruments": ["INDICES", "OPTIONS"],
                "strategy": "TrendFollowingStrategy",
                "description": "Focuses on stocks with trend-following approach",
                "preferred_symbols": ["AAPL", "GOOGL", "MSFT", "AMZN", "TSLA"]
            },
            "The Elephant Economist": {
                "primary_instrument": "BONDS",
                "secondary_instruments": ["FUNDS", "FOREX"],
                "strategy": "DollarCostAveragingStrategy",
                "description": "Conservative bond-focused investor",
                "preferred_symbols": ["TLT", "IEF", "AGG", "BND", "EURUSD"]
            },
            "The Meerkat Venture Capitalist": {
                "primary_instrument": "FUNDS",
                "secondary_instruments": ["STRUCTURED_PRODUCTS", "ETPS"],
                "strategy": "DiversificationStrategy",
                "description": "Diversified fund investor",
                "preferred_symbols": ["SPY", "QQQ", "VTI", "VEA", "VWO"]
            },
            "The Cheetah Day Trader": {
                "primary_instrument": "FOREX",
                "secondary_instruments": ["CFDS", "DERIVATIVES"],
                "strategy": "ScalpingStrategy",
                "description": "Fast-paced forex scalper",
                "preferred_symbols": ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCAD"]
            },
            "The Lion Hedge Fund Manager": {
                "primary_instrument": "FUNDS",
                "secondary_instruments": ["OPTIONS", "DERIVATIVES"],
                "strategy": "ValueInvestingStrategy",
                "description": "Sophisticated value investor",
                "preferred_symbols": ["SPY", "QQQ", "IWM", "EFA", "EEM"]
            },
            "The Rhino Real Estate Mogul": {
                "primary_instrument": "REITS",
                "secondary_instruments": ["BONDS", "STRUCTURED_PRODUCTS"],
                "strategy": "FundamentalAnalysisStrategy",
                "description": "Real estate focused investor",
                "preferred_symbols": ["VNQ", "IYR", "SCHH", "RWR", "XLRE"]
            },
            "The Pangolin Cryptocurrency Enthusiast": {
                "primary_instrument": "CRYPTO",
                "secondary_instruments": ["CFDS", "DERIVATIVES"],
                "strategy": "RSIStrategy",
                "description": "Crypto momentum trader",
                "preferred_symbols": ["BTC-USD", "ETH-USD", "ADA-USD", "DOT-USD", "LINK-USD"]
            }
        }
        
        self.timeframes = ["1m", "5m", "15m", "30m", "1H", "2H", "4H", "1D", "1W", "1M"]
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

    def create_persona_specific_prompt(self, persona: str, symbol: str, timeframe: str = None) -> str:
        """Create a persona-specific prompt for the AI model"""
        persona_data = self.personas[persona]
        
        prompt = f"""You are {persona}, a trading expert specializing in {persona_data['primary_instrument']} instruments.
        
Your trading approach:
- Primary Instrument: {persona_data['primary_instrument']}
- Secondary Instruments: {', '.join(persona_data['secondary_instruments'])}
- Preferred Strategy: {persona_data['strategy']}
- Description: {persona_data['description']}

Analyze the following technical data for {symbol} and provide recommendations based on your expertise and trading style.

Technical Analysis Data:
"""
        return prompt

    def generate_multi_timeframe_strategy_prompt(self, persona: str, symbol: str, analysis_data: Dict) -> str:
        """Generate a prompt for multi-timeframe strategy recommendations"""
        prompt = self.create_persona_specific_prompt(persona, symbol)
        
        prompt += f"""
Please analyze the provided technical data for {symbol} across multiple timeframes and recommend appropriate trading strategies.

Based on your expertise as {persona}, provide:
1. Overall market sentiment
2. Recommended trading strategies
3. Risk management considerations
4. Position sizing recommendations

Format your response as a JSON object with strategy recommendations.
"""
        return prompt

    def generate_single_timeframe_signal_prompt(self, persona: str, symbol: str, timeframe: str, analysis_data: Dict) -> str:
        """Generate a prompt for single timeframe specific signals"""
        prompt = self.create_persona_specific_prompt(persona, symbol, timeframe)
        
        prompt += f"""
Analyze the technical data for {symbol} on the {timeframe} timeframe.

As {persona}, provide a specific trading signal including:
1. Entry price
2. Stop loss level
3. Take profit target
4. Position size recommendation
5. Confidence level
6. Reasoning based on your strategy

Format your response as a JSON object with the trading signal details.
"""
        return prompt

    def generate_expected_output_format(self, persona: str, analysis_type: str) -> str:
        """Generate the expected output format for the AI model"""
        persona_data = self.personas[persona]
        strategy = persona_data["strategy"]
        
        if analysis_type == "multi_timeframe_strategy":
            return json.dumps(self.strategies, indent=2)
        elif analysis_type == "single_timeframe_signal":
            # Generate realistic signal based on persona's strategy
            signal = "buy" if random.random() > 0.5 else "sell"
            confidence = random.uniform(0.3, 0.95)
            
            output = {
                "symbol": "SYMBOL",
                "timestamp": datetime.datetime.now().isoformat(),
                "signal": signal,
                "strategy": strategy,
                "indicators": {
                    "RSI_20": random.uniform(20, 80),
                    "MACD": random.uniform(-100, 100),
                    "SMA_50": random.uniform(100, 50000)
                },
                "price_data": {
                    "open": random.uniform(100, 50000),
                    "high": random.uniform(100, 50000),
                    "low": random.uniform(100, 50000),
                    "close": random.uniform(100, 50000),
                    "volume": random.randint(1000, 100000)
                },
                "targets": {
                    "entry": random.uniform(100, 50000),
                    "take_profit": random.uniform(100, 50000),
                    "stop_loss": random.uniform(100, 50000)
                },
                "confidence": round(confidence, 2),
                "reasoning": f"Based on {strategy} analysis"
            }
            return json.dumps(output, indent=2)
        
        return ""

    def create_training_sample(self, persona: str, symbol: str, analysis_type: str, timeframe: str = None) -> Dict[str, str]:
        """Create a single training sample"""
        
        # Create the input prompt
        if analysis_type == "multi_timeframe_strategy":
            input_prompt = self.generate_multi_timeframe_strategy_prompt(persona, symbol, {})
        else:
            input_prompt = self.generate_single_timeframe_signal_prompt(persona, symbol, timeframe, {})
        
        # Generate expected output
        expected_output = self.generate_expected_output_format(persona, analysis_type)
        
        return {
            "input": input_prompt,
            "output": expected_output,
            "type": analysis_type,
            "persona": persona,
            "symbol": symbol,
            "timeframe": timeframe
        }

    def generate_training_dataset(self, samples_per_persona: int = 10) -> List[Dict[str, str]]:
        """Generate a comprehensive training dataset"""
        training_data = []
        
        for persona in self.personas.keys():
            persona_data = self.personas[persona]
            preferred_symbols = persona_data["preferred_symbols"]
            
            for _ in range(samples_per_persona):
                symbol = random.choice(preferred_symbols)
                
                # Generate multi-timeframe strategy sample
                sample_1 = self.create_training_sample(
                    persona, symbol, "multi_timeframe_strategy"
                )
                training_data.append(sample_1)
                
                # Generate single timeframe signal sample
                timeframe = random.choice(self.timeframes)
                sample_2 = self.create_training_sample(
                    persona, symbol, "single_timeframe_signal", timeframe
                )
                training_data.append(sample_2)
        
        return training_data

    def save_training_data(self, training_data: List[Dict[str, str]], filename: str = "persona_training_data.json"):
        """Save training data to JSON file"""
        with open(filename, 'w') as f:
            json.dump(training_data, f, indent=2)
        print(f"Training data saved to {filename}")

    def create_finetuning_format(self, training_data: List[Dict[str, str]]) -> List[Dict[str, str]]:
        """Convert to fine-tuning format for LLM training"""
        finetuning_data = []
        
        for sample in training_data:
            # Format for instruction fine-tuning
            instruction = f"""You are {sample['persona']}, a trading expert. Analyze the following technical data and provide trading recommendations.

{sample['input']}"""
            
            finetuning_data.append({
                "instruction": instruction,
                "input": "",
                "output": sample['output'],
                "persona": sample['persona'],
                "type": sample['type'],
                "symbol": sample['symbol']
            })
        
        return finetuning_data

def main():
    generator = RealTrainingDataGenerator()
    
    # Generate training data
    print("Generating persona-specific training data...")
    training_data = generator.generate_training_dataset(samples_per_persona=5)
    
    # Save original format
    generator.save_training_data(training_data, "persona_training_data.json")
    
    # Create fine-tuning format
    finetuning_data = generator.create_finetuning_format(training_data)
    generator.save_training_data(finetuning_data, "persona_finetuning_data.json")
    
    # Print statistics
    print(f"\nGenerated {len(training_data)} training samples")
    print(f"Generated {len(finetuning_data)} fine-tuning samples")
    
    # Print sample
    print("\nSample training data:")
    print("=" * 50)
    for i, sample in enumerate(training_data[:2]):
        print(f"\nSample {i+1} ({sample['type']} - {sample['persona']}):")
        print(f"Symbol: {sample['symbol']}")
        print(f"Input: {sample['input'][:200]}...")
        print(f"Output: {sample['output'][:200]}...")
        print("-" * 30)

if __name__ == "__main__":
    main()