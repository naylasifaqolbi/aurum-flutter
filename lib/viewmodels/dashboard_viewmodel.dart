import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/dashboard_model.dart';
import '../services/historical_api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  // ============================================================
  // CATEGORY DASHBOARD
  // ============================================================

  static const String dashboardCategory = 'LGD Daily';

  // ============================================================
  // DATA HARGA TERBARU
  // ============================================================

  DashboardModel _latestGoldData = const DashboardModel();

  // ============================================================
  // NAMA USER
  // ============================================================

  String _nama = '-';

  // ============================================================
  // LOADING DATA
  // ============================================================

  bool _isLoadingGoldData = true;

  // ============================================================
  // GETTER
  // ============================================================

  DashboardModel get latestGoldData => _latestGoldData;

  String get nama => _nama;

  bool get isLoadingGoldData => _isLoadingGoldData;

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> initialize() async {
    await Future.wait([loadLatestGoldData(), loadProfile()]);
  }

  // ============================================================
  // LOAD PROFILE DARI SUPABASE
  // ============================================================

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      _nama = '-';
      notifyListeners();
      return;
    }

    try {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('name')
          .eq('id', user.id)
          .single();

      _nama = profile['name']?.toString() ?? '-';
    } catch (_) {
      _nama = '-';
    }

    notifyListeners();
  }

  // ============================================================
  // LOAD DATA LGD TERBARU
  // ============================================================

  Future<void> loadLatestGoldData() async {
    try {
      // ========================================================
      // AMBIL DATA DARI HISTORICAL API SERVICE
      // ========================================================

      final Map<String, dynamic> result =
          await HistoricalApiService.getHistoricalData(
            category: dashboardCategory,
            page: 1,
            limit: 10,
          );

      // ========================================================
      // AMBIL DATA DARI RESPONSE
      // ========================================================

      final dynamic rawData = result['data'];

      if (rawData is List && rawData.isNotEmpty) {
        final dynamic firstItem = rawData.first;

        if (firstItem is Map) {
          _latestGoldData = DashboardModel.fromMap(firstItem);
        } else {
          _latestGoldData = const DashboardModel();
        }
      } else {
        _latestGoldData = const DashboardModel();
      }
    } catch (_) {
      // ========================================================
      // JIKA API DAN CACHE TIDAK TERSEDIA
      // ========================================================

      _latestGoldData = const DashboardModel();
    }

    _isLoadingGoldData = false;

    notifyListeners();
  }

  // ============================================================
  // REFRESH DASHBOARD
  // ============================================================

  Future<void> refresh() async {
    _isLoadingGoldData = true;
    notifyListeners();

    await Future.wait([loadLatestGoldData(), loadProfile()]);
  }
}
