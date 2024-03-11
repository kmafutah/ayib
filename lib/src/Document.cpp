#include <fmt/format.h>
#include <fmt/chrono.h>
#include "Document.h"

void Document::print(std::ostream& output) const {
    output << "Symbol: " << common.symbol << std::endl;
    output << "Name: " << common.name << std::endl;
    output << "Date: " << std::ctime(&common.date);
    output << "Description: " << common.description << std::endl;
    output << "Price: " << common.price << std::endl;
    output << "Volume: " << common.volume << std::endl;
    switch (unique.instrumentType) {
        case STOCK:
            output << "Company Name: " << unique.stockAttributes.companyName << std::endl;
            output << "Ticker Symbol: " << unique.stockAttributes.tickerSymbol << std::endl;
            output << "Sector: " << unique.stockAttributes.sector << std::endl;
            output << "Market Capitalization: " << unique.stockAttributes.marketCapitalization << std::endl;
            output << "Dividend Yield: " << unique.stockAttributes.dividendYield << std::endl;
            output << "P/E Ratio: " << unique.stockAttributes.priceToEarningsRatio << std::endl;
            break;
        case FOREX:
            output << "Currency Pair: " << unique.forexAttributes.currencyPair << std::endl;
            output << "Exchange Rate: " << unique.forexAttributes.exchangeRate << std::endl;
            output << "Bid/Ask Spread: " << unique.forexAttributes.bidAskSpread << std::endl;
            output << "Pip Value: " << unique.forexAttributes.pipValue << std::endl;
            output << "Trading Volume: " << unique.forexAttributes.tradingVolume << std::endl;
            break;
        case CRYPTO:
            output << "Coin Name: " << unique.cryptoAttributes.coinName << std::endl;
            output << "Symbol: " << unique.cryptoAttributes.symbol << std::endl;
            output << "Market Capitalization: " << unique.cryptoAttributes.marketCapitalization << std::endl;
            output << "Circulating Supply: " << unique.cryptoAttributes.circulatingSupply << std::endl;
            output << "Trading Volume: " << unique.cryptoAttributes.tradingVolume << std::endl;
            output << "Blockchain Network: " << unique.cryptoAttributes.blockchainNetwork << std::endl;
            break;
        // Add cases for other instrument types
        case OPTIONS:
            output << "Underlying Asset: " << unique.optionsAttributes.underlyingAsset << std::endl;
            output << "Strike Price: " << unique.optionsAttributes.strikePrice << std::endl;
            output << "Expiration Date: " << std::ctime(&unique.optionsAttributes.expirationDate);
            output << "Option Type: " << unique.optionsAttributes.optionType << std::endl;
            output << "Premium: " << unique.optionsAttributes.premium << std::endl;
            output << "Implied Volatility: " << unique.optionsAttributes.impliedVolatility << std::endl;
            break;
        case INDICES:
            output << "Index Name: " << unique.indicesAttributes.indexName << std::endl;
            output << "Constituent Stocks: ";
            for (const auto& stock : unique.indicesAttributes.constituentStocks) {
                output << stock << ", ";
            }
            output << std::endl;
            output << "Weighting Methodology: " << unique.indicesAttributes.weightingMethodology << std::endl;
            output << "Index Value: " << unique.indicesAttributes.indexValue << std::endl;
            output << "Performance Metrics: " << unique.indicesAttributes.performanceMetrics << std::endl;
            output << "Sector Composition: " << unique.indicesAttributes.sectorComposition << std::endl;
            break;

        case FUTURES:
            output << "Underlying Asset: " << unique.futuresAttributes.underlyingAsset << std::endl;
            output << "Contract Size: " << unique.futuresAttributes.contractSize << std::endl;
            output << "Expiration Month: " << std::ctime(&unique.futuresAttributes.expirationMonth);
            output << "Delivery Date: " << std::ctime(&unique.futuresAttributes.deliveryDate);
            output << "Margin Requirements: " << unique.futuresAttributes.marginRequirements << std::endl;
            output << "Settlement Price: " << unique.futuresAttributes.settlementPrice << std::endl;
            break;

        case FUNDS:
            output << "Fund Name: " << unique.fundsAttributes.fundName << std::endl;
            output << "Net Asset Value (NAV): " << unique.fundsAttributes.netAssetValue << std::endl;
            output << "Expense Ratio: " << unique.fundsAttributes.expenseRatio << std::endl;
            output << "Holdings: ";
            for (const auto& holding : unique.fundsAttributes.holdings) {
                output << holding << ", ";
            }
            output << std::endl;
            output << "Investment Strategy: " << unique.fundsAttributes.investmentStrategy << std::endl;
            output << "Performance Metrics: " << unique.fundsAttributes.performanceMetrics << std::endl;
            break;

        case BONDS:
            output << "Issuer: " << unique.bondsAttributes.issuer << std::endl;
            output << "Maturity Date: " << std::ctime(&unique.bondsAttributes.maturityDate);
            output << "Coupon Rate: " << unique.bondsAttributes.couponRate << std::endl;
            output << "Yield to Maturity: " << unique.bondsAttributes.yieldToMaturity << std::endl;
            output << "Credit Rating: " << unique.bondsAttributes.creditRating << std::endl;
            output << "Bond Type: " << unique.bondsAttributes.bondType << std::endl;
            break;

        case COMMODITIES:
            output << "Commodity Name: " << unique.commoditiesAttributes.commodityName << std::endl;
            output << "Spot Price: " << unique.commoditiesAttributes.spotPrice << std::endl;
            output << "Futures Contracts: " << unique.commoditiesAttributes.futuresContracts << std::endl;
            output << "Supply and Demand Dynamics: " << unique.commoditiesAttributes.supplyAndDemandDynamics << std::endl;
            output << "Storage Costs: " << unique.commoditiesAttributes.storageCosts << std::endl;
            output << "Seasonal Factors: " << unique.commoditiesAttributes.seasonalFactors << std::endl;
            break;

        case DERIVATIVES:
            output << "Underlying Asset: " << unique.derivativesAttributes.underlyingAsset << std::endl;
            output << "Contract Specifications: " << unique.derivativesAttributes.contractSpecifications << std::endl;
            output << "Pricing Model: " << unique.derivativesAttributes.pricingModel << std::endl;
            output << "Margin Requirements: " << unique.derivativesAttributes.marginRequirements << std::endl;
            output << "Trading Volume: " << unique.derivativesAttributes.tradingVolume << std::endl;
            output << "Risk Factors: " << unique.derivativesAttributes.riskFactors << std::endl;
            break;

        case REITS:
            output << "Portfolio of Real Estate Assets: ";
            for (const auto& asset : unique.reitsAttributes.realEstatePortfolio) {
                output << asset << ", ";
            }
            output << std::endl;
            output << "Property Types: ";
            for (const auto& property : unique.reitsAttributes.propertyTypes) {
                output << property << ", ";
            }
            output << std::endl;
            output << "Geographic Diversification: " << unique.reitsAttributes.geographicDiversification << std::endl;
            output << "Occupancy Rates: " << unique.reitsAttributes.occupancyRates << std::endl;
            output << "Rental Income: " << unique.reitsAttributes.rentalIncome << std::endl;
            output << "Dividend Yield: " << unique.reitsAttributes.dividendYield << std::endl;
            break;

        case ETPS:
            output << "Underlying Index or Asset: " << unique.etpsAttributes.underlyingIndexOrAsset << std::endl;
            output << "Tracking Error: " << unique.etpsAttributes.trackingError << std::endl;
            output << "Expense Ratio: " << unique.etpsAttributes.expenseRatio << std::endl;
            output << "Liquidity: " << unique.etpsAttributes.liquidity << std::endl;
            output << "Creation/Redemption Process: " << unique.etpsAttributes.creationRedemptionProcess << std::endl;
            output << "Market Maker Involvement: " << unique.etpsAttributes.marketMakerInvolvement << std::endl;
            break;

        case STRUCTURED_PRODUCTS:
            output << "Underlying Assets: ";
            for (const auto& asset : unique.structuredProductsAttributes.underlyingAssets) {
                output << asset << ", ";
            }
            output << std::endl;
            output << "Participation Rate: " << unique.structuredProductsAttributes.participationRate << std::endl;
            output << "Barrier Levels: ";
            for (const auto& barrier : unique.structuredProductsAttributes.barrierLevels) {
                output << barrier << ", ";
            }
            output << std::endl;
            output << "Maturity Date: " << std::ctime(&unique.structuredProductsAttributes.maturityDate);
            output << "Coupon Payments: ";
            for (const auto& payment : unique.structuredProductsAttributes.couponPayments) {
                output << payment << ", ";
            }
            output << std::endl;
            output << "Principal Protection Features: " << unique.structuredProductsAttributes.principalProtectionFeatures << std::endl;
            break;

        case CFDS:
            output << "Underlying Asset: " << unique.cfdsAttributes.underlyingAsset << std::endl;
            output << "Contract Specifications: " << unique.cfdsAttributes.contractSpecifications << std::endl;
            output << "Leverage Ratio: " << unique.cfdsAttributes.leverageRatio << std::endl;
            output << "Financing Costs: " << unique.cfdsAttributes.financingCosts << std::endl;
            output << "Bid/Ask Spread: " << unique.cfdsAttributes.bidAskSpread << std::endl;
            output << "Margin Requirements: " << unique.cfdsAttributes.marginRequirements << std::endl;
            break;

        default:
            break;

    }
    output << "Technical Indicators: " << technicalIndicators << std::endl;
    output << "Fundamentals: " << fundamentals << std::endl;
    output << "News: " << news << std::endl;
}

