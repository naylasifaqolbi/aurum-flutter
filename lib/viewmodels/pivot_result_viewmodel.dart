import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';

import '../models/history_model.dart';
import '../models/pivot_result_model.dart';
import '../services/pdf_service.dart';

class PivotResultViewModel extends ChangeNotifier {
  // ============================================================
  // MODEL
  // ============================================================

  final PivotResultModel model;

  // ============================================================
  // SERVICE
  // ============================================================

  final PdfService _pdfService = PdfService();

  // ============================================================
  // STATUS
  // ============================================================

  bool _isGeneratingPdf = false;
  String? _errorMessage;

  bool get isGeneratingPdf => _isGeneratingPdf;

  String? get errorMessage => _errorMessage;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  PivotResultViewModel({required this.model});

  // ============================================================
  // DOWNLOAD HASIL PDF
  // ============================================================

  Future<bool> downloadResult() async {
    _isGeneratingPdf = true;
    _errorMessage = null;

    notifyListeners();

    try {
      // ==========================================================
      // HISTORY MODEL
      // ==========================================================

      final history = HistoryModel(
        id: '',
        userId: '',
        calculatorType: model.pivotType == 'Hang Seng'
            ? 'pivot_hangseng'
            : 'pivot_gold',
        createdAt: DateTime.now(),
        inputData: {
          'open': model.open,
          'high': model.high,
          'low': model.low,
          'close': model.close,
        },
        resultData: {
          'pp': model.pp,
          'r1': model.r1,
          'r2': model.r2,
          'r3': model.r3,
          'r4': model.r4,
          's1': model.s1,
          's2': model.s2,
          's3': model.s3,
          's4': model.s4,
          'midpoint_r4_r3': model.midpointR4R3,
          'midpoint_r3_r2': model.midpointR3R2,
          'midpoint_r2_r1': model.midpointR2R1,
          'midpoint_pp_r1': model.midpointPPR1,
          'midpoint_pp_s1': model.midpointPPS1,
          'midpoint_s1_s2': model.midpointS1S2,
          'midpoint_s2_s3': model.midpointS2S3,
          'midpoint_s3_s4': model.midpointS3S4,
          'indication': model.indication,
        },
      );

      // ==========================================================
      // GENERATE PDF
      // ==========================================================

      final pdfBytes = model.pivotType == 'Hang Seng'
          ? await _pdfService.generateHangSengPdf(history)
          : await _pdfService.generatePivotGoldPdf(history);

      // ==========================================================
      // SHARE PDF
      // ==========================================================

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: model.pivotType == 'Hang Seng'
            ? 'hasil_pivot_hang_seng.pdf'
            : 'hasil_pivot_emas.pdf',
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isGeneratingPdf = false;
      notifyListeners();
    }
  }
}
