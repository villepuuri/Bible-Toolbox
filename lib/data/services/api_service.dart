import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{

  static final String baseUrl = "https://www.bibletoolbox.net/d7/marty-api/";

  static Future<String> fetchData() async {
    final url = Uri.parse("$baseUrl/articles?lang=fi&type=raamattu&limit=5");

    final response = await http.get(url).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw Exception("Request timed out");
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return (jsonData["data"][1]["body"]["value"]);
    } else {
      throw Exception(
        "Failed to load data. Status code: ${response.statusCode}",
      );
    }
  }


}