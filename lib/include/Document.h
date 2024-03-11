#pragma once

#include <string>
#include <iostream>
#include <ctime>

enum TradeableInstrument {
    STOCK,                  // Shares of ownership in a company
    FOREX,                  // Trading currency pairs in the foreign exchange market
    CRYPTO,                 // Digital or virtual currencies
    OPTIONS,                // Contracts that give the buyer the right, but not the obligation, to buy or sell an underlying asset
    INDICES,                // Measures of the value of a section of the stock market
    FUTURES,                // Contracts to buy or sell an asset at a predetermined price at a specified time in the future
    FUNDS,                  // Investment funds that pool money from multiple investors
    BONDS,                  // Debt securities representing a loan to the issuer
    COMMODITIES,            // Physical goods traded on commodity exchanges
    DERIVATIVES,            // Financial contracts whose value is derived from the value of an underlying asset
    REITS,                  // Real Estate Investment Trusts that own, operate, or finance income-generating real estate
    ETPS,                   // Exchange-Traded Products that track the performance of an underlying index, commodity, currency, or other assets
    STRUCTURED_PRODUCTS,    // Complex financial instruments created to meet specific investment objectives
    CFDS                    // Contracts for Difference that allow traders to speculate on the price movements of financial instruments
};

struct CommonAttributes {
    std::string symbol;          // Symbol of the instrument
    std::string name;            // Name of the instrument
    std::time_t date;            // Date of the document
    std::string description;     // Description of the instrument
    double price;                // Current price of the instrument
    double volume;               // Trading volume of the instrument
};

struct CryptoAttributes {
   std::string coinName;
   std::string symbol;
   double marketCapitalization;
   double circulatingSupply;
   double tradingVolume;
   std::string blockchainNetwork;

   // Default Constructor
   CryptoAttributes() :
   coinName(""), 
   symbol(""),
   marketCapitalization(0.0),
   circulatingSupply(0.0),
   tradingVolume(0.0),
   blockchainNetwork("") 
   {}

   // Copy Constructor
   CryptoAttributes(const CryptoAttributes& other) :
   coinName(other.coinName),
   symbol(other.symbol),
   marketCapitalization(other.marketCapitalization),
   circulatingSupply(other.circulatingSupply),
    tradingVolume(other.tradingVolume),
    blockchainNetwork(other.blockchainNetwork) 
    {}

  // Destructor
  ~CryptoAttributes() {
     // No dynamically allocated memory to clean up
  }
};


struct StockAttributes {
    std::string companyName;
    std::string tickerSymbol;
    std::string sector;
    double marketCapitalization;
    double dividendYield;
    double priceToEarningsRatio;

    // Default Constructor
    StockAttributes() :
        companyName(""), // Initialize to empty string
        tickerSymbol(""),
        sector(""),
        marketCapitalization(0.0),
        dividendYield(0.0),
        priceToEarningsRatio(0.0)
    { 
        // ... any other initialization logic you need 
    }

    // Copy Constructor
    StockAttributes(const StockAttributes& other) :
        companyName(other.companyName), 
        tickerSymbol(other.tickerSymbol),
        sector(other.sector),
        marketCapitalization(other.marketCapitalization),
        dividendYield(other.dividendYield),
        priceToEarningsRatio(other.priceToEarningsRatio)
    {
        // ... any other deep-copying logic if needed
    }
};


struct OptionsAttributes {
    std::string underlyingAsset;
    double strikePrice;
    std::time_t expirationDate;
    std::string optionType; // "call" or "put"
    double premium;
    double impliedVolatility;

  // Default Constructor
  OptionsAttributes() :
      underlyingAsset(""),
      strikePrice(0.0),
      expirationDate(0), // Initialize time_t appropriately
      optionType(""),
      premium(0.0),
      impliedVolatility(0.0)
  {}

  // Copy Constructor 
  OptionsAttributes(const OptionsAttributes& other) :
     underlyingAsset(other.underlyingAsset),
     strikePrice(other.strikePrice),
     expirationDate(other.expirationDate),
     optionType(other.optionType),
     premium(other.premium),
     impliedVolatility(other.impliedVolatility)
  {}  

  // Destructor
  ~OptionsAttributes() {
     // Nothing to clean up here
  }
};


struct ForexAttributes {
    std::string currencyPair;
    double exchangeRate;
    double bidAskSpread;
    double pipValue;
    double tradingVolume;

