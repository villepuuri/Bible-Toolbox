import 'package:bible_toolbox/core/services/result.dart';
import 'package:bible_toolbox/features/content/data/services/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// todo: Implement clear sync functions, remove unnecessary futures

class BoxService {
  static const _languagesKey = "languages";

  static String getBoxName(String langCode) => 'api_data_$langCode';

  // *****************************
  //       META functions
  // *****************************

  static Result<List<String>> getInstalledLanguages() {
    Result<Map<String, Map<String, dynamic>>> languagesResult = readMeta();
    if (languagesResult.isError) {
      return Result.error(languagesResult.error);
    }
    return Result.ok(
      (languagesResult.value as Map).keys.cast<String>().toList(),
    );
  }

  static Result<Map<String, dynamic>?> getInstalledLanguageMeta(
    String langCode,
  ) {
    Result result = readMeta();
    if (result.isError) {
      return Result.error(result.error);
    }
    return result.value[langCode];
  }

  /// Formats the meta output correctly
  static Result<Map<String, Map<String, dynamic>>> readMeta() {
    try {
      final raw = boxMeta.get('languages', defaultValue: {});
      return Result.ok(
        Map<String, Map<String, dynamic>>.from(
          (raw as Map).map(
            (k, v) =>
                MapEntry(k as String, Map<String, dynamic>.from(v as Map)),
          ),
        ),
      );
    } on HiveError catch (e) {
      return Result.error(Exception(e.message));
    } on TypeError catch (e) {
      return Result.error(Exception(e.stackTrace));
    } on FormatException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  // *****************************
  //     LANGUAGE functions
  // *****************************

  /// Opens or makes sure that the box is open
  static Future<Result<Box>> open(String langCode) async {
    try {
      Box box = await Hive.openBox(getBoxName(langCode));
      return Result.ok(box);
    } on HiveError catch (e) {
      return Result.error(Exception(e.message));
    } on TypeError catch (e) {
      return Result.error(Exception(e.stackTrace));
    } on FormatException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  static Future<Result<bool>> hiveBoxExists(String langCode) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${getBoxName(langCode)}.hive');
      bool exists = await file.exists();
      debugPrint(' - Does ${getBoxName(langCode)} exist: $exists');
      return Result.ok(await file.exists());
    } on HiveError catch (e) {
      return Result.error(Exception(e.message));
    } on TypeError catch (e) {
      return Result.error(Exception(e.stackTrace));
    } on FormatException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Save the data to Hive
  static Future<Result<bool>> saveLanguageData(
    String langCode,
    List<Map<String, dynamic>> data,
    DateTime updateTime, {
    int version = 1,
  }) async {
    try {
      Result<Box<dynamic>> boxResult = await BoxService.open(langCode);

      if (boxResult.isError) {
        return Result.error(boxResult.error);
      }

      await boxResult.value.put('data', data);
      await boxResult.value.put('version', version);

      // Update meta info
      final languagesResult = readMeta();
      if (languagesResult.isError) {
        return Result.error(languagesResult.error);
      }
      languagesResult.value[langCode] = {
        'version': version,
        'lastUpdated': updateTime.millisecondsSinceEpoch,
      };
      await boxMeta.put(_languagesKey, languagesResult.value);

      debugPrint(' - Data saved - ${languagesResult.value}');

      return Result.ok(true);
    } on HiveError catch (e) {
      return Result.error(Exception(e.message));
    } on TypeError catch (e) {
      return Result.error(Exception(e.stackTrace));
    } on FormatException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Removes a language box and updates metadata
  static Future<Result<bool>> delete(String langCode) async {
    try {
      // Get the metadata
      Result<Map<String, Map<String, dynamic>>> languagesResult = readMeta();
      if (languagesResult.isError) {
        return Result.error(languagesResult.error);
      }
      languagesResult.value.remove(langCode);
      // Delete the box
      await Hive.deleteBoxFromDisk(getBoxName(langCode));
      // Update the metadata
      await boxMeta.put(_languagesKey, languagesResult.value);
      debugPrint(' - Language: $langCode deleted successfully!');
      return Result.ok(true);
    } on HiveError catch (e) {
      return Result.error(Exception(e.message));
    } on TypeError catch (e) {
      return Result.error(Exception(e.stackTrace));
    } on FormatException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Formats the Box data correctly
  /// Get all the articles from a memory with [languageCode]
  static Result<List<Map<String, dynamic>>> readLanguageBox(
    String languageCode,
  ) {
    try {
      // Get the raw data List<dynamic>
      final raw = Hive.box(
        getBoxName(languageCode),
      ).get('data', defaultValue: {});
      return Result.ok(
        List<Map<String, dynamic>>.from(
          (raw as List).map(
            (article) => Map<String, dynamic>.from(article as Map),
          ),
        ),
      );
    } on HiveError catch (e) {
      return Result.error(Exception(e.message));
    } on TypeError catch (e) {
      return Result.error(Exception(e.stackTrace));
    } on FormatException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Get articles based on the type
  static Result<List<Map<String, dynamic>>> getArticles(
    String languageCode,
    String? type,
  ) {
    Result<List<Map<String, dynamic>>> allDataResult = readLanguageBox(
      languageCode,
    );
    if (allDataResult.isError) {
      return Result.error(allDataResult.error);
    }
    if (type == null) {
      return Result.ok(allDataResult.value);
    } else {
      return Result.ok(
        allDataResult.value
            .where((element) => element['type'] == type)
            .toList(),
      );
    }
  }

  static Result<Map<String, dynamic>> getArticleById(
    String languageCode,
    int id,
  ) {
    Result<List<Map<String, dynamic>>> allDataResult = readLanguageBox(
      languageCode,
    );
    // Return if error
    if (allDataResult.isError) return Result.error(allDataResult.error);

    Map<String, dynamic> result = allDataResult.value.firstWhere(
      (e) => e['id'] == id,
      orElse: () => {},
    );
    return Result.ok(result);
  }

  static Result<Map<String, dynamic>> getArticleByTitle(
    String languageCode,
    String title,
  ) {
    Result<List<Map<String, dynamic>>> allDataResult = getArticles(
      languageCode,
      'vastauksia_etsiville',
    );
    // return if error
    if (allDataResult.isError) return Result.error(allDataResult.error);

    Map<String, dynamic> result = allDataResult.value.firstWhere(
      (e) => e['title'] == title,
      orElse: () => {},
    );
    return Result.ok(result);
  }

  /// Gets all the possible types for a language
  static Result<List<String>> getAvailableTypes(String languageCode) {
    Result<List<Map<String, dynamic>>> allDataResult = readLanguageBox(
      languageCode,
    );
    if (allDataResult.isError) return Result.error(allDataResult.error);

    List<String> allTypes = allDataResult.value
        .map<String>((e) => e['type'])
        .toSet()
        .toList();
    debugPrint(' - Available types: $allTypes');
    return Result.ok(allTypes);
  }

  /// Returns the size of a data box in mega bytes
  /// example: "12 MB"
  ///
  /// If it cannot be read, returns '0'
  static Future<Result<String>> getHiveBoxSizeMB(String langCode) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${getBoxName(langCode)}.hive');

      if (await file.exists()) {
        int bytes = await file.length();
        return Result.ok('${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB');
      }
      return Result.ok('');
    } on HiveError catch (e) {
      return Result.error(Exception(e.message));
    } on TypeError catch (e) {
      return Result.error(Exception(e.stackTrace));
    } on FormatException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }
}
