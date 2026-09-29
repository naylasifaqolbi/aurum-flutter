import 'package:flutter/foundation.dart';

import '../models/physical_gold_calculator_model.dart';
import 'history_viewmodel.dart';

class PhysicalGoldCalculatorViewModel extends ChangeNotifier {
  final HistoryViewModel historyViewModel;

  PhysicalGoldCalculatorViewModel({required this.historyViewModel});

  // ==================================================
  // STATUS
  // ==================================================

  bool _isLoading = false;

  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // ==================================================
  // HITUNG
  // ==================================================

  Future<PhysicalGoldCalculatorModel?> hitung({
    required double modal,
    required double kurs,
    required double hargaBeli,
    required double hargaJual,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      // ================================================
      // TOZ
      // ================================================

      const double toz = 31.1;

      // ================================================
      // LANGKAH 1
      //
      // Harga Beli × Kurs ÷ Toz
      //
      // Desimal dibuang tanpa pembulatan.
      // ================================================

      final double hasilHargaBeli = ((hargaBeli * kurs) / toz).floorToDouble();

      // ================================================
      // LANGKAH 2
      //
      // Harga Jual × Kurs ÷ Toz
      //
      // Desimal dibuang tanpa pembulatan.
      // ================================================

      final double hasilHargaJual = ((hargaJual * kurs) / toz).floorToDouble();

      // ================================================
      // LANGKAH 3
      //
      // Hasil harga jual - hasil harga beli
      //
      // Tidak dilakukan pembulatan.
      // ================================================

      final double selisihHarga = hasilHargaJual - hasilHargaBeli;

      // ================================================
      // LANGKAH 4
      //
      // Modal ÷ hasil harga beli
      //
      // Hanya mengambil 2 angka di belakang koma.
      // Tidak dibulatkan.
      //
      // Contoh:
      // 9,7189 → 9,71
      // 9,7265 → 9,72
      // ================================================

      final double jumlahEmas = ((modal / hasilHargaBeli) * 100).floor() / 100;

      // ================================================
      // LANGKAH 5
      //
      // Hasil langkah 3 × hasil langkah 4
      //
      // Angka di belakang koma dibuang.
      // Tidak dibulatkan.
      // ================================================

      final double keuntungan = (selisihHarga * jumlahEmas).floorToDouble();

      // ================================================
      // MODEL HASIL
      // ================================================

      final result = PhysicalGoldCalculatorModel(
        modal: modal,
        kurs: kurs,
        hargaBeli: hargaBeli,
        hargaJual: hargaJual,
        hasilHargaBeli: hasilHargaBeli,
        hasilHargaJual: hasilHargaJual,
        selisihHarga: selisihHarga,
        jumlahEmas: jumlahEmas,
        keuntungan: keuntungan,
      );

      // ================================================
      // SIMPAN HISTORY
      // ================================================

      final historySaved = await historyViewModel.saveHistory(
        calculatorType: 'physical_gold',
        inputData: {
          'modal': modal,
          'kurs': kurs,
          'harga_beli': hargaBeli,
          'harga_jual': hargaJual,
        },
        resultData: {
          'toz': toz,
          'hasil_harga_beli': hasilHargaBeli,
          'hasil_harga_jual': hasilHargaJual,
          'selisih_harga': selisihHarga,
          'jumlah_emas': jumlahEmas,
          'keuntungan': keuntungan,
        },
      );

      if (!historySaved) {
        return null;
      }

      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