    // Default Constructor
    ForexAttributes() :
        currencyPair(""),
        exchangeRate(0.0),
        bidAskSpread(0.0),
        pipValue(0.0),
        tradingVolume(0.0)
    {}

    // Copy Constructor
    ForexAttributes(const ForexAttributes& other) :
        currencyPair(other.currencyPair),
        exchangeRate(other.exchangeRate),
        bidAskSpread(other.bidAskSpread),
        pipValue(other.pipValue),
        tradingVolume(other.tradingVolume) 
    {}

   // Destructor 
   ~ForexAttributes() {
       // No dynamic memory to clean up
   }
};

struct IndicesAttributes {
   std::string indexName;
   std::vector<std::string> constituentStocks;
   std::string weightingMethodology; 
   double indexValue;
   std::string performanceMetrics; 
   std::string sectorComposition; 

   // Default Constructor
   IndicesAttributes() :
      indexName(""),
      weightingMethodology(""),
      indexValue(0.0),
      performanceMetrics(""),
      sectorComposition("")
   {}

   // Copy Constructor
   IndicesAttributes(const IndicesAttributes& other) :
      indexName(other.indexName),
      constituentStocks(other.constituentStocks), // Copies the vector
      weightingMethodology(other.weightingMethodology),
      indexValue(other.indexValue),
      performanceMetrics(other.performanceMetrics),
      sectorComposition(other.sectorComposition)
   {}

  // Destructor
  ~IndicesAttributes() {
     // Nothing to clean up here
  }
};

struct FuturesAttributes {
   std::string underlyingAsset;
   double contractSize;
   std::time_t expirationMonth; 
   std::time_t deliveryDate; 
   double marginRequirements;
   double settlementPrice;

   // Default Constructor
   FuturesAttributes() :
      underlyingAsset(""),
      contractSize(0.0),
      expirationMonth(0),  // Initialize appropriately for time_t
    deliveryDate(0),     // Initialize appropriately for time_t 
      marginRequirements(0.0),
      settlementPrice(0.0)
   {}

   // Copy Constructor
   FuturesAttributes(const FuturesAttributes& other) :
      underlyingAsset(other.underlyingAsset),
      contractSize(other.contractSize),
      expirationMonth(other.expirationMonth),
      deliveryDate(other.deliveryDate),
      marginRequirements(other.marginRequirements),
      settlementPrice(other.settlementPrice)
   {}

  // Destructor
  ~FuturesAttributes() {
     // Nothing to clean up here
  }
};

struct FundsAttributes {
   std::string fundName;
   double netAssetValue;
   double expenseRatio;
   std::vector<std::string> holdings;
   std::string investmentStrategy; 
   std::string performanceMetrics; 

   // Default Constructor
   FundsAttributes() :
      fundName(""),
      netAssetValue(0.0),
      expenseRatio(0.0),
      investmentStrategy(""),
      performanceMetrics("") 
   {}

   // Copy Constructor
   FundsAttributes(const FundsAttributes& other) :
      fundName(other.fundName),
      netAssetValue(other.netAssetValue),
      expenseRatio(other.expenseRatio),
      holdings(other.holdings), // Deep copy the holdings vector
      investmentStrategy(other.investmentStrategy),
      performanceMetrics(other.performanceMetrics) 
   {}

  // Destructor
  ~FundsAttributes() {
     // Nothing dynamically allocated to clean up
  }
};

struct BondsAttributes {
   std::string issuer;
   std::time_t maturityDate;
   double couponRate;
   double yieldToMaturity;
   std::string creditRating;
   std::string bondType; 

   // Default Constructor
   BondsAttributes() :
      issuer(""),
      maturityDate(0),       // Initialize time_t appropriately
      couponRate(0.0),
      yieldToMaturity(0.0),
      creditRating(""),
      bondType("") 
   {}

   // Copy Constructor
   BondsAttributes(const BondsAttributes& other) :
      issuer(other.issuer),
      maturityDate(other.maturityDate),
      couponRate(other.couponRate),
      yieldToMaturity(other.yieldToMaturity),
      creditRating(other.creditRating),
      bondType(other.bondType) 
   {}

 // Destructor
  ~BondsAttributes() {
     // Nothing dynamically allocated to clean up
  }
};

struct CommoditiesAttributes {
   std::string commodityName;
   double spotPrice;
   std::string futuresContracts; 
   std::string supplyAndDemandDynamics;
   double storageCosts;
   std::string seasonalFactors; 

