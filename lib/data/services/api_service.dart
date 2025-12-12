import 'dart:convert';
import 'package:bible_toolbox/core/helpers/boxes.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/data/services/raw_json_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl = "https://www.bibletoolbox.net/d7/marty-api/";

  /// Get all the data for the [languages]
  static Future<void> getData(List<LanguageClass> languages) async {
    /// All the different API types

    // // Get the api types from the api
    // List<String> apiTypes = await getApiTypes();
    // if (apiTypes.isEmpty) {
    //   // todo: error
    //   debugPrint('ApiTypes is empty');
    //   return;
    // }

    for (LanguageClass language in languages) {
      // Get the correct saving place for the language

      debugPrint('$language');
      bool succeeded = await getDataForLanguage(language);
      debugPrint(' data received\n');
    }
  }

  /// Retrieves data from API for [language]
  static Future<bool> getDataForLanguage(LanguageClass language) async {

    // Check if the data is already downloaded
    if (boxJsonData.get(language.code) != null) {
      debugPrint('Data not downloaded, $language is already in the device!');
      return false;
    }

    String url = "$baseUrl/articles?lang=${language.code}";

    /// Holds the API data for selected language
    List<Map<String, dynamic>> languageApiData = [];

    // Get the number of pages to go through
    int pageNumber = await getMaxPageCount(url);

    // Get the data from every page
    for (int i = 0; i <= pageNumber; i++) {
      final uri = Uri.parse("$url&limit=100&page=$i");
      final response = await http
          .get(uri)
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception("Request timed out");
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // Parse the data
        final List<Map<String, dynamic>> apiData =
        List<Map<String, dynamic>>.from(jsonData["data"]);
        languageApiData.addAll(apiData);
        debugPrint(' - page: $i succeeded (len: ${languageApiData.length})');
      } else {
        throw Exception(
          "Failed to load data. Status code: ${response.statusCode}",
        );
      }
    }
    // todo: save the data
    boxJsonData.put(language.code, RawJsonData(
        rawData: jsonEncode(languageApiData), languageCode: language.code));
    return true;
  }

  static Future<int> getMaxPageCount(String url) async {
    final uri = Uri.parse("$url&limit=1");
    final response = await http
        .get(uri)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception("Request timed out");
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      // Get the page count
      int articleCount = jsonData["meta"]["total"];
      debugPrint(' - Article count: $articleCount');
      return articleCount ~/ 100;
    } else {
      throw Exception(
        "Failed to load data. Status code: ${response.statusCode}",
      );
    }
  }

  static Future<Map<String, dynamic>> fetchData() async {
    final url = Uri.parse(
      "$baseUrl/articles?lang=et&type=vastauksia_etsiville&limit=5&page=0",
    );

    final response = await http
        .get(url)
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw Exception("Request timed out");
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return (jsonData["data"][1]);
    } else {
      throw Exception(
        "Failed to load data. Status code: ${response.statusCode}",
      );
    }
  }
}
