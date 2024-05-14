import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:sqlite3/sqlite3.dart';

class TechnicalIndicators {
  // Trend Indicators
  Map<String, dynamic> calculateSMA(List<double> prices, int period) {
    double sma =
        prices.sublist(prices.length - period).reduce((a, b) => a + b) / period;
    String signal = prices.last > sma ? 'BUY' : 'SELL';
    return {'value': sma, 'sma${period.toString().trim()}Signal': signal};
  }

  Map<String, dynamic> calculateEMA(List<double> prices, int period) {
    double ema = _calculateEMAHelper(prices, period);
    String signal = prices.last > ema ? 'BUY' : 'SELL';
    return {'value': ema, 'ema${period.toString().trim()}Signal': signal};
  }

  double _calculateEMAHelper(List<double> prices, int period) {
    if (period <= 0 || period > prices.length) {
      throw ArgumentError('Invalid period value');
    }

    double multiplier = 2 / (period + 1);
    double ema = prices.last;
    for (int i = prices.length - 2; i >= prices.length - period; i--) {
      ema = (prices[i] - ema) * multiplier + ema;
    }
    return ema;
  }

  Map<String, dynamic> calculateMACD(
      List<double> prices, int shortPeriod, int longPeriod, int signalPeriod) {
    if (shortPeriod <= 0 || longPeriod <= 0 || signalPeriod <= 0) {
      throw ArgumentError('Invalid period value');
    }

    List<double> shortEMAValues = [];
    List<double> longEMAValues = [];

    for (int i = prices.length - 1; i >= 0; i--) {
      if (i >= prices.length - shortPeriod) {
        shortEMAValues.add(prices[i]);
      }
      if (i >= prices.length - longPeriod) {
        longEMAValues.add(prices[i]);
      }
    }

    shortEMAValues = shortEMAValues.reversed.toList(); // Reverse the lists
    longEMAValues = longEMAValues.reversed.toList();

    double shortEMA = _calculateEMAHelper(shortEMAValues, shortPeriod);
    double longEMA = _calculateEMAHelper(longEMAValues, longPeriod);
    double macdLine = shortEMA - longEMA;
    double signalLine = _calculateEMAHelperMACD([macdLine], signalPeriod);
    double histogram = macdLine - signalLine;

    String signal = histogram > 0 ? 'BUY' : 'SELL';
    return {
      'macdLine': macdLine,
      'signalLine': signalLine,
      'histogram': histogram,
      'mcadSignal': signal,
    };
  }

  double _calculateEMAHelperMACD(List<double> values, int period) {
    double sma = values.reduce((a, b) => a + b) / period;
    double multiplier = 2 / (period + 1);
    double ema = (values.last - sma) * multiplier + sma;
    return ema;
  }

  // PSAR (Parabolic SAR)
  Map<String, dynamic> calculatePSAR(List<double> highs, List<double> lows,
      double accelerationFactor, double maxAcceleration) {
    double psar = lows.first;
    double extreme = highs.first;
    double acceleration = accelerationFactor;
    double af = accelerationFactor;

    List<double> psarValues = [];

    for (int i = 1; i < highs.length; i++) {
      if (lows[i - 1] < psar) {
        psarValues.add(psar);
        extreme = highs[i];
        af = accelerationFactor;
      } else {
        psarValues.add(extreme);
      }

      if (highs[i] > extreme) {
        extreme = highs[i];
        af = min(af + accelerationFactor, maxAcceleration);
      }

      psar += af * (extreme - psar);
    }

    String signal = highs.last > psar ? 'BUY' : 'SELL';

    return {'psarValues': psarValues, 'psarSignal': signal};
  }

  // Ichimoku Cloud
  Map<String, dynamic> calculateIchimoku(
      List<double> highs,
      List<double> lows,
      List<double> closes,
      int tenkanSenPeriod,
      int kijunSenPeriod,
      int senkouSpanBPeriod,
      int chikouSpanShift) {
    double tenkanSen = (highs
                .sublist(highs.length - tenkanSenPeriod)
                .reduce((a, b) => max(a, b)) +
            lows
                .sublist(lows.length - tenkanSenPeriod)
                .reduce((a, b) => min(a, b))) /
        2;
    double kijunSen = (highs
                .sublist(highs.length - kijunSenPeriod)
                .reduce((a, b) => max(a, b)) +
            lows
                .sublist(lows.length - kijunSenPeriod)
                .reduce((a, b) => min(a, b))) /
        2;
    double senkouSpanA = (tenkanSen + kijunSen) / 2;
    double senkouSpanB = (highs
                .sublist(highs.length - senkouSpanBPeriod)
                .reduce((a, b) => max(a, b)) +
            lows
                .sublist(lows.length - senkouSpanBPeriod)
                .reduce((a, b) => min(a, b))) /
        2;
    double chikouSpan = closes[closes.length - chikouSpanShift - 1];

    String signal = closes.last > senkouSpanA &&
            closes.last > senkouSpanB &&
            closes.last > tenkanSen &&
            closes.last > kijunSen &&
            closes.last > chikouSpan
        ? 'BUY'
        : 'SELL';

    return {
      'tenkanSen': tenkanSen,
      'kijunSen': kijunSen,
      'senkouSpanA': senkouSpanA,
      'senkouSpanB': senkouSpanB,
      'chikouSpan': chikouSpan,
      'ichimokuSignal': signal,
    };
  }

  Map<String, dynamic> calculateSupertrend(
      List<double> highs,
      List<double> lows,
      List<double> closes,
      int atrPeriod,
      double multiplier) {
    List<double> atrValues = _calculateATR(highs, lows, closes, atrPeriod);

    List<double> supertrendValues = [];
    String lastSignal = 'BUY';

    for (int i = 0; i < highs.length - 1; i++) {
      double upperBand = (highs[i] + lows[i]) / 2 + multiplier * atrValues[i];
      double lowerBand = (highs[i] + lows[i]) / 2 - multiplier * atrValues[i];

      if (i == 0) {
        supertrendValues
            .add(closes[i]); // Initialize with the first close price
      } else {
        if (closes[i - 1] > supertrendValues[i - 1]) {
          supertrendValues.add(max(upperBand, supertrendValues[i - 1]));
        } else {
          supertrendValues.add(min(lowerBand, supertrendValues[i - 1]));
        }
      }

      if (closes[i] > supertrendValues[i]) {
        lastSignal = 'BUY';
      } else if (closes[i] < supertrendValues[i]) {
        lastSignal = 'SELL';
      }
    }

    return {
      'supertrendValues': supertrendValues,
      'supertrendSignal': lastSignal,
    };
  }

  List<double> _calculateATR(
      List<double> highs, List<double> lows, List<double> closes, int period) {
    List<double> atrValues = [];
    double tr = 0;

    for (int i = 1; i < highs.length; i++) {
      double highLow = highs[i] - lows[i];
      double highClose = (highs[i] - closes[i - 1]).abs();
      double lowClose = (lows[i] - closes[i - 1]).abs();

      tr = max(highLow, max(highClose, lowClose));

      if (atrValues.length < period) {
        atrValues.add(tr);
      } else {
        atrValues.add(((period - 1) * atrValues.last + tr) / period);
      }
    }

    return atrValues;
  }

  // Momentum Indicators
  Map<String, dynamic> calculateRSI(List<double> closes, int period) {
    double gainSum = 0;
    double lossSum = 0;

    for (int i = 1; i < closes.length; i++) {
      double priceDiff = closes[i] - closes[i - 1];
      if (priceDiff > 0) {
        gainSum += priceDiff;
      } else {
        lossSum -= priceDiff;
      }
    }

    double avgGain = gainSum / period;
    double avgLoss = lossSum / period;
    double rs = avgGain / avgLoss;
    double rsi = 100 - (100 / (1 + rs));

    String signal = rsi > 70 ? 'SELL' : (rsi < 30 ? 'BUY' : 'NEUTRAL');

    return {'rsiValue': rsi, 'rsiSignal': signal};
  }

  Map<String, dynamic> calculateROC(List<double> closes, int period) {
    double roc = (closes.last - closes[closes.length - period - 1]) /
        closes[closes.length - period - 1] *
        100;
    String signal = roc > 0 ? 'BUY' : 'SELL';

    return {'rocValue': roc, 'rocSignal': signal};
  }

  Map<String, dynamic> calculateCMO(List<double> closes, int period) {
    double sumUp = 0;
    double sumDown = 0;

    for (int i = 1; i < closes.length; i++) {
      double priceDiff = closes[i] - closes[i - 1];
      if (priceDiff > 0) {
        sumUp += priceDiff;
      } else {
        sumDown -= priceDiff;
      }
    }

    double cmo = ((sumUp - sumDown) / (sumUp + sumDown)) * 100;
    String signal = cmo > 0 ? 'BUY' : 'SELL';

    return {'cmoValue': cmo, 'cmoSignal': signal};
  }

  Map<String, dynamic> calculatePPO(
      List<double> closes, int shortPeriod, int longPeriod) {
    double shortEMA = _calculateEMAHelper(closes, shortPeriod);
    double longEMA = _calculateEMAHelper(closes, longPeriod);
    double ppo = (shortEMA - longEMA) / longEMA * 100;
    String signal = ppo > 0 ? 'BUY' : 'SELL';

    return {'ppoValue': ppo, 'ppoSignal': signal};
  }

  Map<String, dynamic> calculateWPR(
      List<double> highs, List<double> lows, List<double> closes, int period) {
    double highestHigh =
        highs.sublist(highs.length - period).reduce((a, b) => max(a, b));
    double lowestLow =
        lows.sublist(lows.length - period).reduce((a, b) => min(a, b));
    double wpr =
        ((highestHigh - closes.last) / (highestHigh - lowestLow)) * -100;
    String signal = wpr < -80 ? 'BUY' : (wpr > -20 ? 'SELL' : 'NEUTRAL');

    return {'wprValue': wpr, 'wprSignal': signal};
  }

  Map<String, dynamic> calculateRVI(List<double> opens, List<double> highs,
      List<double> lows, List<double> closes, int period) {
    double upSum = 0;
    double downSum = 0;
    double volatility = 0;

    for (int i = 1; i < opens.length; i++) {
      double diff = closes[i] - opens[i];
      if (diff > 0) {
        upSum += diff;
      } else {
        downSum -= diff;
      }
      volatility += highs[i] - lows[i];
    }

    double rvi = upSum / (upSum + downSum) * (volatility / period);
    String signal = rvi > 50 ? 'BUY' : 'SELL';

    return {'rviValue': rvi, 'rviSignal': signal};
  }

  // double _calculateEMAHelper(List<double> prices, int period) {
  //   double multiplier = 2 / (period + 1);
  //   double ema = prices.last;
  //   for (int i = prices.length - 2; i >= prices.length - period; i--) {
  //     ema = (prices[i] - ema) * multiplier + ema;
  //   }
  //   return ema;
  // }

  // Volatility Indicators
  // Volatility Indicators
  Map<String, dynamic> calculateBBANDS(
      List<double> closes, int period, double stdDevMultiplier) {
    double middleBand =
        closes.sublist(closes.length - period).reduce((a, b) => a + b) / period;
    double stdDev = sqrt(closes
            .sublist(closes.length - period)
            .map((price) => pow(price - middleBand, 2))
            .reduce((a, b) => a + b) /
        period);
    double upperBand = middleBand + stdDevMultiplier * stdDev;
    double lowerBand = middleBand - stdDevMultiplier * stdDev;
    String signal = closes.last > upperBand
        ? 'SELL'
        : (closes.last < lowerBand ? 'BUY' : 'NEUTRAL');

    return {
      'upperBand': upperBand,
      'middleBand': middleBand,
      'lowerBand': lowerBand,
      'bbandsSignal': signal
    };
  }

