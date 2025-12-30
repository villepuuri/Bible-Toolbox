import 'dart:convert';
import 'package:bible_toolbox/core/helpers/box_service.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl = "https://www.bibletoolbox.net/d7/marty-api";

  /// Retrieves data from API for [language]
  static Future<bool> getDataForLanguage(
    LanguageClass language,
    Function? updateParent,
  ) async {
    // Check if the data is already downloaded
    if (await BoxService.hiveBoxExists(language.code)) {
      debugPrint('Data not downloaded, $language is already in the device!');
      return false;
    }

    // Get the time the data receiving starts
    DateTime updateTime = DateTime.now();

    // Call the Api
    List<Map<String, dynamic>> languageApiData = await handleApiCalls(
      language,
      updateParent: updateParent,
    );

    await BoxService.saveLanguageData(
      language.code,
      languageApiData,
      updateTime,
    );
    return true;
  }

  static Future<bool> updateDataForLanguage(LanguageClass language) async {
    // Check if the language is loaded
    assert(
      BoxService.getInstalledLanguages().contains(language.code),
      'The selected language is not loaded and therefore will not be updated!',
    );

    // Get the lastUpdateTime for the language
    int? lastUpdatedMs = BoxService.getInstalledLanguageMeta(
      language.code,
    )?['lastUpdated'];

    if (lastUpdatedMs == null) {
      debugPrint(' ~ LastUpdated info null, not updating');
      return false;
    }

    int lastUpdatedS = lastUpdatedMs ~/ 1000;

    // Get the time the data receiving starts
    DateTime updateTime = DateTime.now();

    // Call the API
    List<Map<String, dynamic>> languageApiData = await handleApiCalls(
      language,
      urlAddition: "&changed_since=$lastUpdatedS",
    );

    debugPrint(
      ' - Articles to update for $language: ${languageApiData.length}',
    );

    if (languageApiData.isEmpty) {
      debugPrint(' - No articles to update, returning\n');
      return false;
    }

    List<Map<String, dynamic>> oldData = await BoxService.getAllArticles(
      language.code,
    );
    for (final article in languageApiData) {
      // Check if ID exists
      int articleIndex = oldData.indexWhere((e) => e['id'] == article['id']);
      if (articleIndex != -1) {
        // ID exists, replace the current one
        oldData[articleIndex] = article;
      } else {
        oldData.add(article);
      }
    }

    // Save the updated data
    await BoxService.saveLanguageData(
      language.code,
      oldData,
      updateTime,
    );
    return true;
  }

  /// Handles the API calling for getting data
  static Future<List<Map<String, dynamic>>> handleApiCalls(
    LanguageClass language, {
    Function? updateParent,
    String? urlAddition,
  }) async {
    String url = "$baseUrl/articles?lang=${language.code}";

    if (urlAddition != null) {
      url += urlAddition;
    }

    debugPrint(' - URL to be used: $url');

    /// Holds the API data for selected language
    List<Map<String, dynamic>> languageApiData = [];

    // Get the number of pages to go through
    int pageNumber = await getMaxPageCount(url);

    // Get the data from every page
    for (int i = 0; i <= pageNumber; i++) {
      // Update the loading value
      language.setLoadingValue((i + 1) / (pageNumber + 1));
      if (updateParent != null) {
        updateParent();
      }

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
    return languageApiData;
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
}
