import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  static const String apiKey = '40e690675c4052f78f7a75fd'; 
  static const String baseUrl = 'https://open.er-api.com/v6/latest';
  //static const String baseUrl = 'https://v6.exchangerate-api.com/v6/40e690675c4052f78f7a75fd/latest';

  static Future<List<String>> fetchCurrencies() async {
    final response = await http.get(Uri.parse('$baseUrl/USD'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['rates'] as Map<String, dynamic>).keys.toList();
    } else {
      throw Exception('Failed to fetch currencies');
    }
  }

  static Future<double> convertCurrency(String from, String to) async {
    final response = await http.get(Uri.parse('$baseUrl/$from'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['rates'][to];
    } else {
      throw Exception('Failed to fetch conversion rate');
    }
  }
}
