import 'package:bible_toolbox/features/content/data/api/api_service.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter_test/flutter_test.dart';

/*
* To run this, put the following code to the terminal:
* flutter test test/api_test.dart
* */

void main() {
  group('Maximum page counts from different URLs', () {
    test(' - 1', () async {
      int pageCount = await ApiService.getMaxPageCount(
        'https://www.bibletoolbox.net/d7/marty-api/articles?lang=fi&type=raamattu',
      );
      expect(pageCount, 2);
    });

    test(' - 2', () async {
      int pageCount = await ApiService.getMaxPageCount(
        'https://www.bibletoolbox.net/d7/marty-api/articles?lang=ar&type=raamattu',
      );
      expect(pageCount, 0);
    });
  });

  group("API calls", () {
    test("Basic call", () async {
      String langCode = 'fi';
      List<Map<String, dynamic>> result = await ApiService.handleApiCalls(
        LanguageHelper.languages.firstWhere((e) => e.code == langCode),
        urlAddition: "&limit=4"
      );
      result.shuffle();
      expect(result.first['language'], langCode);
    });
    test("All articles", () async {
      List<Map<String, dynamic>> result = await ApiService.handleApiCalls(
          LanguageHelper.languages.firstWhere((e) => e.code == 'fi'),
      );
      expect(result.length, 324);
    });
  });
}
