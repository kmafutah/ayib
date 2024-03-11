#include "Network.h "

#include "Layer.h"

Network::Network() {}

Network::~Network() {}

void Network::init(const std::vector<Layer*>& layers) {
    this->layers = layers;
}

void Network::forwardPass(const DataBundle& input) {
    for (Layer* layer : layers) {
        layer->forwardPass(input);
    }
}

void Network::backwardPass(const DataBundle& outputError) {
    // perform backward pass for each layer
    for (auto it = layers.rbegin(); it != layers.rend(); ++it) {
        (*it)->backwardPass(outputError);
    }
}
