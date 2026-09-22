import 'package:flutter/foundation.dart';

import '../models/history_model.dart';
import '../services/history_service.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryService _historyService = HistoryService();

  List<HistoryModel> _histories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<HistoryModel> get histories => _histories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _histories = await _historyService.getHistory();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveHistory({
    required String calculatorType,
    required Map<String, dynamic> inputData,
    required Map<String, dynamic> resultData,
  }) async {
    try {
      await _historyService.saveHistory(
        calculatorType: calculatorType,
        inputData: inputData,
        resultData: resultData,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();

      return false;
    }
  }

  Future<bool> deleteHistory(String id) async {
    try {
      await _historyService.deleteHistory(id);

      _histories.removeWhere((history) => history.id == id);
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();

      return false;
    }
  }
}
