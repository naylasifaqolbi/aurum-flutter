import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';

import '../models/history_model.dart';
import '../models/physical_gold_result_model.dart';
import '../services/pdf_service.dart';

class PhysicalGoldResultViewModel extends ChangeNotifier {
  // ============================================================
  // MODEL HASIL
  // ============================================================

  final PhysicalGoldResultModel resultModel;

  PhysicalGoldResultViewModel({required this.resultModel});

  // ============================================================
  // STATUS DOWNLOAD PDF
  // ============================================================

  bool _isGeneratingPdf = false;

  bool get isGeneratingPdf => _isGeneratingPdf;

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ============================================================
  // DOWNLOAD / SHARE PDF
  // ============================================================

  Future<bool> downloadResult() async {
    if (_isGeneratingPdf) {
      return false;
    }

    _isGeneratingPdf = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ========================================================
      // BUAT HISTORY MODEL
      // ========================================================

      final history = HistoryModel(
        id: '',
        userId: '',
        calculatorType: 'physical_gold',
        createdAt: DateTime.now(),
        inputData: {
          'modal': resultModel.modal,
          'kurs': resultModel.kurs,
          'harga_beli': resultModel.hargaBeli,
          'harga_jual': resultModel.hargaJual,
        },
        resultData: {
          'toz': 31.1,
          'hasil_harga_beli': resultModel.hasilHargaBeli,
          'hasil_harga_jual': resultModel.hasilHargaJual,
          'selisih_harga': resultModel.selisihHarga,
          'jumlah_emas': resultModel.jumlahEmas,
          'keuntungan': resultModel.keuntungan,
        },
      );

      // ========================================================
      // GENERATE PDF
      // ========================================================

      final pdfService = PdfService();

      final pdfBytes = await pdfService.generatePhysicalGoldPdf(history);

      // ========================================================
      // SHARE / DOWNLOAD PDF
      // ========================================================

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'hasil_emas_fisik.pdf',
      );

      _isGeneratingPdf = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Gagal membuat PDF: $e';

      _isGeneratingPdf = false;
      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
