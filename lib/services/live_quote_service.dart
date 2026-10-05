import 'dart:convert';

import 'package:http/http.dart' as http;

class LiveQuoteService {
  // ============================================================
  // BASE URL
  // ============================================================

  static const String baseUrl =
      'https://newsmaker.id/api/live-quotes';

  // ============================================================
  // REQUEST TIMEOUT
  // ============================================================

  static const Duration _requestTimeout = Duration(seconds: 15);

  // ============================================================
  // GET OPEN PRICE
  // ============================================================

  static Future<double?> getOpenPrice(String symbol) async {
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

      // ==========================================================
      // CEK STATUS HTTP
      // ==========================================================

      if (response.statusCode != 200) {
        return null;
      }

      // ==========================================================
      // CEK BODY
      // ==========================================================

      if (response.body.trim().isEmpty) {
        return null;
      }

      // ==========================================================
      // PARSE JSON
      // ==========================================================

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        return null;
      }

      final Map<String, dynamic> json =
          Map<String, dynamic>.from(decoded);

      // ==========================================================
      // AMBIL DATA
      // ==========================================================

      final dynamic rawData = json['data'];

      if (rawData is! List) {
        return null;
      }

      // ==========================================================
      // CARI SYMBOL
      // ==========================================================

      for (final dynamic item in rawData) {
        if (item is! Map) {
          continue;
        }

        final Map<String, dynamic> data =
            Map<String, dynamic>.from(item);

        if (data['symbol']?.toString() == symbol) {
          final dynamic open = data['open'];

          if (open == null) {
            return null;
          }

          return double.tryParse(open.toString());
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}