   // Default Constructor
   CommoditiesAttributes() :
      commodityName(""),
      spotPrice(0.0),
      futuresContracts(""),
      supplyAndDemandDynamics(""),
      storageCosts(0.0),
      seasonalFactors("") 
   {}

   // Copy Constructor
   CommoditiesAttributes(const CommoditiesAttributes& other) :
      commodityName(other.commodityName),
      spotPrice(other.spotPrice),
      futuresContracts(other.futuresContracts),
      supplyAndDemandDynamics(other.supplyAndDemandDynamics),
      storageCosts(other.storageCosts),
      seasonalFactors(other.seasonalFactors)
   {}

 // Destructor
 ~CommoditiesAttributes() {
     // No dynamically allocated memory to clean up
 }
};

struct DerivativesAttributes {
   std::string underlyingAsset;
   std::string contractSpecifications;
   std::string pricingModel; 
   double marginRequirements;
   double tradingVolume;
   std::string riskFactors; 

   // Default Constructor
   DerivativesAttributes() :
      underlyingAsset(""),
      contractSpecifications(""),
      pricingModel(""),
      marginRequirements(0.0),
      tradingVolume(0.0),
      riskFactors("") 
   {}

   // Copy Constructor
   DerivativesAttributes(const DerivativesAttributes& other) :
      underlyingAsset(other.underlyingAsset),
      contractSpecifications(other.contractSpecifications),
      pricingModel(other.pricingModel),
      marginRequirements(other.marginRequirements),
      tradingVolume(other.tradingVolume),
      riskFactors(other.riskFactors) 
   {}

 // Destructor
 ~DerivativesAttributes() {
     // Nothing dynamically allocated to clean up
 }
};

struct ReitsAttributes {
  std::vector<std::string> realEstatePortfolio;
  std::vector<std::string> propertyTypes; 
  std::string geographicDiversification;
  double occupancyRates;
  double rentalIncome;
  double dividendYield; 

  // Default Constructor
  ReitsAttributes() :
    occupancyRates(0.0),
    rentalIncome(0.0),
    dividendYield(0.0),
    geographicDiversification("")
  {}

  // Copy Constructor
  ReitsAttributes(const ReitsAttributes& other) :
    realEstatePortfolio(other.realEstatePortfolio), // Deep copy
    propertyTypes(other.propertyTypes),         // Deep copy
    geographicDiversification(other.geographicDiversification),
    occupancyRates(other.occupancyRates),
    rentalIncome(other.rentalIncome),
    dividendYield(other.dividendYield) 
  {}

  // Destructor
  ~ReitsAttributes() {
     // Nothing dynamically allocated to clean up
  }
};

struct EtpsAttributes {
   std::string underlyingIndexOrAsset;
   double trackingError;
   double expenseRatio;
   std::string liquidity; 
   std::string creationRedemptionProcess; 
   std::string marketMakerInvolvement; 

   // Default Constructor
   EtpsAttributes() :
      underlyingIndexOrAsset(""),
      trackingError(0.0),
      expenseRatio(0.0),
      liquidity(""),
      creationRedemptionProcess(""),
      marketMakerInvolvement("")  
   {}

   // Copy Constructor
   EtpsAttributes(const EtpsAttributes& other) :
      underlyingIndexOrAsset(other.underlyingIndexOrAsset),
      trackingError(other.trackingError),
      expenseRatio(other.expenseRatio),
      liquidity(other.liquidity),
      creationRedemptionProcess(other.creationRedemptionProcess),
      marketMakerInvolvement(other.marketMakerInvolvement)  
   {}

 // Destructor
 ~EtpsAttributes() {
     // Nothing dynamically allocated to clean up
 } 
};

struct StructuredProductsAttributes {
   std::vector<std::string> underlyingAssets;
   double participationRate;
   std::vector<double> barrierLevels;
   std::time_t maturityDate; 
   std::vector<double> couponPayments;
   std::string principalProtectionFeatures; 

   // Default Constructor
   StructuredProductsAttributes() :
      participationRate(0.0),
      maturityDate(0)  // Initialize time_t appropriately 
   {}

   // Copy Constructor
   StructuredProductsAttributes(const StructuredProductsAttributes& other) :
      underlyingAssets(other.underlyingAssets), // Deep copy
      participationRate(other.participationRate),
      barrierLevels(other.barrierLevels),       // Deep copy
      maturityDate(other.maturityDate),
      couponPayments(other.couponPayments),     // Deep copy
      principalProtectionFeatures(other.principalProtectionFeatures) 
   {}

