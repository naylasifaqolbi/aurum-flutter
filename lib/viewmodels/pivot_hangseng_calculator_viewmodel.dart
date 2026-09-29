import 'package:flutter/foundation.dart';

import '../models/pivot_hangseng_calculator_model.dart';
import '../services/historical_api_service.dart';
import 'history_viewmodel.dart';

class PivotHangsengCalculatorViewModel extends ChangeNotifier {
  final HistoryViewModel historyViewModel;

  PivotHangsengCalculatorViewModel({required this.historyViewModel});

  // ============================================================
  // STATUS LOADING HISTORICAL
  // ============================================================

  bool _isLoadingHistorical = true;

  bool get isLoadingHistorical => _isLoadingHistorical;

  // ============================================================
  // LOAD DATA HISTORICAL TERBARU
  // ============================================================

  Future<Map<String, String>?> loadLatestHistoricalData() async {
    try {
      final result = await HistoricalApiService.getHistoricalData(
        category: 'HSI Daily',
        page: 1,
        limit: 10,
      );

      final dynamic rawData = result['data'];

      if (rawData is List && rawData.isNotEmpty) {
        final dynamic latest = rawData.first;

        _isLoadingHistorical = false;
        notifyListeners();

        return {
          'high': latest['high']?.toString() ?? '',
          'low': latest['low']?.toString() ?? '',
          'close': latest['close']?.toString() ?? '',
        };
      }

      _isLoadingHistorical = false;
      notifyListeners();

      return null;
    } catch (_) {
      _isLoadingHistorical = false;
      notifyListeners();

      // Jika historical gagal dimuat,
      // pengguna tetap dapat mengisi semua data secara manual.
      return null;
    }
  }

  // ============================================================
  // HITUNG PIVOT HANGSENG + SIMPAN HISTORY
  // ============================================================

  Future<PivotHangsengCalculatorModel?> hitungDanSimpan({
    required double open,
    required double high,
    required double low,
    required double close,
  }) async {
    // ==========================================================
    // PIVOT POINT
    //
    // PP = (High + Low + Close) / 3
    // ==========================================================

    final double pp = (high + low + close) / 3;

    // ==========================================================
    // RANGE
    //
    // Range = High - Low
    // ==========================================================

    final double range = high - low;

    // ==========================================================
    // RESISTANCE
    // ==========================================================

    // R1 = 2 x PP - Low
    final double r1 = (2 * pp) - low;

    // R2 = PP + Range
    final double r2 = pp + range;

    // R3 = PP + Range x 2
    final double r3 = pp + (range * 2);

    // R4 = PP + Range x 3
    final double r4 = pp + (range * 3);

    // ==========================================================
    // SUPPORT
    // ==========================================================

    // S1 = 2 x PP - High
    final double s1 = (2 * pp) - high;

    // S2 = PP - Range
    final double s2 = pp - range;

    // S3 = PP - Range x 2
    final double s3 = pp - (range * 2);

    // S4 = PP - Range x 3
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
    // INDIKASI HANGSENG
    //
    // Open < PP = SELL
    // Open >= PP = BUY
    // ==========================================================

    final String indication = open < pp ? 'SELL' : 'BUY';

    // ==========================================================
    // SIMPAN HISTORY
    // ==========================================================

    final bool historySaved = await historyViewModel.saveHistory(
      calculatorType: 'pivot_hangseng',
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

    return PivotHangsengCalculatorModel(
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
  }
}
