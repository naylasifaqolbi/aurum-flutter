import 'package:flutter/material.dart';

import '../models/calculator_menu_model.dart';
import '../views/calculator/physical_gold_calculator.dart';
import '../views/calculator/pivot_calculator.dart';
import '../views/calculator/pivot_hangseng_calculator.dart';
import '../views/calculator/nest_calculator.dart';

class CalculatorMenuViewModel extends ChangeNotifier {
  // ============================================================
  // SELECTED CALCULATOR
  // ============================================================

  Widget? _selectedCalculator;

  Widget? get selectedCalculator => _selectedCalculator;

  // ============================================================
  // MENU DATA
  // ============================================================

  final List<CalculatorMenuModel> calculatorMenus = const [
    CalculatorMenuModel(
      title: 'Emas Fisik',
      description:
          'Menghitung estimasi keuntungan berdasarkan modal, kurs, harga beli, dan harga jual.',
    ),
  ];

  final List<CalculatorMenuModel> transactionConceptMenus = const [
    CalculatorMenuModel(
      title: 'Pivot Point Emas',
      description:
          'Menghitung Pivot Point emas berdasarkan harga High, Low, dan Close.',
    ),
    CalculatorMenuModel(
      title: 'Pivot Point Hang Seng',
      description:
          'Menghitung Pivot Point Hang Seng berdasarkan harga High, Low, dan Close.',
    ),
    CalculatorMenuModel(
      title: 'Nest',
      description:
          'Menampilkan indikator BUY atau SELL berdasarkan perbandingan harga Open dan Close.',
    ),
  ];

  // ============================================================
  // OPEN PHYSICAL GOLD
  // ============================================================

  void openPhysicalGoldCalculator(VoidCallback onBack) {
    _selectedCalculator = PhysicalGoldCalculator(onBack: onBack);

    notifyListeners();
  }

  // ============================================================
  // OPEN PIVOT GOLD
  // ============================================================

  void openPivotCalculator(VoidCallback onBack) {
    _selectedCalculator = PivotCalculator(onBack: onBack);

    notifyListeners();
  }

  // ============================================================
  // OPEN PIVOT HANG SENG
  // ============================================================

  void openPivotHangsengCalculator(VoidCallback onBack) {
    _selectedCalculator = PivotHangsengCalculator(onBack: onBack);

    notifyListeners();
  }

  // ============================================================
  // OPEN NEST
  // ============================================================

  void openNestCalculator(VoidCallback onBack) {
    _selectedCalculator = NestCalculatorScreen(onBack: onBack);

    notifyListeners();
  }

  // ============================================================
  // BACK TO MENU
  // ============================================================

  void clearSelectedCalculator() {
    _selectedCalculator = null;

    notifyListeners();
  }
}
