import 'package:bible_toolbox/core/services/result.dart';
import 'package:bible_toolbox/features/content/data/services/box_service.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/material.dart';

// todo: Redirect these urls to correct places
/// This function is not used in the app.
/// This is used to get some specific data helping building the code
class HelperDataExtraction {
  /// Get all the internal links that need to be then redirected
  static Future<void> getAllInternalLinks() async {
    for (LanguageClass language in LanguageHelper.loadedLanguages) {
      // Open the box
      await BoxService.open(language.code);

      debugPrint(language.toString());

      Result<List<Map<String, dynamic>>> dataResult = BoxService.getArticles(
        language.code,
        null,
      );

      if (dataResult.isError) return;

      debugPrint('Article length: ${dataResult.value.length}');

      int totalCount = 0;

      for (final element in dataResult.value) {
        RegExp linkMatcher = RegExp(
          r'(www.bibletoolbox.net)(.*?)($|\s|"|\))',
          dotAll: true,
        );
        final matches = linkMatcher.allMatches(element['body']["value"]);

        for (final match in matches) {
          totalCount++;
          String urlTail = match.group(2) ?? "";

          RegExp wordSeparatorRE = RegExp(r'([\w-%#]*)$');
          String? word = wordSeparatorRE.firstMatch(urlTail)?.group(1);

          if (word != null) {
            debugPrint(
              '${language.code} - ${element["id"].toString()}\t$word',
            );
          } else {
            debugPrint(
              '${language.code} - ${element["id"].toString()}\t$urlTail',
            );
          }


        }
      }
      debugPrint('Total count for ${language.toString()}: $totalCount');
      debugPrint('');
    }
  }

  static void getDoubles() {
    final questions = BoxService.getArticles('fi', 'vastauksia_etsiville');
    if (questions.isError) return;
    Map<String, int> allData = {};
    Map<String, int> multiples = {};
    List<String> keys = [];

    for (final item in questions.value) {
      String title = item['title'];
      if (allData.keys.contains(title)) {
        // contains
        if (multiples.keys.contains(title)) {
          int current = multiples[title] ?? 5;
          multiples[title] = current + 1;
        } else {
          multiples[title] = 2;
          keys.add(title);
        }
      } else {
        allData[title] = 1;
      }
    }
    debugPrint('Multiples');
    multiples.keys.map((e) => debugPrint('Multiple: $e'));
  }
}
