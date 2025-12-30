import 'dart:convert';

import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() async {
  List<Map<String, dynamic>> apiLanguages = [];

  // Get the languages from the api
  final uri = Uri.parse('https://www.bibletoolbox.net/d7/marty-api/languages');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    // Parse the data
    apiLanguages = List<Map<String, dynamic>>.from(jsonData["data"]);
  } 
  


  group("All languages included", () {
    test("All included", () {
      List<String> apiCodes = apiLanguages.map<String>((e) => e['code']).toList();
      apiCodes.sort();
      List<String> deviceCodes = LanguageHelper.languages.map((e) => e.code).toList();
      deviceCodes.sort();
      expect(apiCodes.length, deviceCodes.length);
      for (int i = 0; i < apiCodes.length; i++) {
        expect(apiCodes[i], deviceCodes[i]);
      }
    });
  });
}