 // Destructor
 ~StructuredProductsAttributes() {
     // Nothing dynamically allocated to clean up
 }
};

struct CfdsAttributes {
   std::string underlyingAsset;
   std::string contractSpecifications;
   double leverageRatio;
   double financingCosts;
   double bidAskSpread;
   double marginRequirements;

   // Default Constructor
   CfdsAttributes() :
      underlyingAsset(""),
      contractSpecifications(""),
      leverageRatio(0.0),
      financingCosts(0.0),
      bidAskSpread(0.0),
      marginRequirements(0.0)
   {}

   // Copy Constructor
   CfdsAttributes(const CfdsAttributes& other) :
      underlyingAsset(other.underlyingAsset),
      contractSpecifications(other.contractSpecifications),
      leverageRatio(other.leverageRatio),
      financingCosts(other.financingCosts),
      bidAskSpread(other.bidAskSpread),
      marginRequirements(other.marginRequirements)
   {}

 // Destructor
 ~CfdsAttributes() {
     // Nothing dynamically allocated to clean up
 }
};


// struct UniqueAttributes {
    
//     union {
//         StockAttributes stockAttributes;
//         ForexAttributes forexAttributes;
//         CryptoAttributes cryptoAttributes;
//         OptionsAttributes optionsAttributes;
//         IndicesAttributes indicesAttributes;
//         FundsAttributes fundsAttributes;
//         FuturesAttributes futuresAttributes;
//         BondsAttributes bondsAttributes;
//         CommoditiesAttributes commoditiesAttributes;
//         DerivativesAttributes derivativesAttributes;
//         ReitsAttributes reitsAttributes;
//         EtpsAttributes etpsAttributes;
//         StructuredProductsAttributes structuredProductsAttributes;
//         CfdsAttributes cfdsAttributes;
 
//     };

//     TradeableInstrument instrumentType; // Type of the instrument to indicate the presence of unique attributes
//         // Define a destructor to handle the destruction of non-trivial members in the union
//         UniqueAttributes() { 
            
//     switch (instrumentType) {
//         case STOCK:
//             new (&stockAttributes) StockAttributes();
//             break;
//         case FOREX:
//             new (&forexAttributes) ForexAttributes();
//             break;
//         case CRYPTO:
//             new (&cryptoAttributes) CryptoAttributes();
//             break;
//         case OPTIONS:
//             new (&optionsAttributes) OptionsAttributes();
//             break;
//         case INDICES:
//             new (&indicesAttributes) IndicesAttributes();
//             break;
//         case FUTURES:
//             new (&futuresAttributes) FuturesAttributes();
//             break;
//         case FUNDS:
//             new (&fundsAttributes) FundsAttributes();
//             break;
//         case BONDS:
//             new (&bondsAttributes) BondsAttributes();
//             break;
//         case COMMODITIES:
//             new (&commoditiesAttributes) CommoditiesAttributes();
//             break;
//         case DERIVATIVES:
//             new (&derivativesAttributes) DerivativesAttributes();
//             break;
//         case REITS:
//             new (&reitsAttributes) ReitsAttributes();
//             break;
//         case ETPS:
//             new (&etpsAttributes) EtpsAttributes();
//             break;
//         case STRUCTURED_PRODUCTS:
//             new (&structuredProductsAttributes) StructuredProductsAttributes();
//             break;
//         case CFDS:
//             new (&cfdsAttributes) CfdsAttributes();
//             break;
//          }
//     }
    
//     UniqueAttributes(const UniqueAttributes& other) {
//         instrumentType = other.instrumentType; 
//   switch (instrumentType) {
//         case STOCK:
//             new (&stockAttributes) StockAttributes();
//             break;
//         case FOREX:
//             new (&forexAttributes) ForexAttributes();
//             break;
//         case CRYPTO:
//             new (&cryptoAttributes) CryptoAttributes();
//             break;
//         case OPTIONS:
//             new (&optionsAttributes) OptionsAttributes();
//             break;
//         case INDICES:
//             new (&indicesAttributes) IndicesAttributes();
//             break;
//         case FUTURES:
//             new (&futuresAttributes) FuturesAttributes();
//             break;
//         case FUNDS:
//             new (&fundsAttributes) FundsAttributes();
//             break;
//         case BONDS:
//             new (&bondsAttributes) BondsAttributes();
//             break;
//         case COMMODITIES:
//             new (&commoditiesAttributes) CommoditiesAttributes();
//             break;
//         case DERIVATIVES:
//             new (&derivativesAttributes) DerivativesAttributes();
//             break;
//         case REITS:
//             new (&reitsAttributes) ReitsAttributes();
//             break;
//         case ETPS:
//             new (&etpsAttributes) EtpsAttributes();
//             break;
//         case STRUCTURED_PRODUCTS:
//             new (&structuredProductsAttributes) StructuredProductsAttributes();
//             break;
//         case CFDS:
//             new (&cfdsAttributes) CfdsAttributes();
//             break;
//          }      
//     }           

