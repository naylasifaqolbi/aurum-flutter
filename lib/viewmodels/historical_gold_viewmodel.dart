import 'package:flutter/foundation.dart';

import '../models/historical_gold_model.dart';
import '../services/historical_api_service.dart';

class HistoricalGoldViewModel extends ChangeNotifier {
  // ============================================================
  // CATEGORY
  // ============================================================

  static const List<String> categories = [
    'LGD Daily',
    'HSI Daily',
    'SNI Daily',
  ];

  String _selectedCategory = HistoricalApiService.defaultCategory;

  String get selectedCategory => _selectedCategory;

  // ============================================================
  // DATE
  // ============================================================

  DateTime? _startDate;

  DateTime? _endDate;

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  // ============================================================
  // DATA
  // ============================================================

  List<HistoricalGoldModel> _historicalData = [];

  List<HistoricalGoldModel> get historicalData => _historicalData;

  // ============================================================
  // LOADING / ERROR
  // ============================================================

  bool _isLoading = false;

  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // ============================================================
  // CACHE STATUS
  // ============================================================

  bool _isFromCache = false;

  String? _cacheTime;

  bool get isFromCache => _isFromCache;

  String? get cacheTime => _cacheTime;

  // ============================================================
  // REQUEST LOCK
  // ============================================================

  bool _requestRunning = false;

  bool get requestRunning => _requestRunning;

  // ============================================================
  // PAGINATION
  // ============================================================

  int _currentPage = 1;

  int _totalPages = 1;

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  // ============================================================
  // LOAD HISTORICAL DATA
  // ============================================================

  Future<void> loadHistoricalData({bool showLoading = true}) async {
    // ==========================================================
    // CEGAH REQUEST DOUBLE
    // ==========================================================

    if (_requestRunning) {
      return;
    }

    _requestRunning = true;

    if (showLoading) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      // ========================================================
      // TAMPILKAN CACHE TERLEBIH DAHULU
      // ========================================================

      if (showLoading) {
        final cached = await HistoricalApiService.getCachedHistoricalData(
          category: _selectedCategory,
          startDate: _startDate,
          endDate: _endDate,
          page: _currentPage,
          limit: 10,
        );

        if (cached != null) {
          _applyResult(cached);

          _isLoading = false;

          notifyListeners();
        }
      }

      // ========================================================
      // REQUEST KE BACKEND
      // ========================================================

      final result = await HistoricalApiService.getHistoricalData(
        category: _selectedCategory,
        startDate: _startDate,
        endDate: _endDate,
        page: _currentPage,
        limit: 10,
      );

      // ========================================================
      // APPLY RESULT
      // ========================================================

      _applyResult(result);

      _isLoading = false;

      _errorMessage = null;

      notifyListeners();
    } catch (error) {
      // ========================================================
      // BACKEND OFF
      // CACHE SUDAH DICOBA OLEH SERVICE
      // ========================================================

      if (_historicalData.isEmpty) {
        _errorMessage =
            'Tidak dapat mengambil data '
            '$_selectedCategory.\n'
            'Pastikan backend aktif atau '
            'tersedia cache offline.';
      }

      _isLoading = false;

      notifyListeners();
    } finally {
      _requestRunning = false;
    }
  }

  // ============================================================
  // APPLY RESULT
  // ============================================================

  void _applyResult(Map<String, dynamic> result) {
    final dynamic rawData = result['data'];

    final List<HistoricalGoldModel> convertedData = [];

    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map) {
          convertedData.add(HistoricalGoldModel.fromMap(item));
        }
      }
    }

    // ==========================================================
    // PAGINATION
    // ==========================================================

    final dynamic pagination = result['pagination'];

    if (pagination is Map) {
      _currentPage =
          int.tryParse(pagination['current_page']?.toString() ?? '') ??
          _currentPage;

      _totalPages =
          int.tryParse(pagination['total_pages']?.toString() ?? '') ?? 1;
    }

    // ==========================================================
    // CACHE STATUS
    // ==========================================================

    _isFromCache = result['fromCache'] == true;

    _cacheTime = result['cacheTime']?.toString();

    // ==========================================================
    // DATA
    // ==========================================================

    _historicalData = convertedData;
  }

  // ============================================================
  // CATEGORY CHANGED
  // ============================================================

  Future<void> changeCategory(String? value) async {
    if (value == null || value == _selectedCategory) {
      return;
    }

    _selectedCategory = value;

    // Reset pagination
    _currentPage = 1;

    // Bersihkan data kategori sebelumnya
    // agar data LGD tidak tampil saat
    // sedang mengambil HSI / SNI.
    _historicalData = [];

    _errorMessage = null;

    _isFromCache = false;

    _cacheTime = null;

    notifyListeners();

    await loadHistoricalData(showLoading: true);
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<bool> refreshData() async {
    if (_requestRunning) {
      return false;
    }

    _isLoading = true;

    _errorMessage = null;

    notifyListeners();

    await loadHistoricalData(showLoading: false);

    return _errorMessage == null;
  }

  // ============================================================
  // NEXT PAGE
  // ============================================================

  Future<void> nextPage() async {
    if (_currentPage >= _totalPages) {
      return;
    }

    _currentPage++;

    notifyListeners();

    await loadHistoricalData(showLoading: true);
  }

  // ============================================================
  // PREVIOUS PAGE
  // ============================================================

  Future<void> previousPage() async {
    if (_currentPage <= 1) {
      return;
    }

    _currentPage--;

    notifyListeners();

    await loadHistoricalData(showLoading: true);
  }

  // ============================================================
  // SELECT START DATE
  // ============================================================

  Future<void> setStartDate(DateTime picked) async {
    _startDate = picked;

    // Jika end date lebih kecil
    // dari start date, reset end date.
    if (_endDate != null && _endDate!.isBefore(picked)) {
      _endDate = null;
    }

    _currentPage = 1;

    notifyListeners();

    await loadHistoricalData(showLoading: true);
  }

  // ============================================================
  // SELECT END DATE
  // ============================================================

  Future<void> setEndDate(DateTime picked) async {
    _endDate = picked;

    _currentPage = 1;

    notifyListeners();

    await loadHistoricalData(showLoading: true);
  }
}
