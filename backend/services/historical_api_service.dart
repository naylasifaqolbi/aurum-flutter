import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoricalApiService {
  /*
  |--------------------------------------------------------------------------
  | ANDROID EMULATOR
  |--------------------------------------------------------------------------
  |
  | localhost Android emulator mengarah ke emulator itu sendiri.
  | Karena backend berada di komputer, gunakan 10.0.2.2.
  |
  */

  static const String baseUrl = 'http://10.0.2.2:3000';

  /*
  |--------------------------------------------------------------------------
  | GET HISTORICAL DATA
  |--------------------------------------------------------------------------
  */

  static Future<Map<String, dynamic>> getHistoricalData({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 10,
  }) async {
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

    final uri = Uri.parse(
      '$baseUrl/api/historical-gold',
    ).replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    if (json['success'] != true) {
      throw Exception(json['message'] ?? 'Failed to load data');
    }

    return json;
  }

  /*
  |--------------------------------------------------------------------------
  | FORMAT DATE
  |--------------------------------------------------------------------------
  */

  static String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');

    final String day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }
}
