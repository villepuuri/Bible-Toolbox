import 'dart:io';

import 'package:bible_toolbox/core/services/result.dart';
import 'package:bible_toolbox/features/content/data/api/api_service.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter_test/flutter_test.dart';

/*
* To run this, put the following code to the terminal:
* flutter test test/api_test.dart
* */

void main() {
  group('Maximum page counts from different URLs', () {
    test('_1 (Fi pages)', () async {
      Result pageCount = await ApiService.getMaxPageCount(
        'https://www.bibletoolbox.net/d7/marty-api/articles?lang=fi&type=raamattu',
      );
      expect(pageCount.value, 2);
    });

    test('_2 (ar pages)', () async {
      Result pageCount = await ApiService.getMaxPageCount(
        'https://www.bibletoolbox.net/d7/marty-api/articles?lang=ar&type=raamattu',
      );
      expect(pageCount.value, 0);
    });

    test('_3 (Wrong url)', () async {
      Result pageCount = await ApiService.getMaxPageCount(
        'https://www.bibletoolbox.net/d7/marty-api/articles?lang=ei_toimi',
      );
      expect(pageCount.isError, true);
      expect(pageCount.error.runtimeType, HttpException);
    });
  });

  group("API calls", () {
    test("_1 (Basic call)", () async {
      String langCode = 'fi';
      Result result = await ApiService.handleApiCalls(
        LanguageHelper.languages.firstWhere((e) => e.code == langCode),
        urlAddition: "&limit=4",
      );
      result.value.shuffle();
      expect(result.value.first['language'], langCode);
    });

    test("_2 (All articles)", () async {
      Result result = await ApiService.handleApiCalls(
        LanguageHelper.languages.firstWhere((e) => e.code == 'fi'),
      );
      expect(result.value.length, 324);
    });

    test("_3 (Http fail)", () async {
      Result result = await ApiService.handleApiCalls(
        LanguageHelper.languages.firstWhere((e) => e.code == 'fi'),
        urlAddition: '_',
      );
      expect(result.isError, true);
      expect(result.error.runtimeType, HttpException);
    });
  });
}