  // List<double> _calculateATR(
  //     List<double> highs, List<double> lows, List<double> closes, int period) {
  //   List<double> atrValues = [];
  //   double tr = 0;

  //   for (int i = 0; i < highs.length; i++) {
  //     double highLow = highs[i] - lows[i];
  //     double highClose = (highs[i] - closes[i - 1]).abs();
  //     double lowClose = (lows[i] - closes[i - 1]).abs();

  //     tr = max(highLow, max(highClose, lowClose));

  //     if (atrValues.length < period) {
  //       atrValues.add(tr);
  //     } else {
  //       atrValues.add(((period - 1) * atrValues.last + tr) / period);
  //     }
  //   }

  //   return atrValues;
  // }

  double calculateATRValue(
      List<double> highs, List<double> lows, List<double> closes, int period) {
    List<double> atrValues = _calculateATR(highs, lows, closes, period);
    return atrValues.last;
  }

  Map<String, dynamic> calculateSTDEV(List<double> closes, int period) {
    double stdDev = sqrt(closes
            .sublist(closes.length - period)
            .map((price) => pow(
                price -
                    (closes
                            .sublist(closes.length - period)
                            .reduce((a, b) => a + b) /
                        period),
                2))
            .reduce((a, b) => a + b) /
        period);
    String signal = closes.last > stdDev
        ? 'SELL'
        : (closes.last < stdDev ? 'BUY' : 'NEUTRAL');

    return {'stdDevValue': stdDev, 'stdDevSignal': signal};
  }

  Map<String, dynamic> calculateKC(List<double> highs, List<double> lows,
      List<double> closes, int period, double atrMultiplier) {
    double atr = calculateATRValue(highs, lows, closes, period);
    double upperKC = closes.last + atrMultiplier * atr;
    double lowerKC = closes.last - atrMultiplier * atr;
    String signal = closes.last > upperKC
        ? 'SELL'
        : (closes.last < lowerKC ? 'BUY' : 'NEUTRAL');

    return {'upperKC': upperKC, 'lowerKC': lowerKC, 'kcSignal': signal};
  }

  Map<String, dynamic> calculateDonchian(
      List<double> highs, List<double> lows, List<double> closes, int period) {
    double upperDonchian =
        highs.sublist(highs.length - period).reduce((a, b) => max(a, b));
    double lowerDonchian =
        lows.sublist(lows.length - period).reduce((a, b) => min(a, b));
    String signal = closes.last > upperDonchian
        ? 'SELL'
        : (closes.last < lowerDonchian ? 'BUY' : 'NEUTRAL');

    return {
      'upperDonchian': upperDonchian,
      'lowerDonchian': lowerDonchian,
      'donchianSignal': signal
    };
  }

  Map<String, dynamic> calculateChandelierExit(
      List<double> highs,
      List<double> lows,
      List<double> closes,
      int period,
      double atrMultiplier) {
    double atr = calculateATRValue(highs, lows, closes, period);
    double chandelierLong =
        highs.sublist(highs.length - period).reduce((a, b) => max(a, b)) -
            atrMultiplier * atr;
    double chandelierShort =
        lows.sublist(lows.length - period).reduce((a, b) => min(a, b)) +
            atrMultiplier * atr;
    String signal = closes.last > chandelierLong
        ? 'SELL'
        : (closes.last < chandelierShort ? 'BUY' : 'NEUTRAL');

    return {
      'chandelierLong': chandelierLong,
      'chandelierShort': chandelierShort,
      'chandelierSignal': signal
    };
  }

  // Volume Indicators
  Map<String, dynamic> calculateOBV(List<double> closes, List<double> volumes) {
    List<double> obvValues = [0];
    for (int i = 1; i < closes.length; i++) {
      if (closes[i] > closes[i - 1]) {
        obvValues.add(obvValues.last + volumes[i]);
      } else if (closes[i] < closes[i - 1]) {
        obvValues.add(obvValues.last - volumes[i]);
      } else {
        obvValues.add(obvValues.last);
      }
    }
    String signal = obvValues.last > obvValues[obvValues.length - 2]
        ? 'BUY'
        : (obvValues.last < obvValues[obvValues.length - 2]
            ? 'SELL'
            : 'NEUTRAL');

    return {'obvValue': obvValues.last, 'obvSignal': signal};
  }

  Map<String, dynamic> calculateCMF(List<double> closes, List<double> highs,
      List<double> lows, List<double> volumes, int period) {
    List<double> moneyFlowVolumes = [];
    List<double> moneyFlowMultipliers = [];
    for (int i = 0; i < closes.length; i++) {
      double moneyFlowVolume =
          ((closes[i] - lows[i]) - (highs[i] - closes[i])) * volumes[i];
      moneyFlowVolumes.add(moneyFlowVolume);
      if (i >= period) {
        double periodMoneyFlowVolume =
            moneyFlowVolumes.sublist(i - period, i).reduce((a, b) => a + b);
        double periodVolume =
            volumes.sublist(i - period, i).reduce((a, b) => a + b);
        moneyFlowMultipliers.add(periodMoneyFlowVolume / periodVolume);
      }
    }
    double cmf =
        moneyFlowMultipliers.isNotEmpty ? moneyFlowMultipliers.last : 0;
    String signal = cmf > 0 ? 'BUY' : (cmf < 0 ? 'SELL' : 'NEUTRAL');

    return {'cmfValue': cmf, 'cmfSignal': signal};
  }

  Map<String, dynamic> calculateVROC(
      List<double> closes, List<double> volumes, int period) {
    List<double> vrocValues = [];
    for (int i = 0; i < closes.length; i++) {
      if (i >= period) {
        double vroc =
            ((volumes[i] - volumes[i - period]) / volumes[i - period]) * 100;
        vrocValues.add(vroc);
      }
    }
    double vroc = vrocValues.isNotEmpty ? vrocValues.last : 0;
    String signal = vroc > 0 ? 'BUY' : (vroc < 0 ? 'SELL' : 'NEUTRAL');

    return {'vrocValue': vroc, 'vrocSignal': signal};
  }

  Map<String, dynamic> calculateMFI(List<double> highs, List<double> lows,
      List<double> closes, List<double> volumes, int period) {
    List<double> typicalPrices = [];
    for (int i = 0; i < closes.length; i++) {
      double typicalPrice = (highs[i] + lows[i] + closes[i]) / 3;
      typicalPrices.add(typicalPrice);
    }

    List<double> moneyFlowVolumes = [];
    for (int i = 1; i < typicalPrices.length; i++) {
      double moneyFlowVolume = typicalPrices[i] * volumes[i];
      moneyFlowVolumes.add(moneyFlowVolume);
    }

    List<double> positiveMoneyFlows = [];
    List<double> negativeMoneyFlows = [];
    for (int i = 1; i < typicalPrices.length; i++) {
      if (typicalPrices[i] > typicalPrices[i - 1]) {
        positiveMoneyFlows.add(moneyFlowVolumes[i - 1]);
        negativeMoneyFlows.add(0);
      } else if (typicalPrices[i] < typicalPrices[i - 1]) {
        positiveMoneyFlows.add(0);
        negativeMoneyFlows.add(moneyFlowVolumes[i - 1]);
      } else {
        positiveMoneyFlows.add(0);
        negativeMoneyFlows.add(0);
      }
    }

    List<double> positiveMoneyFlowSum = [];
    List<double> negativeMoneyFlowSum = [];
    for (int i = 1; i < typicalPrices.length; i++) {
      positiveMoneyFlowSum.add(positiveMoneyFlows
          .sublist(max(0, i - period), i)
          .reduce((a, b) => a + b));
      negativeMoneyFlowSum.add(negativeMoneyFlows
          .sublist(max(0, i - period), i)
          .reduce((a, b) => a + b));
    }

    List<double> moneyFlowRatio = [];
    for (int i = 0; i < typicalPrices.length - period; i++) {
      double mfi = 100 -
          (100 / (1 + (positiveMoneyFlowSum[i] / negativeMoneyFlowSum[i])));
      moneyFlowRatio.add(mfi);
    }

    double mfi = moneyFlowRatio.isNotEmpty ? moneyFlowRatio.last : 0;
    String signal = mfi > 80 ? 'SELL' : (mfi < 20 ? 'BUY' : 'NEUTRAL');

    return {'mfiValue': mfi, 'mfiSignal': signal};
  }

  Map<String, dynamic> calculateADL(List<double> highs, List<double> lows,
      List<double> closes, List<double> volumes) {
    List<double> adlValues = [0];
    for (int i = 1; i < closes.length; i++) {
      double adl = (((closes[i] - lows[i]) - (highs[i] - closes[i])) /
                  (highs[i] - lows[i])) *
              volumes[i] +
          adlValues.last;
      adlValues.add(adl);
    }
    String signal = adlValues.last > adlValues[adlValues.length - 2]
        ? 'BUY'
        : (adlValues.last < adlValues[adlValues.length - 2]
            ? 'SELL'
            : 'NEUTRAL');

    return {'adlValue': adlValues.last, 'adlSignal': signal};
  }

  Map<String, dynamic> calculateEOM(List<double> highs, List<double> lows,
      List<double> closes, List<double> volumes, int period) {
    List<double> moneyFlowVolumes = [];
    for (int i = 0; i < closes.length; i++) {
      double moneyFlowVolume = ((closes[i] - (lows[i] + highs[i]) / 2) /
              ((highs[i] - lows[i]) == 0 ? 0.0001 : (highs[i] - lows[i]))) *
          volumes[i];
      moneyFlowVolumes.add(moneyFlowVolume);
    }

    List<double> eomValues = [];
    for (int i = 0; i < closes.length - period; i++) {
      double eom =
          moneyFlowVolumes.sublist(i, i + period).reduce((a, b) => a + b) /
              volumes.sublist(i, i + period).reduce((a, b) => a + b);
      eomValues.add(eom);
    }

    double eom = eomValues.isNotEmpty ? eomValues.last : 0;
    String signal = eom > 0 ? 'BUY' : (eom < 0 ? 'SELL' : 'NEUTRAL');

    return {'eomValue': eom, 'eomSignal': signal};
  }

  // Oscillator Indicators
  Map<String, dynamic> calculateVWAP(List<double> highs, List<double> lows,
      List<double> closes, List<double> volumes) {
    List<double> typicalPrices = [];
    for (int i = 0; i < closes.length; i++) {
      double typicalPrice = (highs[i] + lows[i] + closes[i]) / 3;
      typicalPrices.add(typicalPrice);
    }

    List<double> vwapValues = [];
    List<double> cumulativeVolume = [];
    double cumulativePriceVolume = 0;
    double cumulativeVolumeValue = 0;

    for (int i = 0; i < closes.length; i++) {
      cumulativePriceVolume += typicalPrices[i] * volumes[i];
      cumulativeVolumeValue += volumes[i];
      vwapValues.add(cumulativePriceVolume / cumulativeVolumeValue);
      cumulativeVolume.add(cumulativeVolumeValue);
    }

    double vwap = vwapValues.isNotEmpty ? vwapValues.last : 0;
    String signal =
        vwap > closes.last ? 'SELL' : (vwap < closes.last ? 'BUY' : 'NEUTRAL');

    return {'vwapValue': vwap, 'vwapSignal': signal};
  }

