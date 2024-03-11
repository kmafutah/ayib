#include "Layer.h"
#include "Cell.h"

Layer::Layer() {}
Layer::~Layer() {}

 void Layer::init(CellType type, const std::vector<Cell*>& cells) {
    this->type = type;
    this->cells = cells;
}

void Layer::forwardPass(const DataBundle& input) {
    for (Cell* cell : cells) {
        if (input.is_ohlcv) {
            for(OHLCV ohlcv_data : input.ohlcv_data)
            {
            cell->processOHLCV(ohlcv_data);
            }
        } else {
            for(Tick abv_data : input.abv_data)
            {
            cell->processTick(abv_data);
            }
        }
    }
    // Update outputData with the output of the cells
    outputData.ohlcv_data = input.ohlcv_data;
    outputData.abv_data = input.abv_data;
    for (Cell* cell : cells) {
        outputData.atr = cell.->atr;
        outputData.rsi = cell->rsi;
        outputData.sma = cell->sma;
        outputData.cci = cell->cci;
        outputData.stoch_main = cell->stoch_main;
        outputData.stoch_signal = cell->stoch_signal;
        outputData. macd_main = cell->macd_main;
        outputData.macd_signal = cell->macd_signal;
        outputData.macd_histo = cell->macd_histo;
        outputData.ao = cell->ao;
        outputData.ac = cell->ac;
        outputData.perfecttrend = cell->perfecttrend;
        outputData.supertrend = cell->supertrend;
        outputData.halftrend = cell->halftrend;
    }
}

void Layer::backwardPass(const DataBundle& outputError) {}
void Layer::applyWeightUpdates() {}

const std::vector<Cell*>& Layer::getCells() const {
    return cells;
}