// };
struct UniqueAttributes {
    union {
        StockAttributes stockAttributes;
        ForexAttributes forexAttributes;
        CryptoAttributes cryptoAttributes;
        OptionsAttributes optionsAttributes;
        IndicesAttributes indicesAttributes;
        FundsAttributes fundsAttributes;
        FuturesAttributes futuresAttributes;
        BondsAttributes bondsAttributes;
        CommoditiesAttributes commoditiesAttributes;
        DerivativesAttributes derivativesAttributes;
        ReitsAttributes reitsAttributes;
        EtpsAttributes etpsAttributes;
        StructuredProductsAttributes structuredProductsAttributes;
        CfdsAttributes cfdsAttributes;
    };

    TradeableInstrument instrumentType;

    UniqueAttributes() : instrumentType(STOCK), stockAttributes() {}
    UniqueAttributes(const UniqueAttributes& other) : instrumentType(other.instrumentType) {
        switch (instrumentType) {
            case STOCK:
                new (&stockAttributes) StockAttributes(other.stockAttributes);
                break;
            case FOREX:
                new (&forexAttributes) ForexAttributes(other.forexAttributes);
                break;
            case CRYPTO:
                new (&cryptoAttributes) CryptoAttributes(other.cryptoAttributes);
                break;
            case OPTIONS:
                new (&optionsAttributes) OptionsAttributes(other.optionsAttributes);
                break;
            case INDICES:
                new (&indicesAttributes) IndicesAttributes(other.indicesAttributes);
                break;
            case FUTURES:
                new (&futuresAttributes) FuturesAttributes(other.futuresAttributes);
                break;
            case FUNDS:
                new (&fundsAttributes) FundsAttributes(other.fundsAttributes);
                break;
            case BONDS:
                new (&bondsAttributes) BondsAttributes(other.bondsAttributes);
                break;
            case COMMODITIES:
                new (&commoditiesAttributes) CommoditiesAttributes(other.commoditiesAttributes);
                break;
            case DERIVATIVES:
                new (&derivativesAttributes) DerivativesAttributes(other.derivativesAttributes);
                break;
            case REITS:
                new (&reitsAttributes) ReitsAttributes(other.reitsAttributes);
                break;
            case ETPS:
                new (&etpsAttributes) EtpsAttributes(other.etpsAttributes);
                break;
            case STRUCTURED_PRODUCTS:
                new (&structuredProductsAttributes) StructuredProductsAttributes(other.structuredProductsAttributes);
                break;
            case CFDS:
                new (&cfdsAttributes) CfdsAttributes(other.cfdsAttributes);
                break;
        }
    }

    ~UniqueAttributes() {
        switch (instrumentType) {
            case STOCK:
                stockAttributes.~StockAttributes();
                break;
            case FOREX:
                forexAttributes.~ForexAttributes();
                break;
            case CRYPTO:
                cryptoAttributes.~CryptoAttributes();
                break;
            case OPTIONS:
                optionsAttributes.~OptionsAttributes();
                break;
            case INDICES:
                indicesAttributes.~IndicesAttributes();
                break;
            case FUTURES:
                futuresAttributes.~FuturesAttributes();
                break;
            case FUNDS:
                fundsAttributes.~FundsAttributes();
                break;
            case BONDS:
                bondsAttributes.~BondsAttributes();
                break;
            case COMMODITIES:
                commoditiesAttributes.~CommoditiesAttributes();
                break;
            case DERIVATIVES:
                derivativesAttributes.~DerivativesAttributes();
                break;
            case REITS:
                reitsAttributes.~ReitsAttributes();
                break;
            case ETPS:
                etpsAttributes.~EtpsAttributes();
                break;
            case STRUCTURED_PRODUCTS:
                structuredProductsAttributes.~StructuredProductsAttributes();
                break;
            case CFDS:
                cfdsAttributes.~CfdsAttributes();
                break;
        }
    }
};

