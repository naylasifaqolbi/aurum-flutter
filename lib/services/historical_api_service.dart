import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoricalApiService {
  // ============================================================
  // BASE URL
  // ============================================================

  static const String baseUrl = 'https://www.newsmaker.id/api/historical-data';

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

  // Cache lama sengaja dibuat versi baru agar tidak bercampur
  // dengan struktur cache versi sebelumnya.
  static const String _fullCacheKey = 'historical_gold_full_cache_v6';

  // ============================================================
  // REQUEST TIMEOUT
  // ============================================================

  static const Duration _requestTimeout = Duration(seconds: 15);

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
    // ==========================================================
    // NORMALISASI CATEGORY
    // ==========================================================

    final String selectedCategory = _getCanonicalCategory(category);

    // ==========================================================
    // REQUEST LANGSUNG KE NEWSMAKER
    // ==========================================================

    try {
      final Uri requestUri = Uri.parse(baseUrl);

      final http.Response response = await http
          .get(
            requestUri,
            headers: const {
              'Accept': 'application/json',
              'User-Agent': 'Mozilla/5.0',
            },
          )
          .timeout(_requestTimeout);

      // ========================================================
      // CEK STATUS HTTP
      // ========================================================

      if (response.statusCode != 200) {
        throw Exception('Newsmaker server error: ${response.statusCode}');
      }

      // ========================================================
      // CEK BODY
      // ========================================================

      if (response.body.trim().isEmpty) {
        throw Exception('Response dari Newsmaker kosong.');
      }

      // ========================================================
      // PARSE JSON
      // ========================================================

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw Exception('Format response dari Newsmaker tidak valid.');
      }

      final Map<String, dynamic> json = Map<String, dynamic>.from(decoded);

      // ========================================================
      // CEK STATUS RESPONSE
      // ========================================================

      if (json['status'] != null) {
        final int? status = int.tryParse(json['status'].toString());

        if (status != null && status != 200) {
          throw Exception(
            json['message']?.toString() ??
                'Gagal mengambil data dari Newsmaker.',
          );
        }
      }

      // ========================================================
      // AMBIL DATA
      // ========================================================

      final dynamic rawData = json['data'];

      if (rawData is! List) {
        throw Exception('Data historical dari Newsmaker tidak valid.');
      }

      // ========================================================
      // NORMALISASI SEMUA DATA
      // ========================================================

      final List<Map<String, String>> allData = _normalizeData(rawData);

      // ========================================================
      // PISAHKAN DATA BERDASARKAN CATEGORY
      // ========================================================

      final Map<String, List<Map<String, String>>> categorizedData =
          _categorizeData(allData);

      // ========================================================
      // SIMPAN FULL CACHE
      //
      // PENTING:
      // Yang disimpan adalah SEMUA DATA kategori,
      // bukan data yang sudah dipagination.
      // ========================================================

      await _saveFullCache(categorizedData);

      // ========================================================
      // AMBIL DATA UNTUK CATEGORY YANG DIMINTA
      // ========================================================

      final List<Map<String, String>> selectedData =
          List<Map<String, String>>.from(
            categorizedData[selectedCategory] ?? [],
          );

      // ========================================================
      // FILTER + SORT + PAGINATION
      // ========================================================

      final Map<String, dynamic> result = _buildResult(
        category: selectedCategory,
        data: selectedData,
        startDate: startDate,
        endDate: endDate,
        page: page,
        limit: limit,
      );

      // ========================================================
      // ONLINE
      // ========================================================

      return {
        ...result,
        'fromCache': false,
        'cacheTime': DateTime.now().toIso8601String(),
      };
    } catch (error) {
      // ========================================================
      // ONLINE GAGAL
      //
      // LANGSUNG GUNAKAN FULL CACHE CATEGORY YANG SESUAI
      // ========================================================

      final Map<String, List<Map<String, String>>>? cachedData =
          await _getFullCache();

      if (cachedData != null) {
        final List<Map<String, String>> selectedData =
            List<Map<String, String>>.from(cachedData[selectedCategory] ?? []);

        // ======================================================
        // JIKA CATEGORY ADA DI CACHE
        // ======================================================

        if (selectedData.isNotEmpty) {
          final Map<String, dynamic> result = _buildResult(
            category: selectedCategory,
            data: selectedData,
            startDate: startDate,
            endDate: endDate,
            page: page,
            limit: limit,
          );

          final String? cacheTime = await getCacheTime(
            category: selectedCategory,
          );

          return {...result, 'fromCache': true, 'cacheTime': cacheTime};
        }
      }

      // ========================================================
      // TIDAK ADA CACHE
      // ========================================================

      throw Exception(
        'Tidak dapat mengambil data historical. '
        'Newsmaker atau internet tidak tersedia '
        'dan belum ada cache untuk $selectedCategory.',
      );
    }
  }

  // ============================================================
  // GET CACHED HISTORICAL DATA
  // ============================================================

  static Future<Map<String, dynamic>?> getCachedHistoricalData({
    String category = defaultCategory,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    final String selectedCategory = _getCanonicalCategory(category);

    // ==========================================================
    // AMBIL FULL CACHE
    // ==========================================================

    final Map<String, List<Map<String, String>>>? cachedData =
        await _getFullCache();

    if (cachedData == null) {
      return null;
    }

    // ==========================================================
    // AMBIL CATEGORY YANG SESUAI
    // ==========================================================

    final List<Map<String, String>> selectedData =
        List<Map<String, String>>.from(cachedData[selectedCategory] ?? []);

    if (selectedData.isEmpty) {
      return null;
    }

    // ==========================================================
    // FILTER + SORT + PAGINATION
    // ==========================================================

    final Map<String, dynamic> result = _buildResult(
      category: selectedCategory,
      data: selectedData,
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
    );

    // ==========================================================
    // CACHE TIME
    // ==========================================================

    final String? cacheTime = await getCacheTime(category: selectedCategory);

    return {...result, 'fromCache': true, 'cacheTime': cacheTime};
  }

  // ============================================================
  // NORMALIZE DATA
  // ============================================================

  static List<Map<String, String>> _normalizeData(List<dynamic> rawData) {
    final List<Map<String, String>> result = [];

    for (final dynamic item in rawData) {
      if (item is! Map) {
        continue;
      }

      final Map<String, dynamic> source = Map<String, dynamic>.from(item);

      final String date = _firstValidValue([
        source['date'],
        source['tanggal'],
        source['Date'],
        source['Tanggal'],
      ]);

      final String open = _firstValidValue([source['open'], source['Open']]);

      final String high = _firstValidValue([source['high'], source['High']]);

      final String low = _firstValidValue([source['low'], source['Low']]);

      final String close = _firstValidValue([source['close'], source['Close']]);

      final String category = _firstValidValue([
        source['category'],
        source['Category'],
        source['CATEGORY'],
      ]);

      // ========================================================
      // HANYA SIMPAN DATA YANG MEMILIKI CATEGORY
      // ========================================================

      if (category.trim().isEmpty) {
        continue;
      }

      // ========================================================
      // NORMALISASI CATEGORY
      // ========================================================

      final String canonicalCategory = _tryGetCanonicalCategory(category);

      // Kalau bukan LGD/HSI/SNI, abaikan.
      if (canonicalCategory.isEmpty) {
        continue;
      }

      result.add({
        'date': date,
        'open': open,
        'high': high,
        'low': low,
        'close': close,
        'category': canonicalCategory,
      });
    }

    return result;
  }

  // ============================================================
  // FIRST VALID VALUE
  // ============================================================

  static String _firstValidValue(List<dynamic> values) {
    for (final dynamic value in values) {
      if (value == null) {
        continue;
      }

      final String text = value.toString().trim();

      if (text.isEmpty) {
        continue;
      }

      if (text == '-') {
        continue;
      }

      return text;
    }

    return '-';
  }

  // ============================================================
  // CATEGORIZE DATA
  // ============================================================

  static Map<String, List<Map<String, String>>> _categorizeData(
    List<Map<String, String>> allData,
  ) {
    final Map<String, List<Map<String, String>>> result = {
      'LGD Daily': [],
      'HSI Daily': [],
      'SNI Daily': [],
    };

    // ==========================================================
    // MASUKKAN DATA KE CATEGORY MASING-MASING
    // ==========================================================

    for (final Map<String, String> item in allData) {
      final String category = item['category'] ?? '';

      final String canonical = _tryGetCanonicalCategory(category);

      if (canonical.isEmpty) {
        continue;
      }

      result[canonical]!.add(Map<String, String>.from(item));
    }

    // ==========================================================
    // SORT MASING-MASING CATEGORY
    //
    // TERBARU -> TERLAMA
    // ==========================================================

    for (final String category in availableCategories) {
      result[category]!.sort((a, b) {
        final DateTime? dateA = _parseDate(a['date']);

        final DateTime? dateB = _parseDate(b['date']);

        if (dateA == null && dateB == null) {
          return 0;
        }

        if (dateA == null) {
          return 1;
        }

        if (dateB == null) {
          return -1;
        }

        return dateB.compareTo(dateA);
      });
    }

    return result;
  }

  // ============================================================
  // BUILD RESULT
  //
  // FUNGSI INI DIGUNAKAN UNTUK DATA ONLINE DAN OFFLINE
  // ============================================================

  static Map<String, dynamic> _buildResult({
    required String category,
    required List<Map<String, String>> data,
    DateTime? startDate,
    DateTime? endDate,
    required int page,
    required int limit,
  }) {
    // ==========================================================
    // COPY DATA
    //
    // Supaya data cache asli tidak ikut berubah.
    // ==========================================================

    List<Map<String, String>> filteredData = data
        .map((item) => Map<String, String>.from(item))
        .toList();

    // ==========================================================
    // FILTER START DATE
    // ==========================================================

    if (startDate != null) {
      final String start = _formatDate(startDate);

      filteredData = filteredData.where((item) {
        final String itemDate = item['date'] ?? '';

        final String dateOnly = _getDateOnly(itemDate);

        if (dateOnly.isEmpty || dateOnly == '-') {
          return false;
        }

        return dateOnly.compareTo(start) >= 0;
      }).toList();
    }

    // ==========================================================
    // FILTER END DATE
    // ==========================================================

    if (endDate != null) {
      final String end = _formatDate(endDate);

      filteredData = filteredData.where((item) {
        final String itemDate = item['date'] ?? '';

        final String dateOnly = _getDateOnly(itemDate);

        if (dateOnly.isEmpty || dateOnly == '-') {
          return false;
        }

        return dateOnly.compareTo(end) <= 0;
      }).toList();
    }

    // ==========================================================
    // SORT LAGI
    //
    // Untuk memastikan data tetap rapi setelah filter.
    // ==========================================================

    filteredData.sort((a, b) {
      final DateTime? dateA = _parseDate(a['date']);

      final DateTime? dateB = _parseDate(b['date']);

      if (dateA == null && dateB == null) {
        return 0;
      }

      if (dateA == null) {
        return 1;
      }

      if (dateB == null) {
        return -1;
      }

      return dateB.compareTo(dateA);
    });

    // ==========================================================
    // PAGINATION
    // ==========================================================

    final int total = filteredData.length;

    final int safeLimit = limit.clamp(1, 100);

    final int safePage = page < 1 ? 1 : page;

    final int totalPages = total == 0 ? 1 : (total / safeLimit).ceil();

    final int currentPage = safePage > totalPages ? totalPages : safePage;

    final int startIndex = (currentPage - 1) * safeLimit;

    List<Map<String, String>> paginatedData = [];

    if (startIndex < total) {
      final int endIndex = (startIndex + safeLimit) > total
          ? total
          : startIndex + safeLimit;

      paginatedData = filteredData.sublist(startIndex, endIndex);
    }

    // ==========================================================
    // RESULT
    // ==========================================================

    return {
      'success': true,
      'status': 200,
      'message': 'OK',

      'category': category,

      'data': paginatedData,

      'pagination': {
        'current_page': currentPage,
        'per_page': safeLimit,
        'total_data': total,
        'total_pages': totalPages,
      },

      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // ============================================================
  // SAVE FULL CACHE
  // ============================================================

  static Future<void> _saveFullCache(
    Map<String, List<Map<String, String>>> categorizedData,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ==========================================================
    // BUAT DATA CACHE
    // ==========================================================

    final Map<String, dynamic> cacheData = {};

    for (final String category in availableCategories) {
      cacheData[category] = categorizedData[category] ?? [];
    }

    // ==========================================================
    // CACHE TIME
    // ==========================================================

    final String cacheTime = DateTime.now().toIso8601String();

    // ==========================================================
    // STRUKTUR CACHE
    // ==========================================================

    final Map<String, dynamic> cache = {
      'version': 6,

      'savedAt': DateTime.now().toIso8601String(),

      'cacheTime': cacheTime,

      'categories': cacheData,
    };

    // ==========================================================
    // SIMPAN SATU FULL CACHE
    //
    // Karena di dalamnya sudah ada:
    //
    // LGD Daily
    // HSI Daily
    // SNI Daily
    //
    // Data masing-masing tetap terpisah.
    // ==========================================================

    await prefs.setString(_fullCacheKey, jsonEncode(cache));
  }

  // ============================================================
  // GET FULL CACHE
  // ============================================================

  static Future<Map<String, List<Map<String, String>>>?> _getFullCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cached = prefs.getString(_fullCacheKey);

    if (cached == null || cached.trim().isEmpty) {
      return null;
    }

    try {
      final dynamic decoded = jsonDecode(cached);

      if (decoded is! Map) {
        return null;
      }

      final Map<String, dynamic> cache = Map<String, dynamic>.from(decoded);

      // ========================================================
      // CEK VERSION
      // ========================================================

      final int version = int.tryParse(cache['version']?.toString() ?? '') ?? 0;

      if (version != 6) {
        return null;
      }

      final dynamic categories = cache['categories'];

      if (categories is! Map) {
        return null;
      }

      final Map<String, List<Map<String, String>>> result = {
        'LGD Daily': [],
        'HSI Daily': [],
        'SNI Daily': [],
      };

      // ========================================================
      // BACA CATEGORY SATU PER SATU
      // ========================================================

      for (final String category in availableCategories) {
        final dynamic rawCategory = categories[category];

        if (rawCategory is! List) {
          continue;
        }

        final List<Map<String, String>> categoryData = [];

        for (final dynamic item in rawCategory) {
          if (item is! Map) {
            continue;
          }

          final Map<String, dynamic> map = Map<String, dynamic>.from(item);

          categoryData.add({
            'date': map['date']?.toString() ?? '-',
            'open': map['open']?.toString() ?? '-',
            'high': map['high']?.toString() ?? '-',
            'low': map['low']?.toString() ?? '-',
            'close': map['close']?.toString() ?? '-',
            'category': category,
          });
        }

        // ======================================================
        // SORT CACHE
        // ======================================================

        categoryData.sort((a, b) {
          final DateTime? dateA = _parseDate(a['date']);

          final DateTime? dateB = _parseDate(b['date']);

          if (dateA == null && dateB == null) {
            return 0;
          }

          if (dateA == null) {
            return 1;
          }

          if (dateB == null) {
            return -1;
          }

          return dateB.compareTo(dateA);
        });

        result[category] = categoryData;
      }

      return result;
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // GET CACHE TIME
  // ============================================================

  static Future<String?> getCacheTime({
    String category = defaultCategory,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cached = prefs.getString(_fullCacheKey);

    if (cached == null || cached.trim().isEmpty) {
      return null;
    }

    try {
      final dynamic decoded = jsonDecode(cached);

      if (decoded is! Map) {
        return null;
      }

      final Map<String, dynamic> cache = Map<String, dynamic>.from(decoded);

      // ========================================================
      // PASTIKAN CATEGORY VALID
      // ========================================================

      final String selectedCategory = _getCanonicalCategory(category);

      final dynamic categories = cache['categories'];

      if (categories is! Map) {
        return null;
      }

      final dynamic categoryData = categories[selectedCategory];

      if (categoryData is! List || categoryData.isEmpty) {
        return null;
      }

      return cache['cacheTime']?.toString();
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // CLEAR CACHE
  // ============================================================

  static Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_fullCacheKey);
  }

  // ============================================================
  // GET CANONICAL CATEGORY
  // ============================================================

  static String _getCanonicalCategory(String category) {
    final String normalized = _normalizeCategory(category);

    if (normalized == 'lgd' || normalized == 'lgd daily') {
      return 'LGD Daily';
    }

    if (normalized == 'hsi' || normalized == 'hsi daily') {
      return 'HSI Daily';
    }

    if (normalized == 'sni' || normalized == 'sni daily') {
      return 'SNI Daily';
    }

    // ==========================================================
    // CARI DARI CATEGORY RESMI
    // ==========================================================

    for (final String item in availableCategories) {
      if (_normalizeCategory(item) == normalized) {
        return item;
      }
    }

    // ==========================================================
    // DEFAULT
    // ==========================================================

    return defaultCategory;
  }

  // ============================================================
  // GET CANONICAL CATEGORY ATAU KOSONG
  // ============================================================

  static String _tryGetCanonicalCategory(String category) {
    final String normalized = _normalizeCategory(category);

    if (normalized == 'lgd' || normalized == 'lgd daily') {
      return 'LGD Daily';
    }

    if (normalized == 'hsi' || normalized == 'hsi daily') {
      return 'HSI Daily';
    }

    if (normalized == 'sni' || normalized == 'sni daily') {
      return 'SNI Daily';
    }

    return '';
  }

  // ============================================================
  // NORMALIZE CATEGORY
  // ============================================================

  static String _normalizeCategory(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  // ============================================================
  // GET DATE ONLY
  // ============================================================

  static String _getDateOnly(String value) {
    final String trimmed = value.trim();

    if (trimmed.isEmpty || trimmed == '-') {
      return '';
    }

    // ==========================================================
    // YYYY-MM-DD
    // ==========================================================

    if (trimmed.length >= 10 &&
        RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(trimmed)) {
      return trimmed.substring(0, 10);
    }

    // ==========================================================
    // YYYY/MM/DD
    // ==========================================================

    if (trimmed.length >= 10 &&
        RegExp(r'^\d{4}/\d{2}/\d{2}').hasMatch(trimmed)) {
      return trimmed.substring(0, 10).replaceAll('/', '-');
    }

    // ==========================================================
    // PARSE DATE
    // ==========================================================

    final DateTime? parsed = DateTime.tryParse(trimmed);

    if (parsed != null) {
      return _formatDate(parsed);
    }

    return '';
  }

  // ============================================================
  // PARSE DATE
  // ============================================================

  static DateTime? _parseDate(String? value) {
    if (value == null) {
      return null;
    }

    final String trimmed = value.trim();

    if (trimmed.isEmpty || trimmed == '-') {
      return null;
    }

    // ==========================================================
    // NORMAL ISO DATE
    // ==========================================================

    final DateTime? normal = DateTime.tryParse(trimmed);

    if (normal != null) {
      return normal;
    }

    // ==========================================================
    // DATE ONLY
    // ==========================================================

    final String dateOnly = _getDateOnly(trimmed);

    if (dateOnly.isEmpty) {
      return null;
    }

    return DateTime.tryParse(dateOnly);
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
