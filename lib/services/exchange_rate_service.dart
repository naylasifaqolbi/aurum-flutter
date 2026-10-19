import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  Future<double> getUsdToIdr() async {
    final uri = Uri.parse('https://open.er-api.com/v6/latest/USD');

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data kurs.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['result'] != 'success') {
      throw Exception('Data kurs tidak tersedia.');
    }

    final rates = data['rates'] as Map<String, dynamic>;
    final rate = rates['IDR'];

    if (rate is! num || rate <= 0) {
      throw Exception('Nilai kurs USD/IDR tidak valid.');
    }

    return rate.toDouble();
  }
}