  Map<String, dynamic> calculateTSI(
      List<double> closes, int shortPeriod, int longPeriod) {
    List<double> shortEMA = [];
    List<double> longEMA = [];
    double shortMultiplier = 2 / (shortPeriod + 1);
    double longMultiplier = 2 / (longPeriod + 1);

    for (int i = 0; i < closes.length; i++) {
      if (i == 0) {
        shortEMA.add(closes[i]);
        longEMA.add(closes[i]);
      } else {
        double shortValue =
            (closes[i] - shortEMA[i - 1]) * shortMultiplier + shortEMA[i - 1];
        double longValue =
            (closes[i] - longEMA[i - 1]) * longMultiplier + longEMA[i - 1];
        shortEMA.add(shortValue);
        longEMA.add(longValue);
      }
    }

    List<double> tsiValues = [];
    for (int i = 0; i < closes.length; i++) {
      double tsi = 100 * (shortEMA[i] - longEMA[i]) / longEMA[i];
      tsiValues.add(tsi);
    }

    double tsi = tsiValues.isNotEmpty ? tsiValues.last : 0;
    String signal = tsi > 0 ? 'BUY' : (tsi < 0 ? 'SELL' : 'NEUTRAL');

    return {'tsiValue': tsi, 'tsiSignal': signal};
  }

  Map<String, dynamic> calculateStochastic(
      List<double> highs,
      List<double> lows,
      List<double> closes,
      int period,
      int kSmoothing,
      int dSmoothing) {
    double lowestLow =
        lows.sublist(lows.length - period).reduce((a, b) => min(a, b));
    double highestHigh =
        highs.sublist(highs.length - period).reduce((a, b) => max(a, b));

    double currentClose = closes.last;
    double kValue =
        100 * (currentClose - lowestLow) / (highestHigh - lowestLow);
    double dValue = kValue;

    List<double> kValues = [];
    List<double> dValues = [];
    kValues.add(kValue);
    dValues.add(dValue);

    for (int i = 0; i < kSmoothing - 1; i++) {
      kValues.add(kValue);
      dValues.add(dValue);
    }

    for (int i = 0; i < kSmoothing; i++) {
      kValue = (kValue * (kSmoothing - 1) + kValues.last) / kSmoothing;
      dValue = (dValue * (dSmoothing - 1) + dValues.last) / dSmoothing;
      kValues.add(kValue);
      dValues.add(dValue);
    }

    double kLine = kValues.last;
    double dLine = dValues.last;

    String signal =
        kLine > dLine ? 'BUY' : (kLine < dLine ? 'SELL' : 'NEUTRAL');

    return {'kLine': kLine, 'dLine': dLine, 'stochasticSignal': signal};
  }

  Map<String, dynamic> calculateAwesomeOscillator(
      List<double> highs, List<double> lows, int shortPeriod, int longPeriod) {
    List<double> shortSMA = _calculateSMAHelper(highs, shortPeriod);
    List<double> longSMA = _calculateSMAHelper(lows, longPeriod);

    List<double> aoValues = [];
    for (int i = 0; i < shortSMA.length; i++) {
      aoValues.add(shortSMA[i] - longSMA[i]);
    }

    double ao = aoValues.isNotEmpty ? aoValues.last : 0;
    String signal = ao > 0 ? 'BUY' : (ao < 0 ? 'SELL' : 'NEUTRAL');

    return {'awesomeOscillator': ao, 'awesomeOscillatorSignal': signal};
  }

  List<double> _calculateSMAHelper(List<double> prices, int period) {
    // If it still calculates SMA for the entire input list...
    double sma =
        prices.sublist(prices.length - period).reduce((a, b) => a + b) / period;
    return List.filled(
        prices.length, sma); // Return a list filled with the same SMA value
  }

  Map<String, dynamic> calculateDPO(List<double> closes, int period) {
    int shift = (period / 2).floor() + 1;
    List<double> dpoValues = [];

    for (int i = period + shift - 1; i < closes.length; i++) {
      // Calculate SMA directly (no need for additional indexing)
      double? sma =
          calculateSMA(closes.sublist(i - period, i), period)['value'];

      if (sma != null) {
        double dpo = closes[i - shift] - sma;
        dpoValues.add(dpo);
      } else {
        // Handle the case where SMA is null
        // Example: Default DPO to 0
        dpoValues.add(0);

        // Optional: Log an error message
        print('Error: SMA calculation returned null at index $i');
      }
    }

    double dpo = dpoValues.isNotEmpty ? dpoValues.last : 0;
    String signal = dpo > 0 ? 'BUY' : (dpo < 0 ? 'SELL' : 'NEUTRAL');

    return {'dpoValue': dpo, 'dpoSignal': signal};
  }

  Map<String, dynamic> calculateCCI(
      List<double> highs, List<double> lows, List<double> closes, int period) {
    List<double> typicalPrices = [];
    for (int i = 0; i < closes.length; i++) {
      double typicalPrice = (highs[i] + lows[i] + closes[i]) / 3;
      typicalPrices.add(typicalPrice);
    }

    double sma = calculateSMA(typicalPrices, period)['value'];
    double meanDeviation = 0;
    for (int i = period - 1; i < typicalPrices.length; i++) {
      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += (typicalPrices[j] - sma).abs();
      }
      meanDeviation += sum / period;
    }

    double cci = (typicalPrices.last - sma) / (0.015 * meanDeviation);
    String signal = cci > 100 ? 'SELL' : (cci < -100 ? 'BUY' : 'NEUTRAL');

