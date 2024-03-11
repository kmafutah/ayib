#ifndef CELL_H
#define CELL_H

#include <vector> 
struct StochResult {
    double stoch_main;
    double stoch_signal;
};

struct MACDResult {
    double macd_line;
    double macd_signal;
    double macd_histo;
};

struct Tick {
    double ask;
    double bid;
    long volume;
};

struct OHLCV {
    double open;
    double high;
    double low;
    double close;
    long volume;
};

struct DataBundle {
    std::chrono::system_clock::time_point timestamp;
    bool is_ohlcv;     // Flag to identify data type
    std::vector<OHLCV> ohlcv_data;  // OHLCV values (open, high, low, close, volume)
    std::vector<Tick> abv_data;     // Ask, bid, volume data
    double atr;         // Avarage True Range  
    double rsi;         // Relative Strength Index  
    double sma;         // Simple Moving Average
    double cci;         // CCI
    double stoch_main;  // Stoch M
    double stoch_signal;// Stoch S
    double macd_main;   // MACD M
    double macd_signal; // MACD S
    double macd_histo;  // MACD H
    double ao;          // AO for building the 6 bill william candles types clrGreen, clrYellowGreen, clrYellow, clrGold, clrOrange, clrRed
    double ac;          // AC for building the 6 bill william candles types clrGreen, clrYellowGreen, clrYellow, clrGold, clrOrange, clrRed
    double perfecttrend;   // Perfect Trend
    double supertrend;   // Super Trend
    double halftrend;    // Half Trend
};


enum CellType {
    INPUT, 
    BACKFED_INPUT,
    NOISY_INPUT,
    HIDDEN,
    PROBABILISTIC_HIDDEN,
    SPIKE_HIDDEN, 
    CAPSULE,
    OUTPUT,
    MATCH_INPUT_OUTPUT,
    RECURRENT,
    MEMORY,
    GATED_MEMORY,
    KERNEL,
    CONVOLUTION_OR_POOL
};

enum class ActivationType { SIGMOID, RELU, TANH, LINEAR };

class Cell {
public:
        // Constructor
    Cell(int num_inputs); 

    // Setters
    void setWeights(const std::vector<double>& weights); 
    void setBias(double bias);  

    // Calculation of output
    double calculateOutput(const std::vector<double>& inputs);

    virtual ~Cell();

    // Process a single tick
    virtual void processTick(const Tick& tick) = 0; 

    // Process a single OHLCV bar
    virtual void processOHLCV(const OHLCV& ohlcv) = 0;

    // Process an entire DataBundle
    virtual void processDataBundle(const DataBundle& bundle) = 0; 

    // Accessor for calculated technical indicators 
    const DataBundle& getOutputData() const; 

    // Activation functions
    float sigmoid(float x); 
    float relu(float x);
    float tanh(float x); 
    // Calculate Relative Strength Index (RSI)
    double calculateRSI(const std::vector<OHLCV>& ohlcv_data, int period) ;

    // Calculate Simple Moving Average (SMA)
    double calculateSMA(const std::vector<OHLCV>& ohlcv_data, int period);

    // Calculate Commodity Channel Index (CCI)
    double calculateCCI(const std::vector<OHLCV>& ohlcv_data, int period) ;

    // Calculate Stochastic Oscillator
    StochResult calculateStoch(const std::vector<OHLCV>& ohlcv_data, int stoch_period, int k_smoothing_period, int d_smoothing_period) ;

    // Calculate Moving Average Convergence Divergence (MACD)
    MACDResult calculateMACD(const std::vector<OHLCV>& ohlcv_data, int short_period, int long_period, int signal_period);

    // Calculate Awesome Oscillator (AO)
    double calculateAO(const std::vector<OHLCV>& ohlcv_data, int short_period, int long_period);

    // Calculate Acceleration/Deceleration Oscillator (AC)
    double calculateAC(const std::vector<OHLCV>& ohlcv_data, int short_period, int long_period) ;

    // Calculate Perfect Trend
    double calculatePerfectTrend(const std::vector<OHLCV>& ohlcv_data, int period) ;

    // Calculate SuperTrend
    double calculateSuperTrend(const std::vector<OHLCV>& ohlcv_data, int period, double multiplier);
    // Calculate Half Trend
    double calculateHalfTrend(const std::vector<OHLCV>& ohlcv_data, int period, double multiplier);    
    
private:
    std::vector<double> weights; 
    double bias;
    CellType cell_type;
    ActivationType activation_func;

protected:
    // Stores computed indicators, etc.
    DataBundle outputData;  
    int period = 14; // Member variable to store the period
};

// Derived classes for specific cell types 

class HiddenCell : public Cell {
public:
    HiddenCell() : Cell(CellType::HIDDEN) {}

};

class InputCell : public Cell {
public:
    InputCell() : Cell(CellType::INPUT) {}


};

class BackfedInputCell : public Cell {
public:
    BackfedInputCell() : Cell(CellType::BACKFED_INPUT) {}

};

class NoisyInputCell : public Cell {
public:
    NoisyInputCell() : Cell(CellType::NOISY_INPUT) {}

};

class ProbabilisticHiddenCell : public Cell {
public:
    ProbabilisticHiddenCell() : Cell(CellType::PROBABILISTIC_HIDDEN) {}

};

class SpikeHiddenCell : public Cell {
public:
    SpikeHiddenCell() : Cell(CellType::SPIKE_HIDDEN) {}

};

class CapsuleCell : public Cell {
public:
    CapsuleCell() : Cell(CellType::CAPSULE) {}

};

class OutputCell : public Cell {
public:
    OutputCell() : Cell(CellType::OUTPUT) {}

};

class MatchInputOutputCell : public Cell {
public:
    MatchInputOutputCell() : Cell(CellType::MATCH_INPUT_OUTPUT) {}

};

class RecurrentCell : public Cell {
public:
    RecurrentCell() : Cell(CellType::RECURRENT) {}

};

class MemoryCell : public Cell {
public:
    MemoryCell() : Cell(CellType::MEMORY) {}

};

class GatedMemoryCell : public Cell {
public:
    GatedMemoryCell() : Cell(CellType::GATED_MEMORY) {}

};

class KernelCell : public Cell {
public:
    KernelCell() : Cell(CellType::KERNEL) {}

};

class ConvolutionOrPoolCell : public Cell {
public:
    ConvolutionOrPoolCell() : Cell(CellType::CONVOLUTION_OR_POOL) {}

};

#endif // CELL_H
