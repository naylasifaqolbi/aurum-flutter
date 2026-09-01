import 'dart:convert';

import 'package:http/http.dart' as http;

class HistoricalApiService {
  // ============================================================
  // BACKEND URL
  // ============================================================
  //
  // PENTING:
  //
  // Karena Flutter dijalankan di HP fisik,
  // JANGAN gunakan:
  //
  // 127.0.0.1
  // localhost
  //
  // Gunakan IPv4 laptop yang menjalankan Node.js.
  //
  // CONTOH:
  //
  // static const String baseUrl =
  //     'http://192.168.1.10:3000';
  //
  // GANTI 192.168.1.10 dengan IPv4 laptop kamu.
  //

  static const String baseUrl = 'http://IPkamu:3000';

  // ============================================================
  // GET HISTORICAL DATA
  // ============================================================

  static Future<Map<String, dynamic>> getHistoricalData({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    // ----------------------------------------------------------
    // QUERY PARAMETER
    // ----------------------------------------------------------

    final Map<String, String> queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    // ----------------------------------------------------------
    // START DATE
    // ----------------------------------------------------------

    if (startDate != null) {
      queryParameters['start_date'] = _formatDate(startDate);
    }

    // ----------------------------------------------------------
    // END DATE
    // ----------------------------------------------------------

    if (endDate != null) {
      queryParameters['end_date'] = _formatDate(endDate);
    }

    // ----------------------------------------------------------
    // URL
    // ----------------------------------------------------------

    final Uri uri = Uri.parse(
      '$baseUrl/api/historical-gold',
    ).replace(queryParameters: queryParameters);

    // ----------------------------------------------------------
    // DEBUG
    // ----------------------------------------------------------

    print('========================================');

    print('AURUM HISTORICAL API');

    print('Request URL: $uri');

    print('========================================');

    try {
      // --------------------------------------------------------
      // REQUEST
      // --------------------------------------------------------

      final http.Response response = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 20));

      // --------------------------------------------------------
      // DEBUG RESPONSE
      // --------------------------------------------------------

      print('HTTP Status: ${response.statusCode}');

      print('Response Body: ${response.body}');

      // --------------------------------------------------------
      // STATUS CODE
      // --------------------------------------------------------

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      // --------------------------------------------------------
      // RESPONSE KOSONG
      // --------------------------------------------------------

      if (response.body.isEmpty) {
        throw Exception('Response server kosong.');
      }

      // --------------------------------------------------------
      // JSON DECODE
      // --------------------------------------------------------

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Format response server tidak valid.');
      }

      final Map<String, dynamic> json = decoded;

      // --------------------------------------------------------
      // CEK SUCCESS
      // --------------------------------------------------------

      if (json['success'] != true) {
        throw Exception(json['message'] ?? 'Gagal mengambil data historical.');
      }

      // --------------------------------------------------------
      // RETURN
      // --------------------------------------------------------

      return json;
    } catch (error) {
      print('Historical API Error: $error');

      rethrow;
    }
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
