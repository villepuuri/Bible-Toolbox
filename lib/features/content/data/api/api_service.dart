import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bible_toolbox/features/content/data/services/box_service.dart';
import 'package:bible_toolbox/core/services/result.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl = "https://www.bibletoolbox.net/d7/marty-api";

  /// Retrieves data from API for [language]
  /// Returns false if data is already downloaded, true if succeeded
  static Future<Result<bool>> getDataForLanguage(
    LanguageClass language,
    Function? updateParent,
  ) async {
    // Check if the data is already downloaded
    // todo: maybe exists is not enough to check whether to download
    Result existResult = await BoxService.hiveBoxExists(language.code);
    if (existResult.value) {
      debugPrint('Data not downloaded, $language is already in the device!');
      return Result.ok(false);
    }

    // Get the time the data receiving starts
    DateTime updateTime = DateTime.now();

    // Call the Api
    Result languageApiDataResult = await handleApiCalls(
      language,
      updateParent: updateParent,
    );

    if (languageApiDataResult.isError) {
      return Result.error(languageApiDataResult.error);
    }

    // If the data was received, save it to the device
    Result<bool> savedResult = await BoxService.saveLanguageData(
      language.code,
      languageApiDataResult.value,
      updateTime,
    );
    if (savedResult.isError) return Result.error(savedResult.error);
    return Result.ok(true);
  }

  /// Checks for updates and if necessary, updates articles for loaded
  /// languages.
  /// Returns true, if articles were updated, false if updates was not found
  /// // todo: use this in loading
  static Future<Result<bool>> updateDataForLanguage(
    LanguageClass language,
  ) async {
    // Check if the language is loaded
    assert(
      BoxService.getInstalledLanguages().value.contains(language.code),
      'The selected language is not loaded and therefore will not be updated!',
    );

    // Get the lastUpdateTime for the language
    Result metaResult = BoxService.getInstalledLanguageMeta(language.code);
    int? lastUpdatedMs;
    if (metaResult.isOk) {
      lastUpdatedMs = metaResult.value?['lastUpdated'];
    }
    // If the time hasn't received, update all
    lastUpdatedMs ??= 0;

    // Convert Ms to s
    int lastUpdatedS = lastUpdatedMs ~/ 1000;

    // Get the time the data receiving starts
    DateTime updateTime = DateTime.now();

    // Call the API with a correct timestamp
    Result languageApiDataResult = await handleApiCalls(
      language,
      urlAddition: "&changed_since=$lastUpdatedS",
    );

    if (languageApiDataResult.isError) {
      return Result.error(languageApiDataResult.error);
    }

    debugPrint(
      ' - Articles to update for $language: ${languageApiDataResult.value.length}',
    );

    if (languageApiDataResult.value.isEmpty) {
      debugPrint(' - No articles to update, returning\n');
      return Result.ok(false);
    }

    // Make sure the box is open
    Result openResult = await BoxService.open(language.code);
    if (openResult.isError) return Result.error(openResult.error);

    Result<List<Map<String, dynamic>>> oldDataResult =
        BoxService.readLanguageBox(language.code);
    if (oldDataResult.isError) return Result.error(oldDataResult.error);

    // todo: Make documentation about how the data is updated
    for (final article in languageApiDataResult.value) {
      // Check if ID exists
      int articleIndex = oldDataResult.value.indexWhere(
        (e) => e['id'] == article['id'],
      );
      if (articleIndex != -1) {
        // ID exists, replace the current one
        oldDataResult.value[articleIndex] = article;
      } else {
        oldDataResult.value.add(article);
      }
    }

    // Save the updated data
    Result saveResult = await BoxService.saveLanguageData(
      language.code,
      oldDataResult.value,
      updateTime,
    );
    if (saveResult.isError) return Result.error(saveResult.error);
    return Result.ok(true);
  }

  ///
  /// Handles the API calling for getting data
  ///
  /// Returns an empty list if data could not be retrieved
  static Future<Result<List<Map<String, dynamic>>>> handleApiCalls(
    LanguageClass language, {
    Function? updateParent,
    String? urlAddition,
  }) async {
    // Create the url for the language
    String url = "$baseUrl/articles?lang=${language.code}";

    if (urlAddition != null) {
      url += urlAddition;
    }

    debugPrint(' - URL to be used: $url');

    /// Holds the API data for selected language
    List<Map<String, dynamic>> languageApiData = [];

    try {
      // Get the number of pages to go through
      Result pageCountResult = await getMaxPageCount(url);

      if (pageCountResult.isError) return Result.error(pageCountResult.error);

      // Get the data from every page
      for (int i = 0; i <= pageCountResult.value; i++) {
        // Update the loading value
        language.setLoadingValue((i + 1) / (pageCountResult.value + 1));
        if (updateParent != null) {
          updateParent();
        }

        // Get the page-specific url
        final uri = Uri.parse("$url&limit=100&page=$i");
        final response = await http
            .get(uri)
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw TimeoutException(
                  "Getting the article data took too long",
                );
              },
            );

        if (response.statusCode != 200) {
          throw HttpException(
            "Failed to load data. Status code: ${response.statusCode}",
          );
        }

        final jsonData = jsonDecode(response.body);
        // Parse the data
        final List<Map<String, dynamic>> apiData =
            List<Map<String, dynamic>>.from(jsonData["data"]);
        languageApiData.addAll(apiData);
        debugPrint(' - page: $i succeeded (len: ${languageApiData.length})');
      }
      // Return the collected data
      return Result.ok(languageApiData);
    } on SocketException catch (e) {
      return Result.error(
        SocketException('Could not get the page count: ${e.message}'),
      );
    } on TimeoutException catch (e) {
      return Result.error(TimeoutException('Timeout: ${e.message}'));
    } on FormatException catch (e) {
      return Result.error(FormatException('Invalid JSON format: ${e.message}'));
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  ///
  /// Returns the number of the pages for a specific url
  ///
  static Future<Result<int>> getMaxPageCount(String url) async {
    try {
      final uri = Uri.parse("$url&limit=1");
      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Getting the page count took too long');
            },
          );

      // Return if invalid response code
      if (response.statusCode != 200) {
        return Result.error(
          HttpException(
            'Failed to load data. Status code: ${response.statusCode}',
          ),
        );
      }

      // Extract the data
      final jsonData = jsonDecode(response.body);
      if (jsonData["data"].isEmpty) {
        return Result.error(
          HttpException("Invalid url, data not got: ${"$url&limit=1"}"),
        );
      }

      // Get the page count
      int articleCount = jsonData["meta"]["total"];
      debugPrint(' - Article count: $articleCount');

      // Return the correct result
      return Result.ok(articleCount ~/ 100);
    } on SocketException catch (e) {
      return Result.error(
        SocketException('Could not get the page count: ${e.message}'),
      );
    } on TimeoutException catch (e) {
      return Result.error(TimeoutException('Timeout: ${e.message}'));
    } on FormatException catch (e) {
      return Result.error(FormatException('Invalid JSON format: ${e.message}'));
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }
}