    return {'cciValue': cci, 'cciSignal': signal};
  }

  // Support and Resistance Indicators

  List<Map<String, dynamic>> calculatePivots(
      List<String> dates,
      List<double> opens,
      List<double> highs,
      List<double> lows,
      List<double> closes,
      List<double> volumes) {
    List<Map<String, dynamic>> pivotData = [];

    for (int i = 0; i < dates.length; i++) {
      Map<String, dynamic> pivotPoint = {
        'Date': dates[i],
        'Open': opens[i],
        'High': highs[i],
        'Low': lows[i],
        'Close': closes[i],
        'Volume': volumes[i],
      };

      // Calculate Classic pivot points
      pivotPoint['Classic_Pivot (P)'] = (highs[i] + lows[i] + closes[i]) / 3;
      pivotPoint['Classic_S3'] = pivotPoint['Classic_Pivot (P)'] -
          2 * (highs[i] - pivotPoint['Classic_Pivot (P)']);
      pivotPoint['Classic_S2'] =
          pivotPoint['Classic_Pivot (P)'] - (highs[i] - lows[i]);
      pivotPoint['Classic_S1'] = 2 * pivotPoint['Classic_Pivot (P)'] - highs[i];
      pivotPoint['Classic_R1'] = 2 * pivotPoint['Classic_Pivot (P)'] - lows[i];
      pivotPoint['Classic_R2'] =
          pivotPoint['Classic_Pivot (P)'] + (highs[i] - lows[i]);
      pivotPoint['Classic_R3'] = pivotPoint['Classic_Pivot (P)'] +
          2 * (highs[i] - pivotPoint['Classic_Pivot (P)']);

      // Calculate Fibonacci pivot points
      pivotPoint['Fibonacci_Pivot (P)'] = (highs[i] + lows[i] + closes[i]) / 3;
      pivotPoint['Fibonacci_S3'] = pivotPoint['Fibonacci_Pivot (P)'] -
          2 * (highs[i] - pivotPoint['Fibonacci_Pivot (P)']);
      pivotPoint['Fibonacci_S2'] =
          pivotPoint['Fibonacci_Pivot (P)'] - (highs[i] - lows[i]) * 0.618;
      pivotPoint['Fibonacci_S1'] =
          pivotPoint['Fibonacci_Pivot (P)'] - (highs[i] - lows[i]) * 0.382;
      pivotPoint['Fibonacci_R1'] =
          pivotPoint['Fibonacci_Pivot (P)'] + (highs[i] - lows[i]) * 0.382;
      pivotPoint['Fibonacci_R2'] =
          pivotPoint['Fibonacci_Pivot (P)'] + (highs[i] - lows[i]) * 0.618;
      pivotPoint['Fibonacci_R3'] = pivotPoint['Fibonacci_Pivot (P)'] +
          2 * (highs[i] - pivotPoint['Fibonacci_Pivot (P)']);

      // Calculate Camarilla pivot points
      pivotPoint['Camarilla_S3'] = closes[i] - (0.55 * (highs[i] - lows[i]));
      pivotPoint['Camarilla_S2'] = closes[i] - (0.72 * (highs[i] - lows[i]));
      pivotPoint['Camarilla_S1'] = closes[i] - (1.09 * (highs[i] - lows[i]));
      pivotPoint['Camarilla_Pivot (P)'] = (highs[i] + lows[i] + closes[i]) / 3;
      pivotPoint['Camarilla_R1'] = closes[i] + (0.55 * (highs[i] - lows[i]));
      pivotPoint['Camarilla_R2'] = closes[i] + (0.72 * (highs[i] - lows[i]));
      pivotPoint['Camarilla_R3'] = closes[i] + (1.09 * (highs[i] - lows[i]));

      // Calculate Woodie pivot points
      pivotPoint['Woodie_Pivot (P)'] = (highs[i] + lows[i] + 2 * closes[i]) / 4;
      pivotPoint['Woodie_S3'] = (2 * pivotPoint['Woodie_Pivot (P)']) - highs[i];
      pivotPoint['Woodie_S2'] =
          pivotPoint['Woodie_Pivot (P)'] - (highs[i] - lows[i]);
      pivotPoint['Woodie_S1'] = (2 * pivotPoint['Woodie_Pivot (P)']) - highs[i];
      pivotPoint['Woodie_R1'] = (2 * pivotPoint['Woodie_Pivot (P)']) - lows[i];
      pivotPoint['Woodie_R2'] =
          pivotPoint['Woodie_Pivot (P)'] + (highs[i] - lows[i]);
      pivotPoint['Woodie_R3'] =
          pivotPoint['Woodie_Pivot (P)'] + 2 * (highs[i] - lows[i]);

      // Calculate DM pivot points
      pivotPoint['DM_Pivot (P)'] = (2 * highs[i] + lows[i] + closes[i]) / 4;
      pivotPoint['DM_S3'] = pivotPoint['DM_Pivot (P)'] - (highs[i] - lows[i]);
      pivotPoint['DM_S2'] =
          pivotPoint['DM_Pivot (P)'] - 2 * (highs[i] - lows[i]);
      pivotPoint['DM_S1'] = (2 * pivotPoint['DM_Pivot (P)']) - highs[i];
      pivotPoint['DM_R1'] = pivotPoint['DM_Pivot (P)'] + (highs[i] - lows[i]);
      pivotPoint['DM_R2'] =
          pivotPoint['DM_Pivot (P)'] + 2 * (highs[i] - lows[i]);
      pivotPoint['DM_R3'] = closes[i] + (2 * highs[i] - lows[i]);

      // Calculate Murray pivot points as Custom_Pivot
      pivotPoint['Murray_Pivot (P)'] = (highs[i] + lows[i] + closes[i]) / 3;
      pivotPoint['Murray_S3'] =
          pivotPoint['Murray_Pivot (P)'] - (highs[i] - lows[i]) * 0.55;
      pivotPoint['Murray_S2'] =
          pivotPoint['Murray_Pivot (P)'] - (highs[i] - lows[i]) * 0.45;
      pivotPoint['Murray_S1'] =
          pivotPoint['Murray_Pivot (P)'] - (highs[i] - lows[i]) * 0.35;
      pivotPoint['Murray_R1'] =
          pivotPoint['Murray_Pivot (P)'] + (highs[i] - lows[i]) * 0.35;
      pivotPoint['Murray_R2'] =
          pivotPoint['Murray_Pivot (P)'] + (highs[i] - lows[i]) * 0.45;
      pivotPoint['Murray_R3'] =
          pivotPoint['Murray_Pivot (P)'] + (highs[i] - lows[i]) * 0.55;

      // Add the calculated pivot points to the list
      pivotData.add(pivotPoint);
    }

    return pivotData;
  }

  // Support and Resistance Indicators
  Map<String, dynamic> calculatePivotPoints(
      List<double> highs, List<double> lows, List<double> closes) {
    double pivotPoint = (highs.first + lows.first + closes.first) / 3;
    double r1 = 2 * pivotPoint - lows.first;
    double r2 = pivotPoint + (highs.first - lows.first);
    double r3 = highs.first + 2 * (pivotPoint - lows.first);
    double s1 = 2 * pivotPoint - highs.first;
    double s2 = pivotPoint - (highs.first - lows.first);
    double s3 = lows.first - 2 * (highs.first - pivotPoint);

    return {
      'pivotPoint': pivotPoint,
      'r1': r1,
      'r2': r2,
      'r3': r3,
      's1': s1,
      's2': s2,
      's3': s3
    };
  }

  Map<String, dynamic> calculateFibonacciRetracement(List<double> highs,
      List<double> lows, double startPoint, double endPoint) {
    double range = startPoint - endPoint;
    double fibonacci38 = startPoint - 0.382 * range;
    double fibonacci50 = startPoint - 0.5 * range;
    double fibonacci61 = startPoint - 0.618 * range;
    double fibonacci78 = startPoint - 0.786 * range;

    return {
      'fibonacci38': fibonacci38,
      'fibonacci50': fibonacci50,
      'fibonacci61': fibonacci61,
      'fibonacci78': fibonacci78
    };
  }

  Map<String, dynamic> calculateSRL(
      List<double> closes, List<double> supports, List<double> resistances) {
    List<String> levels = [];
    for (int i = 0; i < closes.length; i++) {
      if (closes[i] < supports[i]) {
        levels.add('Sell');
      } else if (closes[i] > resistances[i]) {
        levels.add('Buy');
      } else {
        levels.add('NEUTRAL');
      }
    }

    return {'supportResistanceLevels': levels};
  }

  Map<String, dynamic> calculateGannLines(
      List<double> highs, List<double> lows) {
    double g1 = (highs.first + lows.first) / 2;
    double g2 = (g1 + highs.first) / 2;
    double g3 = (g2 + highs.first) / 2;
    double g4 = (g3 + highs.first) / 2;
    double g5 = (g4 + highs.first) / 2;
    double g6 = (g5 + highs.first) / 2;
    double g7 = (g6 + highs.first) / 2;

    double l1 = (lows.first + highs.first) / 2;
    double l2 = (l1 + lows.first) / 2;
    double l3 = (l2 + lows.first) / 2;
    double l4 = (l3 + lows.first) / 2;
    double l5 = (l4 + lows.first) / 2;
    double l6 = (l5 + lows.first) / 2;
    double l7 = (l6 + lows.first) / 2;

    return {
      'gannLines': [g1, g2, g3, g4, g5, g6, g7],
      'lows': [l1, l2, l3, l4, l5, l6, l7]
    };
  }

  Map<String, dynamic> calculateAndrewsPitchfork(
      List<double> highs, List<double> lows, List<double> closes) {
    double medianLine = (highs.first + lows.first) / 2;
    double upperLine = medianLine + (highs.first - lows.first) / 2;
    double lowerLine = medianLine - (highs.first - lows.first) / 2;

    return {
      'medianLine': medianLine,
      'upperLine': upperLine,
      'lowerLine': lowerLine
    };
  }

  Map<String, dynamic> calculateLatestPivots(
      List<String> dates,
      List<double> opens,
      List<double> highs,
      List<double> lows,
      List<double> closes,
      List<double> volumes) {
    Map<String, dynamic> latestPivot = {};


    if (dates.isNotEmpty) {
      int lastIndex = dates.length - 1;

      latestPivot['Date'] = dates[lastIndex];
      latestPivot['Open'] = opens[lastIndex];
      latestPivot['High'] = highs[lastIndex];
      latestPivot['Low'] = lows[lastIndex];
      latestPivot['Close'] = closes[lastIndex];
      latestPivot['Volume'] = volumes[lastIndex];

      // Calculate Classic pivot points
      latestPivot['Classic_Pivot (P)'] =
          (highs[lastIndex] + lows[lastIndex] + closes[lastIndex]) / 3;
      latestPivot['Classic_S3'] = latestPivot['Classic_Pivot (P)'] -
          2 * (highs[lastIndex] - latestPivot['Classic_Pivot (P)']);
      latestPivot['Classic_S2'] = latestPivot['Classic_Pivot (P)'] -
          (highs[lastIndex] - lows[lastIndex]);
      latestPivot['Classic_S1'] =
          2 * latestPivot['Classic_Pivot (P)'] - highs[lastIndex];
      latestPivot['Classic_R1'] =
          2 * latestPivot['Classic_Pivot (P)'] - lows[lastIndex];
      latestPivot['Classic_R2'] = latestPivot['Classic_Pivot (P)'] +
          (highs[lastIndex] - lows[lastIndex]);
      latestPivot['Classic_R3'] = latestPivot['Classic_Pivot (P)'] +
          2 * (highs[lastIndex] - latestPivot['Classic_Pivot (P)']);

      // Calculate Fibonacci pivot points
      latestPivot['Fibonacci_Pivot (P)'] =
          (highs[lastIndex] + lows[lastIndex] + closes[lastIndex]) / 3;
      latestPivot['Fibonacci_S3'] = latestPivot['Fibonacci_Pivot (P)'] -
          2 * (highs[lastIndex] - latestPivot['Fibonacci_Pivot (P)']);
      latestPivot['Fibonacci_S2'] = latestPivot['Fibonacci_Pivot (P)'] -
          (highs[lastIndex] - lows[lastIndex]) * 0.618;
      latestPivot['Fibonacci_S1'] = latestPivot['Fibonacci_Pivot (P)'] -
          (highs[lastIndex] - lows[lastIndex]) * 0.382;
      latestPivot['Fibonacci_R1'] = latestPivot['Fibonacci_Pivot (P)'] +
          (highs[lastIndex] - lows[lastIndex]) * 0.382;
      latestPivot['Fibonacci_R2'] = latestPivot['Fibonacci_Pivot (P)'] +
          (highs[lastIndex] - lows[lastIndex]) * 0.618;
      latestPivot['Fibonacci_R3'] = latestPivot['Fibonacci_Pivot (P)'] +
          2 * (highs[lastIndex] - latestPivot['Fibonacci_Pivot (P)']);

      // Calculate Camarilla pivot points
      latestPivot['Camarilla_S3'] =
          closes[lastIndex] - (0.55 * (highs[lastIndex] - lows[lastIndex]));
      latestPivot['Camarilla_S2'] =
          closes[lastIndex] - (0.72 * (highs[lastIndex] - lows[lastIndex]));
      latestPivot['Camarilla_S1'] =
          closes[lastIndex] - (1.09 * (highs[lastIndex] - lows[lastIndex]));
      latestPivot['Camarilla_Pivot (P)'] =
          (highs[lastIndex] + lows[lastIndex] + closes[lastIndex]) / 3;
      latestPivot['Camarilla_R1'] =
          closes[lastIndex] + (0.55 * (highs[lastIndex] - lows[lastIndex]));
      latestPivot['Camarilla_R2'] =
          closes[lastIndex] + (0.72 * (highs[lastIndex] - lows[lastIndex]));
      latestPivot['Camarilla_R3'] =
          closes[lastIndex] + (1.09 * (highs[lastIndex] - lows[lastIndex]));

      // Calculate Woodie pivot points
      latestPivot['Woodie_Pivot (P)'] =
          (highs[lastIndex] + lows[lastIndex] + 2 * closes[lastIndex]) / 4;
      latestPivot['Woodie_S3'] =
          (2 * latestPivot['Woodie_Pivot (P)']) - highs[lastIndex];
      latestPivot['Woodie_S2'] = latestPivot['Woodie_Pivot (P)'] -
          (highs[lastIndex] - lows[lastIndex]);
      latestPivot['Woodie_S1'] =
          (2 * latestPivot['Woodie_Pivot (P)']) - highs[lastIndex];
      latestPivot['Woodie_R1'] =
          (2 * latestPivot['Woodie_Pivot (P)']) - lows[lastIndex];
      latestPivot['Woodie_R2'] = latestPivot['Woodie_Pivot (P)'] +
          (highs[lastIndex] - lows[lastIndex]);
      latestPivot['Woodie_R3'] = latestPivot['Woodie_Pivot (P)'] +
          2 * (highs[lastIndex] - lows[lastIndex]);

      // Calculate DM pivot points
      latestPivot['DM_Pivot (P)'] =
          (2 * highs[lastIndex] + lows[lastIndex] + closes[lastIndex]) / 4;
      latestPivot['DM_S3'] =
          latestPivot['DM_Pivot (P)'] - (highs[lastIndex] - lows[lastIndex]);
      latestPivot['DM_S2'] = latestPivot['DM_Pivot (P)'] -
          2 * (highs[lastIndex] - lows[lastIndex]);
      latestPivot['DM_S1'] =
          (2 * latestPivot['DM_Pivot (P)']) - highs[lastIndex];
      latestPivot['DM_R1'] =
          latestPivot['DM_Pivot (P)'] + (highs[lastIndex] - lows[lastIndex]);
      latestPivot['DM_R2'] = latestPivot['DM_Pivot (P)'] +
          2 * (highs[lastIndex] - lows[lastIndex]);
      latestPivot['DM_R3'] =
          closes[lastIndex] + (2 * highs[lastIndex] - lows[lastIndex]);

      // Calculate Murray pivot points as Custom_Pivot
      latestPivot['Murray_Pivot (P)'] =
          (highs[lastIndex] + lows[lastIndex] + closes[lastIndex]) / 3;
      latestPivot['Murray_R1'] = latestPivot['Murray_Pivot (P)'] +
          (highs[lastIndex] - lows[lastIndex]) * 0.35;
      latestPivot['Murray_R2'] = latestPivot['Murray_Pivot (P)'] +
          (highs[lastIndex] - lows[lastIndex]) * 0.45;
      latestPivot['Murray_R3'] = latestPivot['Murray_Pivot (P)'] +
          (highs[lastIndex] - lows[lastIndex]) * 0.55;
      latestPivot['Murray_S1'] = latestPivot['Murray_Pivot (P)'] -
          (highs[lastIndex] - lows[lastIndex]) * 0.35;
      latestPivot['Murray_S2'] = latestPivot['Murray_Pivot (P)'] -
          (highs[lastIndex] - lows[lastIndex]) * 0.45;
      latestPivot['Murray_S3'] = latestPivot['Murray_Pivot (P)'] -
          (highs[lastIndex] - lows[lastIndex]) * 0.55;
    }

    return latestPivot;
  }
  // Map<String, dynamic> calculateMASupportResistance(
  //     List<double> closes, int period) {
  //   List<double> smaValues = calculateSMA(closes, period);
  //   double support = smaValues.first;
  //   double resistance = smaValues.last;

  //   return {'support': support, 'resistance': resistance};
  // }

  // List<double> calculateSMA(List<double> data, int period) {
  //   List<double> smaValues = [];
  //   for (int i = period - 1; i < data.length; i++) {
  //     double sma = data.sublist(i - period + 1, i + 1).reduce((a, b) => a + b) / period;
  //     smaValues.add(sma);
  //   }
  //   return smaValues;
  // }

  // String calculatePivotPoints(List<double> prices) {
  //   // Calculate Pivot Points logic
  //   return 'R3|R2|R1|P|S1|S2|S3';
  // }

  // String calculateFibonacciRetracement(List<double> prices) {
  //   // Calculate Fibonacci Retracement logic
  //   return 'R3|R2|R1|P|S1|S2|S3';
  // }

  // String calculateSRL(List<double> prices) {
  //   // Calculate SRL logic
  //   return 'R3|R2|R1|P|S1|S2|S3';
  // }

  // String calculateGannLines(List<double> prices) {
  //   // Calculate Gann Lines logic
  //   return 'R3|R2|R1|P|S1|S2|S3';
  // }

  // String calculateAndrewsPitchfork(List<double> prices) {
  //   // Calculate Andrews Pitchfork logic
  //   return 'R3|R2|R1|P|S1|S2|S3';
  // }

  // String calculateMASupportResistance(List<double> prices) {
  //   // Calculate MA Support/Resistance logic
  //   return 'R3|R2|R1|P|S1|S2|S3';
  // }
}

