import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoricalApiService {
  // ============================================================
  // BACKEND
  // ============================================================

  static const String baseUrl = 'http://192.168.2.91:3000';

  // ============================================================
  // CACHE
  // ============================================================

  // Cache berdasarkan URL/request.
  static const String _cacheKey = 'historical_gold_cache_v2';

  // Cache terakhir yang berhasil diperoleh dari backend.
  static const String _latestCacheKey = 'historical_gold_latest_cache_v1';

  // ============================================================
  // GET HISTORICAL DATA
  // ============================================================

  static Future<Map<String, dynamic>> getHistoricalData({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    final Uri uri = _buildUri(
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
    );

    print('');
    print('========================================');
    print('AURUM HISTORICAL API');
    print('Request URL: $uri');
    print('========================================');

    try {
      // ----------------------------------------------------------
      // REQUEST KE BACKEND
      // ----------------------------------------------------------

      final http.Response response = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 5));

      print('HTTP Status: ${response.statusCode}');

      // ----------------------------------------------------------
      // CEK STATUS RESPONSE
      // ----------------------------------------------------------

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      // ----------------------------------------------------------
      // CEK RESPONSE KOSONG
      // ----------------------------------------------------------

      if (response.body.isEmpty) {
        throw Exception('Response server kosong.');
      }

      // ----------------------------------------------------------
      // DECODE JSON
      // ----------------------------------------------------------

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Format response server tidak valid.');
      }

      final Map<String, dynamic> json = decoded;

      // ----------------------------------------------------------
      // CEK SUCCESS
      // ----------------------------------------------------------

      if (json['success'] != true) {
        throw Exception(
          json['message']?.toString() ?? 'Gagal mengambil data historical.',
        );
      }

      // ----------------------------------------------------------
      // CACHE TIME
      // ----------------------------------------------------------

      final String cacheTime = DateTime.now().toIso8601String();

      // ----------------------------------------------------------
      // SIMPAN CACHE
      // ----------------------------------------------------------

      print('');
      print('========================================');
      print('HISTORICAL DATA ONLINE');
      print('Data berhasil diambil dari backend.');
      print('Menyimpan data ke cache HP...');
      print('========================================');

      await _saveCache(uri: uri, data: json, cacheTime: cacheTime);

      print('Cache berhasil diperbarui.');

      // ----------------------------------------------------------
      // RETURN DATA ONLINE
      // ----------------------------------------------------------

      return {...json, 'fromCache': false, 'cacheTime': cacheTime};
    } catch (error) {
      // ==========================================================
      // BACKEND TIDAK DAPAT DIAKSES
      // ==========================================================

      print('');
      print('========================================');
      print('BACKEND TIDAK DAPAT DIAKSES');
      print('Error: $error');
      print('========================================');

      print('Mencoba mengambil data dari cache...');

      // ----------------------------------------------------------
      // 1. COBA EXACT CACHE
      // ----------------------------------------------------------

      final Map<String, dynamic>? exactCache = await _getCache(uri: uri);

      if (exactCache != null) {
        print('');
        print('========================================');
        print('EXACT CACHE DIGUNAKAN');
        print('Backend OFF');
        print('Request yang sama ditemukan di cache.');
        print('========================================');

        return _convertCacheToResult(exactCache);
      }

      // ----------------------------------------------------------
      // 2. KALAU EXACT CACHE TIDAK ADA,
      //    GUNAKAN CACHE TERAKHIR
      // ----------------------------------------------------------

      final Map<String, dynamic>? latestCache = await _getLatestCache();

      if (latestCache != null) {
        print('');
        print('========================================');
        print('LATEST CACHE DIGUNAKAN');
        print('Backend OFF');
        print('Exact cache tidak ditemukan.');
        print('Menggunakan data terakhir yang tersimpan.');
        print('========================================');

        return _convertCacheToResult(latestCache);
      }

      // ----------------------------------------------------------
      // 3. TIDAK ADA CACHE SAMA SEKALI
      // ----------------------------------------------------------

      print('');
      print('========================================');
      print('CACHE TIDAK DITEMUKAN');
      print('Belum pernah ada data yang tersimpan.');
      print('========================================');

      rethrow;
    }
  }

  // ============================================================
  // GET CACHE SAJA
  // ============================================================
  //
  // Digunakan oleh screen agar cache bisa langsung ditampilkan
  // sebelum mencoba koneksi ke backend.
  //
  // ============================================================

  static Future<Map<String, dynamic>?> getCachedHistoricalData({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    final Uri uri = _buildUri(
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
    );

    // ----------------------------------------------------------
    // COBA EXACT CACHE
    // ----------------------------------------------------------

    final Map<String, dynamic>? exactCache = await _getCache(uri: uri);

    if (exactCache != null) {
      print('');
      print('========================================');
      print('CACHE AWAL DITEMUKAN');
      print('Menggunakan exact cache.');
      print('========================================');

      return _convertCacheToResult(exactCache);
    }

    // ----------------------------------------------------------
    // COBA LATEST CACHE
    // ----------------------------------------------------------

    final Map<String, dynamic>? latestCache = await _getLatestCache();

    if (latestCache != null) {
      print('');
      print('========================================');
      print('LATEST CACHE AWAL DITEMUKAN');
      print('Menggunakan cache terakhir.');
      print('========================================');

      return _convertCacheToResult(latestCache);
    }

    // ----------------------------------------------------------
    // TIDAK ADA CACHE
    // ----------------------------------------------------------

    return null;
  }

  // ============================================================
  // BUILD URI
  // ============================================================

  static Uri _buildUri({
    DateTime? startDate,
    DateTime? endDate,
    required int page,
    required int limit,
  }) {
    final Map<String, String> queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (startDate != null) {
      queryParameters['start_date'] = _formatDate(startDate);
    }

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
    required Map<String, dynamic> data,
    required String cacheTime,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ----------------------------------------------------------
    // AMBIL CACHE LAMA
    // ----------------------------------------------------------

    Map<String, dynamic> allCache = {};

    final String? existingCache = prefs.getString(_cacheKey);

    if (existingCache != null) {
      try {
        final dynamic decoded = jsonDecode(existingCache);

        if (decoded is Map<String, dynamic>) {
          allCache = decoded;
        }
      } catch (error) {
        print('Cache lama tidak dapat dibaca.');
      }
    }

    // ----------------------------------------------------------
    // SIMPAN EXACT CACHE
    // ----------------------------------------------------------

    allCache[uri.toString()] = {'data': data, 'cacheTime': cacheTime};

    await prefs.setString(_cacheKey, jsonEncode(allCache));

    // ----------------------------------------------------------
    // SIMPAN LATEST CACHE
    // ----------------------------------------------------------

    final Map<String, dynamic> latestCache = {
      'data': data,
      'cacheTime': cacheTime,
      'requestUrl': uri.toString(),
    };

    await prefs.setString(_latestCacheKey, jsonEncode(latestCache));

    print('Exact cache disimpan untuk: $uri');

    print('Latest cache berhasil diperbarui.');
  }

  // ============================================================
  // GET EXACT CACHE
  // ============================================================

  static Future<Map<String, dynamic>?> _getCache({required Uri uri}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cacheString = prefs.getString(_cacheKey);

    if (cacheString == null) {
      return null;
    }

    try {
      final dynamic decoded = jsonDecode(cacheString);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final dynamic cachedItem = decoded[uri.toString()];

      if (cachedItem is! Map<String, dynamic>) {
        return null;
      }

      return Map<String, dynamic>.from(cachedItem);
    } catch (error) {
      print('Gagal membaca exact cache: $error');

      return null;
    }
  }

  // ============================================================
  // GET LATEST CACHE
  // ============================================================

  static Future<Map<String, dynamic>?> _getLatestCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? latestCacheString = prefs.getString(_latestCacheKey);

    if (latestCacheString == null) {
      return null;
    }

    try {
      final dynamic decoded = jsonDecode(latestCacheString);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return Map<String, dynamic>.from(decoded);
    } catch (error) {
      print('Gagal membaca latest cache: $error');

      return null;
    }
  }

  // ============================================================
  // CONVERT CACHE
  // ============================================================

  static Map<String, dynamic> _convertCacheToResult(
    Map<String, dynamic> cachedItem,
  ) {
    final dynamic cachedResponse = cachedItem['data'];

    final String? cacheTime = cachedItem['cacheTime']?.toString();

    if (cachedResponse is! Map<String, dynamic>) {
      throw Exception('Format cache tidak valid.');
    }

    return {...cachedResponse, 'fromCache': true, 'cacheTime': cacheTime};
  }

  // ============================================================
  // GET CACHE TIME
  // ============================================================

  static Future<DateTime?> getCacheTime({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    final Uri uri = _buildUri(
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
    );

    // ----------------------------------------------------------
    // EXACT CACHE
    // ----------------------------------------------------------

    final Map<String, dynamic>? exactCache = await _getCache(uri: uri);

    if (exactCache != null) {
      final String? cacheTime = exactCache['cacheTime']?.toString();

      if (cacheTime != null) {
        return DateTime.tryParse(cacheTime);
      }
    }

    // ----------------------------------------------------------
    // LATEST CACHE
    // ----------------------------------------------------------

    final Map<String, dynamic>? latestCache = await _getLatestCache();

    if (latestCache != null) {
      final String? cacheTime = latestCache['cacheTime']?.toString();

      if (cacheTime != null) {
        return DateTime.tryParse(cacheTime);
      }
    }

    return null;
  }

  // ============================================================
  // CLEAR CACHE
  // ============================================================

  static Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_cacheKey);

    await prefs.remove(_latestCacheKey);

    print('Cache historical gold berhasil dihapus.');
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  static String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');

    final String day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }
}
