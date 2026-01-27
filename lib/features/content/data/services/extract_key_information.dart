import 'package:bible_toolbox/core/services/result.dart';
import 'package:bible_toolbox/features/content/data/models/article_data.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/material.dart';

class ExtractKeyInformation {
  // todo: replace this with a better approach
  static Map<String, int> homePageIndices = {'fi': 21, 'en': 15};

  /// Get the main categories (Bible, Answers, Catechism, ...) for a specific language
  static Result<Map<String, Map<String, dynamic>>> getMainCategories(String langCode) {
    debugPrint('**********************************');
    debugPrint('  Extracting the main categories  ');

    int articleId = homePageIndices[langCode] ?? -1;
    if (articleId < 0) {
      return Result.error(Exception("Id not provided"));
    }

    Result<ArticleData> articleResult = LanguageHelper.getArticleById(
      langCode,
      articleId,
    );
    if (articleResult.isError) return Result.error(articleResult.error);

    ArticleData article = articleResult.value;

    // Remove all the comments
    RegExp commentRE = RegExp(r'<!-*.*?-*>', dotAll: true);
    String data = article.body.replaceAll(commentRE, '');

    final elementRegExp = RegExp(r'\[!(.*?)-{3,}\|-{3,}', dotAll: true);
    List<String?> elements = elementRegExp
        .allMatches(data)
        .map((e) => e.group(0))
        .toList();
    debugPrint(' - category length: ${elementRegExp.allMatches(data).length}');

    Map<String, Map<String, dynamic>> categoryMap = {};
    for (final element in elements) {
      if (element == null) continue;
      // Image string
      RegExp imageRE = RegExp(r'/(\w{2,})(?=\.png)', multiLine: true);
      String? imageString = imageRE
          .firstMatch(element)
          ?.group(1)
          ?.replaceAll("\n", "");

      // Path string
      RegExp pathRE = RegExp(r'(\w{2,})(?=)\)\s\|', multiLine: true);
      String? pathString = pathRE
          .firstMatch(element)
          ?.group(1)
          ?.replaceAll("\n", "");

      // URL string
      RegExp linkTextRE = RegExp(
        r'(?<=)\s\|\s\[(.*?)].*?\)(.*?)-{3,}',
        dotAll: true,
      );
      RegExpMatch? labelMatch = linkTextRE.firstMatch(element);
      String? labelString =
          ((labelMatch?.group(1) ?? "") + (labelMatch?.group(2) ?? ""))
              .replaceAll("\n", "")
              .trim();

      assert(imageString != null, "ImageString is null");
      assert(pathString != null, "PathString is null");
      if (imageString == null || pathString == null) continue;

      categoryMap[labelString] = {
        'path': pathString,
        'image': imageString,
        'group1': labelMatch?.group(1) ?? "",
        'group2': labelMatch?.group(2) ?? "",
      };
    }
    return Result.ok(categoryMap);
  }
}
