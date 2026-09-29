import 'package:flutter/foundation.dart';

import '../models/nest_calculator_model.dart';
import '../services/historical_api_service.dart';
import 'history_viewmodel.dart';

class NestCalculatorViewModel extends ChangeNotifier {
  final HistoryViewModel historyViewModel;

  NestCalculatorViewModel({required this.historyViewModel});

  // ============================================================
  // STATUS LOADING HISTORICAL
  // ============================================================

  bool _isLoadingHistorical = true;

  bool get isLoadingHistorical => _isLoadingHistorical;

  // ============================================================
  // LOAD DATA HISTORICAL TERBARU
  // ============================================================

  Future<String?> loadLatestHistoricalData() async {
    try {
      final result = await HistoricalApiService.getHistoricalData(
        category: 'LGD Daily',
        page: 1,
        limit: 10,
      );

      final dynamic rawData = result['data'];

      if (rawData is List && rawData.isNotEmpty) {
        final dynamic latest = rawData.first;

        _isLoadingHistorical = false;
        notifyListeners();

        return latest['close']?.toString() ?? '';
      }

      _isLoadingHistorical = false;
      notifyListeners();

      return null;
    } catch (_) {
      _isLoadingHistorical = false;
      notifyListeners();

      // Jika data historical gagal dimuat,
      // pengguna tetap dapat mengisi data secara manual.
      return null;
    }
  }

  // ============================================================
  // HITUNG NEST + SIMPAN HISTORY
  // ============================================================

  Future<NestCalculatorModel?> hitungDanSimpan({
    required double open,
    required double close,
  }) async {
    String indication;
    String description;

    // ==========================================================
    // LOGIKA INDIKATOR NEST
    // ==========================================================

    if (close > open) {
      indication = 'BUY';
      description = 'Harga Close berada di atas harga Open.';
    } else if (close < open) {
      indication = 'SELL';
      description = 'Harga Close berada di bawah harga Open.';
    } else {
      indication = 'NETRAL';
      description = 'Harga Close sama dengan harga Open.';
    }

    // ==========================================================
    // SIMPAN HISTORY
    // ==========================================================

    final bool historySaved = await historyViewModel.saveHistory(
      calculatorType: 'nest',
      inputData: {'open': open, 'close': close},
      resultData: {'indication': indication, 'description': description},
    );

    if (!historySaved) {
      return null;
    }

    // ==========================================================
    // MODEL HASIL
    // ==========================================================

    return NestCalculatorModel(
      open: open,
      close: close,
      indication: indication,
      description: description,
    );
  }
}