struct Document {
    CommonAttributes common;                // Common attributes for all instruments
    UniqueAttributes unique;                // Unique attributes based on instrument type
    std::string technicalIndicators;        // Technical indicators relevant to the instrument
    std::string fundamentals;               // Fundamental analysis relevant to the instrument
    std::string news;                       // News related to the instrument

    void print(std::ostream& output) const;
};

       // Add unique attributes for Stock
        // struct {
        //     std::string companyName;
        //     std::string tickerSymbol;
        //     std::string sector;
        //     double marketCapitalization;
        //     double dividendYield;
        //     double priceToEarningsRatio;
        // } stockAttributes;

        // // Add unique attributes for Forex
        // struct {
        //     std::string currencyPair;
        //     double exchangeRate;
        //     double bidAskSpread;
        //     double pipValue;
        //     double tradingVolume;
        // } forexAttributes;

        // // Add unique attributes for Cryptocurrency
        // struct {
        //     std::string coinName;
        //     std::string symbol;
        //     double marketCapitalization;
        //     double circulatingSupply;
        //     double tradingVolume;
        //     std::string blockchainNetwork;
        // } cryptoAttributes;

        // // Add unique attributes for Options
        // struct {
        //     std::string underlyingAsset;
        //     double strikePrice;
        //     std::time_t expirationDate;
        //     std::string optionType;
        //     double premium;
        //     double impliedVolatility;
        // } optionsAttributes;

        // // Add unique attributes for Indices
        // struct {
        //     std::string indexName;
        //     std::vector<std::string> constituentStocks;
        //     std::string weightingMethodology;
        //     double indexValue;
        //     std::string performanceMetrics;
        //     std::string sectorComposition;
        // } indicesAttributes;

        // // Add unique attributes for Futures
        // struct {
        //     std::string underlyingAsset;
        //     double contractSize;
        //     std::time_t expirationMonth;
        //     std::time_t deliveryDate;
        //     double marginRequirements;
        //     double settlementPrice;
        // } futuresAttributes;

        // // Add unique attributes for Funds
        // struct {
        //     std::string fundName;
        //     double netAssetValue;
        //     double expenseRatio;
        //     std::vector<std::string> holdings;
        //     std::string investmentStrategy;
        //     std::string performanceMetrics;
        // } fundsAttributes;

        // // Add unique attributes for Bonds
        // struct {
        //     std::string issuer;
        //     std::time_t maturityDate;
        //     double couponRate;
        //     double yieldToMaturity;
        //     std::string creditRating;
        //     std::string bondType;
        // } bondsAttributes;

        // // Add unique attributes for Commodities
        // struct {
        //     std::string commodityName;
        //     double spotPrice;
        //     std::string futuresContracts;
        //     std::string supplyAndDemandDynamics;
        //     double storageCosts;
        //     std::string seasonalFactors;
        // } commoditiesAttributes;

        // // Add unique attributes for Derivatives
        // struct {
        //     std::string underlyingAsset;
        //     std::string contractSpecifications;
        //     std::string pricingModel;
        //     double marginRequirements;
        //     double tradingVolume;
        //     std::string riskFactors;
        // } derivativesAttributes;

        // // Add unique attributes for REITs
        // struct {
        //     std::vector<std::string> realEstatePortfolio;
        //     std::vector<std::string> propertyTypes;
        //     std::string geographicDiversification;
        //     double occupancyRates;
        //     double rentalIncome;
        //     double dividendYield;
        // } reitsAttributes;

        // // Add unique attributes for ETPs
        // struct {
        //     std::string underlyingIndexOrAsset;
        //     double trackingError;
        //     double expenseRatio;
        //     std::string liquidity;
        //     std::string creationRedemptionProcess;
        //     std::string marketMakerInvolvement;
        // } etpsAttributes;

        // // Add unique attributes for Structured Products
        // struct {
        //     std::vector<std::string> underlyingAssets;
        //     double participationRate;
        //     std::vector<double> barrierLevels;
        //     std::time_t maturityDate;
        //     std::vector<double> couponPayments;
        //     std::string principalProtectionFeatures;
        // } structuredProductsAttributes;

        // // Add unique attributes for CFDs
        // struct {
        //     std::string underlyingAsset;
        //     std::string contractSpecifications;
        //     double leverageRatio;
        //     double financingCosts;
        //     double bidAskSpread;
        //     double marginRequirements;
        // } cfdsAttributes;