Future<void> appendDataToCSV(
    String csvFilePath, String header, String rowData) async {
  File csvFile = File(csvFilePath);

  // Check if the CSV file exists, create it if not
  if (!csvFile.existsSync()) {
    // Create the CSV file and write the header
    csvFile.createSync(recursive: true);
    IOSink csvSink = csvFile.openWrite();
    csvSink.writeln(header);
    await csvSink.close();
  }

  // Open the CSV file in append mode
  IOSink csvSink = csvFile.openWrite(mode: FileMode.append);

  // Write the row data to CSV
  csvSink.writeln(rowData);

  // Close the file
  await csvSink.close();
}

Future<void> main() async {
  print('Using sqlite3 ${sqlite3.version}');
  List<String> databases = [
    // 'Commodities_database.db',
    // 'Crypto_database.db',
    // 'ETFs_database.db',
    'Forex_database.db',
    // 'Indices_database.db',
    // 'MutualFunds_database.db',
  ];
  for (String dbName in databases) {
    final db = sqlite3.open('./${dbName}');

    final ResultSet resultSet =
        db.select("SELECT name FROM sqlite_master WHERE type='table';");

    // print(resultSet);
    for (final Row row in resultSet) {
      print('name: ${row['name']}]');
      // }

      // List<String> dates = [];
      // List<double> opens = [];
      // List<double> highs = [];
      // List<double> lows = [];
      // List<double> closes = [];
      // List<double> volumes = [];
      String interval = "D1";
      String symbol = row['name']
          .toString()
          .replaceAll('ohlcv_', "")
          .replaceAll('_D1', ""); //GBPUSDX//JPYX//EURUSDX

      final ResultSet ohlcvData = db.select(
          // "SELECT * FROM ohlcv_${symbol}_${interval} ORDER BY date ASC;");
"""
WITH ordered_data AS (
    SELECT 
        date, 
        open, 
        high, 
        low, 
        close, 
        volume, 
        LEAD(close) OVER (ORDER BY date) AS next_close 
    FROM 
        ohlcv_${symbol}_${interval}
    WHERE close IS NOT NULL
    ORDER BY 
        date DESC 
) 
SELECT 
    *, 
    CASE 
        WHEN next_close IS NULL THEN '-' 
        WHEN close < next_close THEN 'BUY' 
        WHEN close > next_close THEN 'SELL' 
        WHEN date = (SELECT MAX(date) FROM ohlcv_${symbol}_${interval}) THEN '-' 
        ELSE 'NEUTRAL' 
    END AS ShiftSignal 
FROM 
    ordered_data 
ORDER BY 
    date ASC;
""");

      int batchSize = 200;
      for (int start = 0; start < ohlcvData.length; start += batchSize) {
        int end = start + batchSize;
        if (end > ohlcvData.length) {
          end = ohlcvData.length;
        }

        List<Map<String, dynamic>> ohlcvData200 = ohlcvData.sublist(start, end);

        List<String> dates = [];
        List<double> opens = [];
        List<double> highs = [];
        List<double> lows = [];
        List<double> closes = [];
        List<double> volumes = [];
        List<String> nextclose = [];

        for (int i = 0; i < ohlcvData200.length; i++) {
          var openValue = ohlcvData200[i]['open'];
          var highValue = ohlcvData200[i]['high'];
          var lowValue = ohlcvData200[i]['low'];
          var closeValue = ohlcvData200[i]['close'];
          var volumeValue = ohlcvData200[i]['volume'];
          var nextcloseValue = ohlcvData200[i]['next_close'];

          if (closeValue != null && closeValue.toString() != 'null') {
            // Use current data if closeValue is valid
            dates.add(ohlcvData200[i]['date'].toString());
            nextclose.add(ohlcvData200[i]['next_close'].toString());
            opens.add(double.parse(openValue.toString()));
            highs.add(double.parse(highValue.toString()));
            lows.add(double.parse(lowValue.toString()));
            closes.add(double.parse(closeValue.toString()));
            volumes.add(double.parse(volumeValue.toString()));
          } else {
            // If closeValue is invalid, try [i + 1] if available
            if (i + 1 < ohlcvData200.length) {
              var nextOpenValue = ohlcvData200[i + 1]['open'];
              var nextHighValue = ohlcvData200[i + 1]['high'];
              var nextLowValue = ohlcvData200[i + 1]['low'];
              var nextCloseValue = ohlcvData200[i + 1]['close'];
              var nextVolumeValue = ohlcvData200[i + 1]['volume'];

              if (nextCloseValue != null &&
                  nextCloseValue.toString() != 'null') {
                dates.add(ohlcvData200[i]['date'].toString());
                opens.add(double.parse(nextOpenValue.toString()));
                highs.add(double.parse(nextHighValue.toString()));
                lows.add(double.parse(nextLowValue.toString()));
                closes.add(double.parse(nextCloseValue.toString()));
                volumes.add(double.parse(nextVolumeValue.toString()));
              } else {
                print('Close value is invalid for index $i and $i+1');
              }
            } else {
              print(
                  'Close value is invalid for index $i and no next index available.');
            }
          }
        }

        if (closes.length != batchSize) {
          print(
              'Skipping batch starting at index $start because closes has ${closes.length} items instead of $batchSize');
          continue; // Skip this batch
        }
        print('Batch processed: $start - ${end - 1}');
        print('Dates in this batch:');

        // final ResultSet ohlcvData200 = db
        //     .select("SELECT * FROM ohlcv_${symbol}_${interval} ORDER BY date ASC;");

        // // print(resultSet);
        // // for (final Row row in ohlcvData200) {
        // //   print('name: ${row['name']}]');
        // // }

        // for (int i = 0; i < ohlcvData200.length; i++) {
        //   var openValue = ohlcvData200[i]['open'];
        //   var highValue = ohlcvData200[i]['high'];
        //   var lowValue = ohlcvData200[i]['low'];
        //   var closeValue = ohlcvData200[i]['close'];
        //   var volumeValue = ohlcvData200[i]['volume'];
        //   if (openValue != null && openValue != 'null') {
        //     // Check for both null and string "null"
        //     try {
        //       dates.add(ohlcvData200[i]['date'].toString());
        //       opens.add(double.parse(openValue.toString()));
        //       highs.add(double.parse(highValue.toString()));
        //       lows.add(double.parse(lowValue.toString()));
        //       closes.add(double.parse(closeValue.toString()));
        //       volumes.add(double.parse(volumeValue.toString()));
        //     } catch (FormatException) {
        //       // Handle cases where openValue is not a valid number
        //       print('Invalid open value: $openValue');
        //     }
        //   }
        // }
// print(opens);
        TechnicalIndicators ti = TechnicalIndicators();
        // print("Date: ${dates[0]}");
//   // Calculate SMA
        int smaPeriod3 = 3;
        Map<String, dynamic> smaResult3 = ti.calculateSMA(closes, smaPeriod3);

        int emaPeriod7 = 7;
        Map<String, dynamic> emaResult7 = ti.calculateEMA(closes, emaPeriod7);

        int smaPeriod50 = 50;
        Map<String, dynamic> smaResult50 = ti.calculateSMA(closes, smaPeriod50);
        int smaPeriod100 = 100;
        Map<String, dynamic> smaResult100 =
            ti.calculateSMA(closes, smaPeriod100);
        int smaPeriod200 = 200;
        Map<String, dynamic> smaResult200 =
            ti.calculateSMA(closes, smaPeriod200);
        int emaPeriod50 = 50;
        Map<String, dynamic> emaResult50 = ti.calculateEMA(closes, emaPeriod50);
        int emaPeriod100 = 100;
        Map<String, dynamic> emaResult100 =
            ti.calculateEMA(closes, emaPeriod100);
        int emaPeriod200 = 200;
        Map<String, dynamic> emaResult200 =
            ti.calculateEMA(closes, emaPeriod200);

        // Calculate MACD
        int shortPeriod = 12;
        int longPeriod = 26;
        int signalPeriod = 9;
        Map<String, dynamic> macdResult =
            ti.calculateMACD(closes, shortPeriod, longPeriod, signalPeriod);
        // print('MACD Line: ${macdResult['macdLine']}, Signal Line: ${macdResult['signalLine']}, Histogram: ${macdResult['histogram']}, Signal: ${macdResult['signal']}');

// Calculate PSAR
        double accelerationFactor = 0.02;
        double maxAcceleration = 0.2;
        Map<String, dynamic> psarResult =
            ti.calculatePSAR(highs, lows, accelerationFactor, maxAcceleration);
        // print('PSAR Values: ${psarResult['psarValues'][0]}, Signal: ${psarResult['psarSignal']}');

        // Calculate Ichimoku Cloud
        int tenkanSenPeriod = 9;
        int kijunSenPeriod = 26;
        int senkouSpanBPeriod = 52;
        int chikouSpanShift = 26;
        Map<String, dynamic> ichimokuResult = ti.calculateIchimoku(
            highs,
            lows,
            closes,
            tenkanSenPeriod,
            kijunSenPeriod,
            senkouSpanBPeriod,
            chikouSpanShift);
        // print('Tenkan Sen: ${ichimokuResult['tenkanSen']}, Kijun Sen: ${ichimokuResult['kijunSen']}, Senkou Span A: ${ichimokuResult['senkouSpanA']}, Senkou Span B: ${ichimokuResult['senkouSpanB']}, Chikou Span: ${ichimokuResult['chikouSpan']}, Signal: ${ichimokuResult['ichimokuSignal']}');

        // Calculate Supertrend
        int atrPeriod = 14;
        double multiplier = 3.0;
        Map<String, dynamic> supertrendResult =
            ti.calculateSupertrend(highs, lows, closes, atrPeriod, multiplier);
        // print('Supertrend Values: ${supertrendResult['supertrendValues'][0]}, Signal: ${supertrendResult['supertrendSignal']}');

        // Calculate RSI
        int rsiPeriod = 14;
        Map<String, dynamic> rsiResult = ti.calculateRSI(closes, rsiPeriod);
        // print('RSI Value: ${rsiResult['rsiValue']}, Signal: ${rsiResult['rsiSignal']}');

        // Calculate ROC
        int rocPeriod = 5;
        Map<String, dynamic> rocResult = ti.calculateROC(closes, rocPeriod);
        // print( 'ROC Value: ${rocResult['rocValue']}, Signal: ${rocResult['rocSignal']}');

        // Calculate CMO
        int cmoPeriod = 9;
        Map<String, dynamic> cmoResult = ti.calculateCMO(closes, cmoPeriod);
        // print('CMO Value: ${cmoResult['cmoValue']}, Signal: ${cmoResult['cmoSignal']}');

// Calculate PPO
        shortPeriod = 12;
        longPeriod = 26;
        Map<String, dynamic> ppoResult =
            ti.calculatePPO(closes, shortPeriod, longPeriod);
        // print( 'PPO Value: ${ppoResult['ppoValue']}, Signal: ${ppoResult['ppoSignal']}');

        // Calculate WPR
        int wprPeriod = 14;
        Map<String, dynamic> wprResult =
            ti.calculateWPR(highs, lows, closes, wprPeriod);
        // print( 'WPR Value: ${wprResult['wprValue']}, Signal: ${wprResult['wprSignal']}');

        // Calculate RVI
        int rviPeriod = 14;
        Map<String, dynamic> rviResult =
            ti.calculateRVI(opens, highs, lows, closes, rviPeriod);
        // print('RVI Value: ${rviResult['rviValue']}, Signal: ${rviResult['rviSignal']}');

// Calculate BBANDS
        int bbandsPeriod = 20;
        double stdDevMultiplier = 2.0;
        Map<String, dynamic> bbandsResult =
            ti.calculateBBANDS(closes, bbandsPeriod, stdDevMultiplier);
        // print('BBANDS Upper Band: ${bbandsResult['upperBand']}, Middle Band: ${bbandsResult['middleBand']}, Lower Band: ${bbandsResult['lowerBand']}, Signal: ${bbandsResult['bbandsSignal']}');

        // Calculate ATR
        atrPeriod = 14;
        double atrValue = ti.calculateATRValue(highs, lows, closes, atrPeriod);
        // print('ATR Value: $atrValue');

        // Calculate STDEV
        int stdevPeriod = 20;
        Map<String, dynamic> stdevResult =
            ti.calculateSTDEV(closes, stdevPeriod);
        // print('STDEV Value: ${stdevResult['stdDevValue']}, Signal: ${stdevResult['stdDevSignal']}');

        // Calculate KC
        int kcPeriod = 20;
        double atrMultiplier = 2.0;
        Map<String, dynamic> kcResult =
            ti.calculateKC(highs, lows, closes, kcPeriod, atrMultiplier);
        // print('KC Upper Band: ${kcResult['upperKC']}, Lower Band: ${kcResult['lowerKC']}, Signal: ${kcResult['kcSignal']}');

        // Calculate Donchian
        int donchianPeriod = 20;
        Map<String, dynamic> donchianResult =
            ti.calculateDonchian(highs, lows, closes, donchianPeriod);
        // print('Donchian Upper Band: ${donchianResult['upperDonchian']}, Lower Band: ${donchianResult['lowerDonchian']}, Signal: ${donchianResult['donchianSignal']}');

        // Calculate Chandelier Exit
        int chandelierPeriod = 22;
        double chandelierMultiplier = 3.0;
        Map<String, dynamic> chandelierResult = ti.calculateChandelierExit(
            highs, lows, closes, chandelierPeriod, chandelierMultiplier);
        // print('Chandelier Long: ${chandelierResult['chandelierLong']}, Short: ${chandelierResult['chandelierShort']}, Signal: ${chandelierResult['chandelierSignal']}');

        // Calculate OBV
        Map<String, dynamic> obvResult = ti.calculateOBV(closes, volumes);
        // print('OBV Value: ${obvResult['obvValue']}, Signal: ${obvResult['obvSignal']}');

        // Calculate CMF
        int cmfPeriod = 20;
        Map<String, dynamic> cmfResult =
            ti.calculateCMF(closes, highs, lows, volumes, cmfPeriod);
        // print('CMF Value: ${cmfResult['cmfValue']}, Signal: ${cmfResult['cmfSignal']}');

        // Calculate VROC
        int vrocPeriod = 14;
        Map<String, dynamic> vrocResult =
            ti.calculateVROC(closes, volumes, vrocPeriod);
        // print('VROC Value: ${vrocResult['vrocValue']}, Signal: ${vrocResult['vrocSignal']}');

        // Calculate MFI
        int mfiPeriod = 14;
        Map<String, dynamic> mfiResult =
            ti.calculateMFI(highs, lows, closes, volumes, mfiPeriod);
        // print('MFI Value: ${mfiResult['mfiValue']}, Signal: ${mfiResult['mfiSignal']}');

        // Calculate ADL
        Map<String, dynamic> adlResult =
            ti.calculateADL(highs, lows, closes, volumes);
        // print('ADL Value: ${adlResult['adlValue']}, Signal: ${adlResult['adlSignal']}');

        // Calculate EOM
        int eomPeriod = 14;
        Map<String, dynamic> eomResult =
            ti.calculateEOM(highs, lows, closes, volumes, eomPeriod);
        // print('EOM Value: ${eomResult['eomValue']}, Signal: ${eomResult['eomSignal']}');

        // Calculate VWAP
        Map<String, dynamic> vwapResult =
            ti.calculateVWAP(highs, lows, closes, volumes);
        // print('VWAP Value: ${vwapResult['vwapValue']}, Signal: ${vwapResult['vwapSignal']}');

        // Calculate TSI
        shortPeriod = 10;
        longPeriod = 20;
        Map<String, dynamic> tsiResult =
            ti.calculateTSI(closes, shortPeriod, longPeriod);
        // print('TSI Value: ${tsiResult['tsiValue']}, Signal: ${tsiResult['tsiSignal']}');

// Calculate Stochastic
        int stochPeriod = 14;
        int kSmoothing = 3;
        int dSmoothing = 3;
        Map<String, dynamic> stochResult = ti.calculateStochastic(
            highs, lows, closes, stochPeriod, kSmoothing, dSmoothing);
        // print('Stochastic K Line: ${stochResult['kLine']}, D Line: ${stochResult['dLine']}, Signal: ${stochResult['stochasticSignal']}');

        // Calculate Awesome Oscillator
        int aoShortPeriod = 5;
        int aoLongPeriod = 34;
        Map<String, dynamic> aoResult = ti.calculateAwesomeOscillator(
            highs, lows, aoShortPeriod, aoLongPeriod);
        // print('Awesome Oscillator: ${aoResult['awesomeOscillator']}, Signal: ${aoResult['awesomeOscillatorSignal']}');

        // Calculate DPO
        int dpoPeriod = 20;
        Map<String, dynamic> dpoResult = ti.calculateDPO(closes, dpoPeriod);
        // print('DPO Value: ${dpoResult['dpoValue']}, Signal: ${dpoResult['dpoSignal']}');

        // Calculate CCI
        int cciPeriod = 20;
        Map<String, dynamic> cciResult =
            ti.calculateCCI(highs, lows, closes, cciPeriod);
        // print('CCI Value: ${cciResult['cciValue']}, Signal: ${cciResult['cciSignal']}');

// Calculate Pivot Points
        // Map<String, dynamic> pivotResult =
        //     ti.calculatePivotPoints(highs, lows, closes);
        // print(
        //     'Pivot Point: ${pivotResult['pivotPoint']}, R1: ${pivotResult['r1']}, R2: ${pivotResult['r2']}, R3: ${pivotResult['r3']}, S1: ${pivotResult['s1']}, S2: ${pivotResult['s2']}, S3: ${pivotResult['s3']}');

//   // Calculate Fibonacci Retracement
//   // Map<String, dynamic> fibResult =
//   //     ti.calculateFibonacciRetracement(highs, lows, startPoint, endPoint);
//   // print(
//   //     'Fibonacci 38%: ${fibResult['fibonacci38']}, 50%: ${fibResult['fibonacci50']}, 61%: ${fibResult['fibonacci61']}, 78%: ${fibResult['fibonacci78']}');

//   // Calculate SRL
//   // Map<String, dynamic> srlResult =
//   //     ti.calculateSRL(closes, supports, resistances);
//   // print('Support/Resistance Levels: ${srlResult['supportResistanceLevels']}');

//   // Calculate Gann Lines
//   Map<String, dynamic> gannResult = ti.calculateGannLines(highs, lows);
//   print('Gann Lines: ${gannResult['gannLines']}, Lows: ${gannResult['lows']}');

//   // Calculate Andrews Pitchfork
//   Map<String, dynamic> pitchforkResult =
//       ti.calculateAndrewsPitchfork(highs, lows, closes);
//   print(
//       'Andrews Pitchfork - Median Line: ${pitchforkResult['medianLine']}, Upper Line: ${pitchforkResult['upperLine']}, Lower Line: ${pitchforkResult['lowerLine']}');

        Map<String, dynamic> latestPivots = ti.calculateLatestPivots(
            dates, opens, highs, lows, closes, volumes);

        String data = """
Please analyze the provided technical data and generate a trading signal recommendation. Structure your response according to the following JSON format:

{
  "symbol": "string", // Enter the ticker symbol e.g., "NQ=F"
  "timestamp": "ISO 8601 format", // Indicate the date and time of the signal generation
  "signal": "string", // Specify the key signal type e.g., "buy", "sell", "hold", "monitor"
  "strategy": "string",  // Describe the strategy that led to the signal
  "summary": { 
    // Provide detailed summary with technical indicator values used in decision-making 
  },
  "price_data": {
    "open": "number",
    "high": "number",
    "low": "number",
    "close": "number",
    "volume": "number"
  },
  "targets": {
    "entry": "number", // Optional: suggested entry price
    "take_profit": "number", // Optional: target for profit-taking
    "stop_loss": "number" // Optional: stop-loss level
  },
  "confidence": "number" // Optional: a value e.g., 0-1 representing signal strength
}

You can pick a strategy from the stratgies below:

{
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

Please utilize the provided technical analysis data to derive a trading signal for the specified instrument.
""";
        data += 
        """
# ${symbol} Technical Analysis
## Category : ${dbName.replaceAll('_database.db', '')}

**Timeframe:** ${interval}\n
""";

        data += """

| Trend               |  |  Momentum               |
|---------------------|--|-------------------------|
| Indicator Name                   | ${interval} |        | Indicator Name                   | ${interval} |
|----------------------------------|-----------------|--------|----------------------------------|-----------------|
| Simple Moving Average (3)        | ${smaResult3['value'].toStringAsFixed(4)} (${smaResult3['sma3Signal']})    |        | Relative Strength Index (14)     | ${rsiResult['rsiValue'].toStringAsFixed(4)} (${rsiResult['rsiSignal']})    |
| Exponential Moving Average (7)   | ${emaResult7['value'].toStringAsFixed(4)} (${emaResult7['ema7Signal']})    |        | Price Rate of Change(5)          | ${rocResult['rocValue'].toStringAsFixed(4)} (${rocResult['rocSignal']})    |
| MACD (9, 12, 26)                 | ${macdResult['signalLine'].toStringAsFixed(4)} (${macdResult['mcadSignal']})    |        | Chande Momentum Oscillator (9)   | ${cmoResult['cmoValue'].toStringAsFixed(4)} (${cmoResult['cmoSignal']})    |
| PSAR                              | ${psarResult['psarValues'][0].toStringAsFixed(4)} (${psarResult['psarSignal']})    |        | Percentage Price Oscillator (12,26) | ${ppoResult['ppoValue'].toStringAsFixed(4)} (${ppoResult['ppoSignal']})    |
| Ichimoku (9,26,52)               | Chikou Span: ${ichimokuResult['chikouSpan'].toStringAsFixed(4)}, (${ichimokuResult['ichimokuSignal']})  |        | Williams %R (14)                   | ${wprResult['wprValue'].toStringAsFixed(4)} (${wprResult['wprSignal']})  |
| Supertrend (14)                  | ${supertrendResult['supertrendValues'][0].toStringAsFixed(4)} (${supertrendResult['supertrendSignal']})      |        | Relative Vigor Index (14)         | ${rviResult['rviValue'].toStringAsFixed(4)} (${rviResult['rviSignal']})      |

| Volatility               |  |  Volume               |
|---------------------|--|-------------------------|
| Indicator Name                   | ${interval} |        | Indicator Name                   | ${interval}  |
|----------------------------------|-----------------|--------|----------------------------------|-----------------|
| BBANDS (20)                      | BBANDS Upper Band: ${bbandsResult['upperBand'].toStringAsFixed(4)}, Middle Band: ${bbandsResult['middleBand'].toStringAsFixed(4)}, Lower Band: ${bbandsResult['lowerBand'].toStringAsFixed(4)} ( ${bbandsResult['bbandsSignal']})    |        | OBV                          | ${obvResult['obvValue'].toStringAsFixed(4)} (${obvResult['obvSignal']})    |
| ATR (14)                         | ${atrValue.toStringAsFixed(8)}    |        | CMF (20)                         | ${cmfResult['cmfValue'].toStringAsFixed(4)} (${cmfResult['cmfSignal']})    |
| STDEV (20)                       | ${stdevResult['stdDevValue'].toStringAsFixed(4)} (${stdevResult['stdDevSignal']})    |        | VROC (14)                       | ${vrocResult['vrocValue'].toStringAsFixed(4)} (${vrocResult['vrocSignal']})    |
| KC (20)                          | KC Upper Band: ${kcResult['upperKC'].toStringAsFixed(4)}, Lower Band: ${kcResult['lowerKC'].toStringAsFixed(4)} (${kcResult['kcSignal']})    |        | MFI (14)                        | ${mfiResult['mfiValue'].toStringAsFixed(4)} (${mfiResult['mfiSignal']})    |
| Donchian (20)                    | Donchian Upper Band: ${donchianResult['upperDonchian'].toStringAsFixed(4)}, Lower Band: ${donchianResult['lowerDonchian'].toStringAsFixed(4)} (${donchianResult['donchianSignal']})  |        | ADL                              | ${adlResult['adlValue'].toStringAsFixed(4)} (${adlResult['adlSignal']})  |
| Chandelier (22)                  | Long: ${chandelierResult['chandelierLong'].toStringAsFixed(4)}, Short: ${chandelierResult['chandelierShort'].toStringAsFixed(4)} (${chandelierResult['chandelierSignal']})      |        | EOM (14)                        | ${eomResult['eomValue'].toStringAsFixed(4)} (${eomResult['eomSignal']})      |

| Oscillator               |  |  Moving Averages               |
|---------------------|--|-------------------------|
| Indicator Name                   | ${interval} |        | Indicator Name                   | ${interval} |
|----------------------------------|-----------------|--------|----------------------------------|-----------------|
| VWAP (14)                        | ${vwapResult['vwapValue'].toStringAsFixed(4)} (${vwapResult['vwapSignal']})    |        | Simple Moving Average (50)       | ${smaResult50['value'].toStringAsFixed(4)} (${smaResult50['sma50Signal']})    |
| TSI (10, 10)                     | ${tsiResult['tsiValue'].toStringAsFixed(4)} (${tsiResult['tsiSignal']})    |        | Simple Moving Average (100)      | ${smaResult100['value'].toStringAsFixed(4)} (${smaResult100['sma100Signal']})    |
| Stochastic (14, 3, 3)            | Stochastic K Line: ${stochResult['kLine'].toStringAsFixed(4)}, D Line: ${stochResult['dLine'].toStringAsFixed(4)} (${stochResult['stochasticSignal']})    |        | Simple Moving Average (200)      | ${smaResult200['value'].toStringAsFixed(4)} (${smaResult200['sma200Signal']})    |
| DPO (20)                         | ${dpoResult['dpoValue'].toStringAsFixed(4)} (${dpoResult['dpoSignal']})    |        | Exponential Moving Average (50)  | ${emaResult50['value'].toStringAsFixed(4)} (${emaResult50['ema50Signal']})    |
| Awesome Oscillator (5,34)        | ${aoResult['awesomeOscillator'].toStringAsFixed(4)} (${aoResult['awesomeOscillatorSignal']})  |        | Exponential Moving Average (100) | ${emaResult100['value'].toStringAsFixed(4)} (${emaResult100['ema100Signal']})  |
| CCI (20)                         | ${cciResult['cciValue'].toStringAsFixed(4)} (${cciResult['cciSignal']})      |        | Exponential Moving Average (200) | ${emaResult200['value'].toStringAsFixed(4)} (${emaResult200['ema200Signal']})      |

## Pivots

Date: ${latestPivots['Date']}
Open: ${latestPivots['Open']}
High: ${latestPivots['High']}
Low: ${latestPivots['Low']}
Close: ${latestPivots['Close']}
Volume: ${latestPivots['Volume']}

| Pivot         | Classic | Fibonacci | Camarilla | Woodie | DM      | Murray  |
|---------------|---------|-----------|-----------|--------|---------|---------|
| S3            | ${latestPivots['Classic_S3'].toStringAsFixed(4)}   | ${latestPivots['Fibonacci_S3'].toStringAsFixed(4)}     | ${latestPivots['Camarilla_S3'].toStringAsFixed(4)}     | ${latestPivots['Woodie_S3'].toStringAsFixed(4)}  | ${latestPivots['DM_S3'].toStringAsFixed(4)}       | ${latestPivots['Murray_S3'].toStringAsFixed(4)}   |
| S2            | ${latestPivots['Classic_S2'].toStringAsFixed(4)}    | ${latestPivots['Fibonacci_S2'].toStringAsFixed(4)}     | ${latestPivots['Camarilla_S2'].toStringAsFixed(4)}     | ${latestPivots['Woodie_S2'].toStringAsFixed(4)}  | ${latestPivots['DM_S2'].toStringAsFixed(4)}      | ${latestPivots['Murray_S2'].toStringAsFixed(4)}   |
| S1            | ${latestPivots['Classic_S1'].toStringAsFixed(4)}    | ${latestPivots['Fibonacci_S1'].toStringAsFixed(4)}     | ${latestPivots['Camarilla_S1'].toStringAsFixed(4)}     | ${latestPivots['Woodie_S1'].toStringAsFixed(4)}  | ${latestPivots['DM_S1'].toStringAsFixed(4)}   | ${latestPivots['Murray_S1'].toStringAsFixed(4)}   |
| Pivot (P)     | ${latestPivots['Classic_Pivot (P)'].toStringAsFixed(4)}   | ${latestPivots['Fibonacci_Pivot (P)'].toStringAsFixed(4)}     | ${latestPivots['Camarilla_Pivot (P)'].toStringAsFixed(4)}     | ${latestPivots['Woodie_Pivot (P)'].toStringAsFixed(4)}  | ${latestPivots['DM_Pivot (P)'].toStringAsFixed(4)}   | ${latestPivots['Murray_Pivot (P)'].toStringAsFixed(4)}   |
| R1            | ${latestPivots['Classic_R1'].toStringAsFixed(4)}    | ${latestPivots['Fibonacci_R1'].toStringAsFixed(4)}     | ${latestPivots['Camarilla_R1'].toStringAsFixed(4)}     | ${latestPivots['Woodie_R1'].toStringAsFixed(4)}  | ${latestPivots['DM_R1'].toStringAsFixed(4)}   | ${latestPivots['Murray_R1'].toStringAsFixed(4)}   |
| R2            | ${latestPivots['Classic_R2'].toStringAsFixed(4)}    | ${latestPivots['Fibonacci_R2'].toStringAsFixed(4)}     | ${latestPivots['Camarilla_R2'].toStringAsFixed(4)}     | ${latestPivots['Woodie_R2'].toStringAsFixed(4)}  | ${latestPivots['DM_R2'].toStringAsFixed(4)}      | ${latestPivots['Murray_R2'].toStringAsFixed(4)}   |
| R3            | ${latestPivots['Classic_R3'].toStringAsFixed(4)}    | ${latestPivots['Fibonacci_R3'].toStringAsFixed(4)}     | ${latestPivots['Camarilla_R3'].toStringAsFixed(4)}     | ${latestPivots['Woodie_R3'].toStringAsFixed(4)}  | ${latestPivots['DM_R3'].toStringAsFixed(4)}       | ${latestPivots['Murray_R3'].toStringAsFixed(4)}   |
""";

        // print(data);

        final indicators = {
          smaResult3,
          emaResult7,
          smaResult50,
          smaResult100,
          smaResult200,
          emaResult50,
          emaResult100,
          emaResult200,
          macdResult,
          psarResult,
          ichimokuResult,
          supertrendResult,
          rsiResult,
          rocResult,
          cmoResult,
          ppoResult,
          wprResult,
          rviResult,
          bbandsResult,
          stdevResult,
          kcResult,
          donchianResult,
          chandelierResult,
          obvResult,
          cmfResult,
          vrocResult,
          mfiResult,
          adlResult,
          eomResult,
          vwapResult,
          tsiResult,
          stochResult,
          aoResult,
          dpoResult,
          cciResult,
          // latestPivots
        };

        int buyCount = 0;
        int sellCount = 0;
        int neutralCount = 0;
        final buyIndicators = {};
        final sellIndicators = {};
        final neutralIndicators = {};
        for (var entry in indicators) {
          // Get the last item from the dictionary
          var lastItem = entry.entries.last;
          // Extract the signal value
          var signal = lastItem.value;
          // Increment the corresponding count variable based on the signal value
          if (signal == 'BUY') {
            buyCount++;
            buyIndicators.addEntries(entry.entries);
          } else if (signal == 'SELL') {
            sellCount++;
            sellIndicators.addEntries(entry.entries);
          } else if (signal == 'NEUTRAL') {
            neutralCount++;
            neutralIndicators.addEntries(entry.entries);
          }
        }

        print('BUY count: $buyCount');
        print('SELL count: $sellCount');
        print('NEUTRAL count: $neutralCount');
        String overallSentiment;
        String overallIndicators;
        int highestCount = [buyCount, sellCount, neutralCount]
            .reduce((value, element) => value > element ? value : element);

        Map<String, dynamic> neutrals = {};
        Map<String, dynamic> buys = {};
        Map<String, dynamic> sells = {};
        // dynamic neutrals;
        for (var element in neutralIndicators.entries) {
          if (element.key.contains("Signal")) {
            String key = element.key.toString().replaceAll('Signal', '');
            neutrals[key] = element.value; // Add key-value pair to the Map
          }
        }
        // dynamic buys;
        for (var element in buyIndicators.entries) {
          if (element.key.contains("Signal")) {
            String key = element.key.toString().replaceAll('Signal', '');
            buys[key] = element.value; // Add key-value pair to the Map
          }
        }
        // dynamic sells;
        for (var element in sellIndicators.entries) {
          if (element.key.contains("Signal")) {
            String key = element.key.toString().replaceAll('Signal', '');
            sells[key] = element.value; // Add key-value pair to the Map
          }
        }
        // Determine overall sentiment
        if (highestCount == neutralCount) {
          overallSentiment = "Neutral";

          print(neutralIndicators.toString());
        } else if (highestCount == buyCount) {
          overallSentiment = "Buy";
          overallIndicators = buyIndicators.toString();
        } else {
          overallSentiment = "Sell";
          overallIndicators = sellIndicators.toString();
        }

// Calculate confidence based on counts
        double confidence;
        if (overallSentiment == " Neutral") {
          confidence =
              1.0 - (highestCount / (buyCount + sellCount + neutralCount));
        } else {
          confidence = highestCount / (buyCount + sellCount + neutralCount);
        }
// Print the summary
        // print("# Summary");
        // print("Overall: $overallSentiment");
        // print(overallIndicators);

        List<String> selectedIndicators;
        if (overallSentiment == "Buy") {
          selectedIndicators = buys.keys.toList();
        } else if (overallSentiment == "Sell") {
          selectedIndicators = sells.keys.toList();
        } else {
          selectedIndicators = neutrals.keys.toList();
        }

// Format the indicators
        String formattedIndicators = selectedIndicators.join(', ');

        // print(buys.keys.toList().join(', '));
        // print(sells.keys.toList().join(', '));
        // print(neutrals.keys.toList().join(', '));

        final indicatorStrategyMap = {
          "BreakoutTradingStrategy": [
            "cmo",
            "ppo",
            "awesomeOscillator",
            "supertrend",
            "sma3",
            "ema7"
          ],
          "DiversificationStrategy": ["macd", "sma200", "sma100"],
          "DollarCostAveragingStrategy": ["macd", "ema50", "ema100"],
          "FundamentalAnalysisStrategy": [
            "rvi",
            "stdDev",
            "tsi",
            "obv",
            "vroc"
          ],
          "MomentumInvestingStrategy": [
            "cmo",
            "ppo",
            "awesomeOscillator",
            "roc",
            "rsi",
            "tsi",
            "adl",
            "eom",
            "macd"
          ],
          "MovingAverageCrossoverStrategy": [
            "rsi",
            "stochastic",
            "cci",
            "supertrend",
            "ichimoku",
            "sma50",
            "ema200"
          ],
          "RSIStrategy": ["rsi", "stochastic"],
          "ScalpingStrategy": [
            "cmo",
            "ppo",
            "awesomeOscillator",
            "rsi",
            "vwap"
          ],
          "TrendFollowingStrategy": [
            "supertrend",
            "ichimoku",
            "psar",
            "bbands",
            "kc",
            "donchian",
            "adl",
            "macd"
          ],
          "ValueInvestingStrategy": [
            "rsi",
            "rvi",
            "stdDev",
            "tsi",
            "obv",
            "vroc"
          ]
        };

        List<Map<String, dynamic>> pivotStrategyList = [
          {
            "pivot": "Classic",
            "strategies": [
              "BreakoutTradingStrategy",
              "DollarCostAveragingStrategy",
              "ValueInvestingStrategy"
            ]
          },
          {
            "pivot": "Fibonacci",
            "strategies": [
              "TrendFollowingStrategy",
              "MomentumInvestingStrategy",
              "FundamentalAnalysisStrategy"
            ]
          },
          {
            "pivot": "Camarilla",
            "strategies": [
              "DiversificationStrategy",
              "MomentumInvestingStrategy"
            ]
          },
          {
            "pivot": "Woodie",
            "strategies": ["MovingAverageCrossoverStrategy", "ScalpingStrategy"]
          },
          {
            "pivot": "DM",
            "strategies": [
              "MomentumInvestingStrategy",
              "TrendFollowingStrategy"
            ]
          },
          {
            "pivot": "Murray",
            "strategies": [
              "BreakoutTradingStrategy",
              "TrendFollowingStrategy",
              "ValueInvestingStrategy"
            ]
          }
        ];

// Reverse the indicator-strategy mapping
        Map<String, List<String>> strategyIndicatorMap = {};
        for (var strategyName in indicatorStrategyMap.keys) {
          List<String> indicators = indicatorStrategyMap[strategyName]!;
          for (var indicator in indicators) {
            if (strategyIndicatorMap.containsKey(indicator)) {
              strategyIndicatorMap[indicator]!.add(strategyName);
            } else {
              strategyIndicatorMap[indicator] = [strategyName];
            }
          }
        }

// Initialize lists for results
        List<String> matchingStrategiesDirect = [];
        List<String> matchingStrategiesReverse = [];

// Direct matching method
        for (var indicator in selectedIndicators) {
          if (indicatorStrategyMap.containsKey(indicator)) {
            matchingStrategiesDirect.addAll(indicatorStrategyMap[indicator]!);
          }
        }

// Reverse mapping method
        for (var indicator in selectedIndicators) {
          if (strategyIndicatorMap.containsKey(indicator)) {
            matchingStrategiesReverse.addAll(strategyIndicatorMap[indicator]!);
          }
        }

// Compare the results
        bool resultsMatch = matchingStrategiesDirect
                .toSet()
                .containsAll(matchingStrategiesReverse.toSet()) &&
            matchingStrategiesReverse
                .toSet()
                .containsAll(matchingStrategiesDirect.toSet());

        // if (resultsMatch) {
        //   print('Results from both methods match:');
        //   print('Direct Method Results: $matchingStrategiesDirect');
        //   print('Reverse Method Results: $matchingStrategiesReverse');
        // } else {
        //   print('Results from both methods do not match.');
        //   print('Direct Method Results: $matchingStrategiesDirect');
        //   print('Reverse Method Results: $matchingStrategiesReverse');
        // }

// Initialize a map to count the occurrences of each strategy
        Map<String, int> strategyCountMap = {};
        Map<String, int> strategyCountMap2 = {};

// Count occurrences of each strategy from the direct matching method
        for (var strategy in matchingStrategiesDirect) {
          strategyCountMap[strategy] = (strategyCountMap[strategy] ?? 0) + 1;
        }

// Count occurrences of each strategy from the reverse mapping method
        for (var strategy in matchingStrategiesReverse) {
          strategyCountMap2[strategy] = (strategyCountMap[strategy] ?? 0) + 1;
        }

// Find the strategy with the highest occurrence count (majority vote)
        String? majorityStrategy;
        int maxCount = 0;
        strategyCountMap.forEach((strategy, count) {
          if (count > maxCount) {
            majorityStrategy = strategy;
            maxCount = count;
          }
        });

        // print('--- 1 Strategy ---');
        // print('Majority Strategy: $majorityStrategy');
        // print('Count: $maxCount');

// Find the strategy with the highest occurrence count (majority vote)
        // majorityStrategy = "";
        // maxCount = 0;
        strategyCountMap2.forEach((strategy, count) {
          if (count > maxCount) {
            majorityStrategy = strategy;
            maxCount = count;
          }
        });

        // print('--- 2 Strategy ---');
        // print('Majority Strategy: $majorityStrategy');
        // print('Count: $maxCount');

        String getPivotFromStrategy(String majorityStrategy,
            List<Map<String, dynamic>> pivotStrategyList) {
          for (var pivotStrategy in pivotStrategyList) {
            List<String> strategies = pivotStrategy['strategies'];
            if (strategies.contains(majorityStrategy)) {
              return pivotStrategy['pivot'];
            }
          }
          return ''; // Return an empty string or handle the case where the strategy is not found
        }

        String pivot =
            getPivotFromStrategy(majorityStrategy!, pivotStrategyList);
        // // print('Pivot for $majorityStrategy is $pivot');
        String tp1, sl1, cmt = "";
        if (overallSentiment == "Sell") {
          tp1 = latestPivots[pivot + '_S2'].toStringAsFixed(4);
          sl1 = latestPivots[pivot + '_R1'].toStringAsFixed(4);
          cmt =
              "If S2 is reached, move SL up to break-even or to the previous swing high. Consider a second TP target at S3 or lower.";
        } else if (overallSentiment == "Buy") {
          tp1 = latestPivots[pivot + '_R2'].toStringAsFixed(4);
          sl1 = latestPivots[pivot + '_S1'].toStringAsFixed(4);
          cmt =
              "If R2 is reached, move SL up to break-even or to the previous swing low. Consider a second TP target at R3 or higher.";
        } else {
          tp1 = '0.00';
          sl1 = '0.00';
        }
        String output = """
{
  "symbol": "${symbol}",
  "timestamp": "${latestPivots['Date']}",
  "signal": "$overallSentiment",
  "strategy": "$majorityStrategy",
  "indicators": {
    ${formattedIndicators}
  },
  "price_data": {
    "open": ${latestPivots['Open']},
    "high": ${latestPivots['High']},
    "low": ${latestPivots['Low']},
    "close": ${latestPivots['Close']},
    "volume": ${latestPivots['Volume']}
  },
  "targets": {
    "entry": ${latestPivots['Close']}, 
    "take_profit": ${tp1.toString()},
    "stop_loss": ${sl1.toString()},
    "comment": "${cmt}"
  },
  "confidence": ${confidence} 
}
""";

        List<Map<String, String>> data_row = [
          {"input": data, "output": output},
          // Add more input-output pairs as needed
        ];

        // Define CSV file path
        String csvFilePath = 'forex_small_data.txt';
        String jsonFilePath = 'forex_small_data.json';

        // Write data to CSV file
        // Check if the CSV file exists
        File csvFile = File(csvFilePath);
        File jsonFile = File(jsonFilePath);
        bool fileExists = csvFile.existsSync();
        fileExists = jsonFile.existsSync();

        // if (!fileExists) {
        //   // If the file doesn't exist, write the header
        //   csvFile.writeAsStringSync('input,output\n');
        // }

        for (var pair in data_row) {
          csvFile.writeAsStringSync(
              '<|user|>${pair["input"]}<|end|>\n<|assistant|>${pair["output"]}<|end|>',
              mode: FileMode.append); // Write data row
        }

        for (var pair in data_row) {
          jsonFile.writeAsStringSync(
              // '{"${pair["input"]}": "${pair["output"]}"}',
              '{"""${pair["input"]}""":```${pair["output"]}```}',
              mode: FileMode.append); // Write data row
        }

        print('CSV file created with data successfully!');
      }
    }
  }
}
// # TODO UPDATE TO THESE - old list has duplicates
// # trend_indicators = ['SMA', 'EMA', 'MACD', 'PSAR', 'ICHIMOKU', 'SUPERTREND']
// # momentum_indicators = ['RSI', 'ROC', 'CMO', 'PPO', 'WPR', 'RVI']
// # volatility_indicators = ['BBANDS', 'ATR', 'STDEV', 'KC', 'Donchian', 'Chandelier_Exit']
// # volume_indicators = ['OBV', 'CMF', 'VROC', 'MFI', 'ADL', 'EOM']
// # support_resistance_indicators = ['Pivot_Points', 'Fibonacci_Retracement', 'SRL', 'Gann_Lines', 'Andrews_Pitchfork', 'MA_Support_Resistance']
// # oscillator_indicators = ['VWAP', 'TSI', 'Stochastic', 'Awesome_Oscillator', 'DPO', 'CCI']
