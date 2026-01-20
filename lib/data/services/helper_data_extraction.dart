import 'package:bible_toolbox/core/helpers/box_service.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
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

      List<Map<String, dynamic>> data = BoxService.getArticles(
        language.code,
        null,
      );

      debugPrint('Article length: ${data.length}');

      int totalCount = 0;

      for (final element in data) {
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
}
