#ifndef LAYER_H 
#define LAYER_H

#include <vector>

#include "Cell.h"

class Layer  {
public:
    Layer();
    virtual ~Layer();
    
    void init(CellType type, const std::vector<Cell*>& cells);
    
    void forwardPass(const DataBundle& input);

    void backwardPass(const DataBundle& outputError);

     void applyWeightUpdates();

    const std::vector<Cell*>& getCells() const;

protected:
    std::vector<Cell*> cells;
    CellType type;
};

#endif // LAYER_H

