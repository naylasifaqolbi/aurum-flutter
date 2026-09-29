import 'package:flutter/foundation.dart';

import '../models/pivot_calculator_model.dart';
import '../services/historical_api_service.dart';
import 'history_viewmodel.dart';

class PivotCalculatorViewModel extends ChangeNotifier {
  final HistoryViewModel historyViewModel;

  PivotCalculatorViewModel({required this.historyViewModel});

  // ============================================================
  // STATE HISTORICAL
  // ============================================================

  bool _isLoadingHistorical = true;

  bool get isLoadingHistorical => _isLoadingHistorical;

  // ============================================================
  // DATA HISTORICAL
  // ============================================================

  String _historicalHigh = '';
  String _historicalLow = '';
  String _historicalClose = '';

  String get historicalHigh => _historicalHigh;

  String get historicalLow => _historicalLow;

  String get historicalClose => _historicalClose;

  // ============================================================
  // LOAD DATA HISTORICAL TERBARU
  // ============================================================

  Future<void> loadLatestHistoricalData() async {
    _isLoadingHistorical = true;
    notifyListeners();

    try {
      final result = await HistoricalApiService.getHistoricalData(
        category: HistoricalApiService.defaultCategory,
        page: 1,
        limit: 10,
      );

      final dynamic rawData = result['data'];

      if (rawData is List && rawData.isNotEmpty) {
        final latest = rawData.first;

        _historicalHigh = latest['high']?.toString() ?? '';

        _historicalLow = latest['low']?.toString() ?? '';

        _historicalClose = latest['close']?.toString() ?? '';
      }
    } catch (_) {
      // Jika gagal mengambil historical data,
      // user tetap bisa mengisi kalkulator secara manual.
    } finally {
      _isLoadingHistorical = false;
      notifyListeners();
    }
  }

  // ============================================================
  // HITUNG PIVOT
  // ============================================================

  Future<PivotCalculatorModel?> hitung({
    required double open,
    required double high,
    required double low,
    required double close,
  }) async {
    try {
      // ==========================================================
      // PIVOT POINT
      //
      // PP = (High + Low + Close) / 3
      // ==========================================================

      final double pp = (high + low + close) / 3;

      // ==========================================================
      // RANGE
      // ==========================================================

      final double range = high - low;

      // ==========================================================
      // RESISTANCE
      // ==========================================================

      // R4
      // PP + (High - Low) x 3
      final double r4 = pp + (range * 3);

      // R3
      // PP + (High - Low) x 2
      final double r3 = pp + (range * 2);

      // R2
      // PP + (High - Low)
      final double r2 = pp + range;

      // R1
      // 2 x PP - Low
      final double r1 = (2 * pp) - low;

      // ==========================================================
      // SUPPORT
      // ==========================================================

      // S1
      // 2 x PP - High
      final double s1 = (2 * pp) - high;

      // S2
      // PP - (High - Low)
      final double s2 = pp - range;

      // S3
      // PP - (High - Low) x 2
      final double s3 = pp - (range * 2);

      // S4
      // PP - (High - Low) x 3
      final double s4 = pp - (range * 3);

      // ==========================================================
      // MIDPOINT RESISTANCE
      // ==========================================================

      // Midpoint R4 - R3
      final double midpointR4R3 = (r4 + r3) / 2;

      // Midpoint R3 - R2
      final double midpointR3R2 = (r3 + r2) / 2;

      // Midpoint R2 - R1
      final double midpointR2R1 = (r2 + r1) / 2;

      // Midpoint PP - R1
      final double midpointPPR1 = (pp + r1) / 2;

      // ==========================================================
      // MIDPOINT SUPPORT
      // ==========================================================

      // Midpoint PP - S1
      final double midpointPPS1 = (pp + s1) / 2;

      // Midpoint S1 - S2
      final double midpointS1S2 = (s1 + s2) / 2;

      // Midpoint S2 - S3
      final double midpointS2S3 = (s2 + s3) / 2;

      // Midpoint S3 - S4
      final double midpointS3S4 = (s3 + s4) / 2;

      // ==========================================================
      // INDIKASI
      // ==========================================================

      final String indication = open < pp ? 'BUY' : 'SELL';

      // ==========================================================
      // SIMPAN HISTORY
      // ==========================================================

      final historySaved = await historyViewModel.saveHistory(
        calculatorType: 'pivot_gold',
        inputData: {'open': open, 'high': high, 'low': low, 'close': close},
        resultData: {
          'pp': pp,

          'r1': r1,
          'r2': r2,
          'r3': r3,
          'r4': r4,

          's1': s1,
          's2': s2,
          's3': s3,
          's4': s4,

          'midpoint_r4_r3': midpointR4R3,

          'midpoint_r3_r2': midpointR3R2,

          'midpoint_r2_r1': midpointR2R1,

          'midpoint_pp_r1': midpointPPR1,

          'midpoint_pp_s1': midpointPPS1,

          'midpoint_s1_s2': midpointS1S2,

          'midpoint_s2_s3': midpointS2S3,

          'midpoint_s3_s4': midpointS3S4,

          'indication': indication,
        },
      );

      if (!historySaved) {
        return null;
      }

      // ==========================================================
      // MODEL HASIL
      // ==========================================================

      return PivotCalculatorModel(
        open: open,
        high: high,
        low: low,
        close: close,
        pp: pp,
        r1: r1,
        r2: r2,
        r3: r3,
        r4: r4,
        s1: s1,
        s2: s2,
        s3: s3,
        s4: s4,
        midpointR4R3: midpointR4R3,
        midpointR3R2: midpointR3R2,
        midpointR2R1: midpointR2R1,
        midpointPPR1: midpointPPR1,
        midpointPPS1: midpointPPS1,
        midpointS1S2: midpointS1S2,
        midpointS2S3: midpointS2S3,
        midpointS3S4: midpointS3S4,
        indication: indication,
      );
    } catch (_) {
      return null;
    }
  }
}
