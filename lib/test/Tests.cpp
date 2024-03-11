#include <catch.hpp>
#include <sstream>
#include "Document.h"

using namespace std;

TEST_CASE("Printing documents of different tradeable instrument types should not throw exceptions")
{
    // // Test document for Stock
    // Document stockDoc
    // {
    //     // Common attributes
    //     {
    //         "AAPL",
    //         "Apple Inc.",
    //         std::time(nullptr),
    //         "Stock",
    //         120.0,
    //         // Unique attributes for Stock
    //         {  2.3e12, 0.67, 29.41 }
    //     },
    //     "Technical indicators for stock",
    //     "Fundamentals for stock",
    //     "News for stock"
    // };

    // // Test document for Forex
    // Document forexDoc
    // {
    //     // Common attributes
    //     {
    //         "EURUSD=X",
    //         "EUR/USD",
    //         std::time(nullptr),
    //         "Forex",
    //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
    //         // Unique attributes for Forex
    //         { "EUR/USD", 1.2345, 0.0001, 10, 100000 }
    //     },
    //     "Technical indicators for forex",
    //     "Fundamentals for forex",
    //     "News for forex"
    // };

    // Similarly create test documents for each instrument type

    ostringstream output;

    // Check if printing each document does not throw exceptions
    // REQUIRE_NOTHROW(stockDoc.print(output));
    // REQUIRE_NOTHROW(forexDoc.print(output));

    // Add similar REQUIRE_NOTHROW checks for other instrument types
}
