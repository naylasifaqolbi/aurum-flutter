import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoricalApiService {
  // ============================================================
  // BASE URL
  // ============================================================

  static const String baseUrl = 'http://192.168.2.91:3000';

  // ============================================================
  // CATEGORY
  // ============================================================

  static const String defaultCategory = 'LGD Daily';

  static const List<String> availableCategories = [
    'LGD Daily',
    'HSI Daily',
    'SNI Daily',
  ];

  // ============================================================
  // CACHE KEY
  // ============================================================

  // Versi dinaikkan supaya cache lama yang hanya mengenal
  // LGD tidak tercampur dengan HSI / SNI.
  static const String _cacheKey = 'historical_gold_cache_v3';

  static const String _latestCacheKey = 'historical_gold_latest_cache_v2';

  // ============================================================
  // GET HISTORICAL DATA
  // ============================================================

  static Future<Map<String, dynamic>> getHistoricalData({
    String category = defaultCategory,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    final Uri uri = _buildUri(
      category: category,
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
    );

    try {
      // ========================================================
      // REQUEST BACKEND
      // ========================================================

      final response = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 5));

      // ========================================================
      // VALIDASI STATUS
      // ========================================================

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      // ========================================================
      // VALIDASI BODY
      // ========================================================

      if (response.body.trim().isEmpty) {
        throw Exception('Response server kosong.');
      }

      // ========================================================
      // PARSE JSON
      // ========================================================

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw Exception('Format response tidak valid.');
      }

      final Map<String, dynamic> json = Map<String, dynamic>.from(decoded);

      // ========================================================
      // VALIDASI SUCCESS
      // ========================================================

      if (json['success'] != true) {
        throw Exception(json['message']?.toString() ?? 'Gagal mengambil data.');
      }

      // ========================================================
      // CACHE TIME
      // ========================================================

      final String cacheTime = DateTime.now().toIso8601String();

      // ========================================================
      // SIMPAN CACHE
      // ========================================================

      await _saveCache(
        uri: uri,
        category: category,
        data: json,
        cacheTime: cacheTime,
      );

      // ========================================================
      // RETURN ONLINE
      // ========================================================

      return {
        ...json,

        'fromCache': false,

        'cacheTime': cacheTime,

        'category': json['category'] ?? category,
      };
    } catch (error) {
      // ========================================================
      // BACKEND GAGAL
      // COBA EXACT CACHE
      // ========================================================

      final Map<String, dynamic>? exactCache = await _getCache(uri);

      if (exactCache != null) {
        return _convertCacheToResult(exactCache, category: category);
      }

      // ========================================================
      // EXACT CACHE TIDAK ADA
      // COBA LATEST CACHE
      // DENGAN CATEGORY YANG SAMA
      // ========================================================

      final Map<String, dynamic>? latestCache = await _getLatestCache(
        category: category,
      );

      if (latestCache != null) {
        return _convertCacheToResult(latestCache, category: category);
      }

      // ========================================================
      // TIDAK ADA CACHE
      // ========================================================

      rethrow;
    }
  }

  // ============================================================
  // GET CACHED DATA
  // ============================================================

  static Future<Map<String, dynamic>?> getCachedHistoricalData({
    String category = defaultCategory,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    final Uri uri = _buildUri(
      category: category,
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
    );

    // ==========================================================
    // EXACT CACHE
    // ==========================================================

    final Map<String, dynamic>? exactCache = await _getCache(uri);

    if (exactCache != null) {
      return _convertCacheToResult(exactCache, category: category);
    }

    // ==========================================================
    // LATEST CACHE
    // CATEGORY HARUS SAMA
    // ==========================================================

    final Map<String, dynamic>? latestCache = await _getLatestCache(
      category: category,
    );

    if (latestCache != null) {
      return _convertCacheToResult(latestCache, category: category);
    }

    return null;
  }

  // ============================================================
  // BUILD URI
  // ============================================================

  static Uri _buildUri({
    required String category,
    DateTime? startDate,
    DateTime? endDate,
    required int page,
    required int limit,
  }) {
    final Map<String, String> queryParameters = {
      'category': category,

      'page': page.toString(),

      'limit': limit.toString(),
    };

    // ==========================================================
    // START DATE
    // ==========================================================

    if (startDate != null) {
      queryParameters['start_date'] = _formatDate(startDate);
    }

    // ==========================================================
    // END DATE
    // ==========================================================

    if (endDate != null) {
      queryParameters['end_date'] = _formatDate(endDate);
    }

    return Uri.parse(
      '$baseUrl/api/historical-gold',
    ).replace(queryParameters: queryParameters);
  }

  // ============================================================
  // SAVE CACHE
  // ============================================================

  static Future<void> _saveCache({
    required Uri uri,
    required String category,
    required Map<String, dynamic> data,
    required String cacheTime,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ==========================================================
    // EXACT CACHE
    // ==========================================================

    final Map<String, dynamic> exactCache = {
      'category': category,

      'data': data,

      'cacheTime': cacheTime,

      'savedAt': DateTime.now().toIso8601String(),
    };

    await prefs.setString(
      '$_cacheKey:${uri.toString()}',
      jsonEncode(exactCache),
    );

    // ==========================================================
    // LATEST CACHE
    // ==========================================================

    final Map<String, dynamic> latestCache = {
      'category': category,

      'data': data,

      'cacheTime': cacheTime,

      'savedAt': DateTime.now().toIso8601String(),
    };

    await prefs.setString(_latestCacheKey, jsonEncode(latestCache));
  }

  // ============================================================
  // GET EXACT CACHE
  // ============================================================

  static Future<Map<String, dynamic>?> _getCache(Uri uri) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cached = prefs.getString('$_cacheKey:${uri.toString()}');

    if (cached == null) {
      return null;
    }

    try {
      final dynamic decoded = jsonDecode(cached);

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  // ============================================================
  // GET LATEST CACHE
  // ============================================================

  static Future<Map<String, dynamic>?> _getLatestCache({
    required String category,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cached = prefs.getString(_latestCacheKey);

    if (cached == null) {
      return null;
    }

    try {
      final dynamic decoded = jsonDecode(cached);

      if (decoded is! Map) {
        return null;
      }

      final Map<String, dynamic> cache = Map<String, dynamic>.from(decoded);

      // ========================================================
      // CEK CATEGORY
      //
      // Penting agar:
      // LGD tidak mengambil cache HSI
      // HSI tidak mengambil cache SNI
      // SNI tidak mengambil cache LGD
      // ========================================================

      final String cachedCategory = cache['category']?.toString().trim() ?? '';

      if (cachedCategory.toLowerCase() != category.trim().toLowerCase()) {
        return null;
      }

      return cache;
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // CONVERT CACHE TO RESULT
  // ============================================================

  static Map<String, dynamic> _convertCacheToResult(
    Map<String, dynamic> cache, {
    required String category,
  }) {
    final dynamic storedData = cache['data'];

    Map<String, dynamic> result;

    if (storedData is Map) {
      result = Map<String, dynamic>.from(storedData);
    } else {
      result = {'success': true, 'data': []};
    }

    return {
      ...result,

      'success': true,

      'fromCache': true,

      'cacheTime': cache['cacheTime'],

      'category': result['category'] ?? cache['category'] ?? category,
    };
  }

  // ============================================================
  // GET CACHE TIME
  // ============================================================

  static Future<String?> getCacheTime({
    String category = defaultCategory,
  }) async {
    final Map<String, dynamic>? latestCache = await _getLatestCache(
      category: category,
    );

    if (latestCache == null) {
      return null;
    }

    return latestCache['cacheTime']?.toString();
  }

  // ============================================================
  // CLEAR CACHE
  // ============================================================

  static Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Set<String> keys = prefs.getKeys();

    for (final String key in keys) {
      if (key.startsWith('$_cacheKey:') || key == _latestCacheKey) {
        await prefs.remove(key);
      }
    }
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  static String _formatDate(DateTime date) {
    final String year = date.year.toString().padLeft(4, '0');

    final String month = date.month.toString().padLeft(2, '0');

    final String day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
