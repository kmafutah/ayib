#include <string>
#include <ctime>
#include <vector>
#include "Document.h"

int main() {
    // Create a Document instance
    Document document;

    // Populate common attributes
    document.common.symbol = "AAPL";
    document.common.name = "Apple Inc.";
    document.common.date = std::time(nullptr); // set the current date
    document.common.description = "Technology company specializing in consumer electronics.";

    // Populate unique attributes based on the instrument type (e.g., stock)
    document.unique.instrumentType = STOCK;
    document.unique.stockAttributes.companyName = "Apple Inc.";
    document.unique.stockAttributes.tickerSymbol = "AAPL";
    document.unique.stockAttributes.sector = "Technology";
    document.unique.stockAttributes.marketCapitalization = 2290.34; // in billion dollars
    document.unique.stockAttributes.dividendYield = 0.0064;
    document.unique.stockAttributes.priceToEarningsRatio = 28.52;

    // Populate technical indicators, fundamentals, and news
    document.technicalIndicators = "Moving averages, RSI";
    document.fundamentals = "Revenue growth, Earnings per share";
    document.news = "New product launch, Quarterly earnings report";

    // Print the document
    document.print(std::cout);

    return 0;
}
