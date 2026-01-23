import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'boxes.dart';

// todo: Implement clear sync functions, remove unnecessary futures

class BoxService {
  static const _languagesKey = "languages";

  static getBoxName(String langCode) => 'api_data_$langCode';

  // *****************************
  //       META functions
  // *****************************

  static List<String> getInstalledLanguages() {
    final languages = readMeta();
    return (languages as Map).keys.cast<String>().toList();
  }

  static Map<String, dynamic>? getInstalledLanguageMeta(String langCode) {
    return readMeta()[langCode];
  }

  /// Formats the meta output correctly
  static Map<String, Map<String, dynamic>> readMeta() {
    final raw = boxMeta.get('languages', defaultValue: {});
    return Map<String, Map<String, dynamic>>.from(
      (raw as Map).map(
        (k, v) => MapEntry(k as String, Map<String, dynamic>.from(v as Map)),
      ),
    );
  }

  // *****************************
  //     LANGUAGE functions
  // *****************************

  static Future<Box> open(String langCode) {
    return Hive.openBox(getBoxName(langCode));
  }

  static Future<bool> hiveBoxExists(String langCode) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${getBoxName(langCode)}.hive');
    bool exists = await file.exists();
    debugPrint(' - Does ${getBoxName(langCode)} exist: $exists');
    return file.exists();
  }

  /// Save the data to Hive
  static Future<void> saveLanguageData(
    String langCode,
    List<Map<String, dynamic>> data,
    DateTime updateTime, {
    int version = 1,
  }) async {
    final box = await BoxService.open(langCode);

    await box.put('data', data);
    await box.put('version', version);
    // await box.put('lastUpdated', DateTime.now().millisecondsSinceEpoch);

    // Update meta info
    final languages = readMeta();
    languages[langCode] = {
      'version': version,
      'lastUpdated': updateTime.millisecondsSinceEpoch,
    };
    await boxMeta.put(_languagesKey, languages);

    debugPrint(' - Data saved - $languages');
  }

  /// Removes a language box and updates metadata
  static Future<void> delete(String langCode) async {
    // Get the metadata
    final languages = readMeta();
    languages.remove(langCode);
    // Delete the box
    await Hive.deleteBoxFromDisk(getBoxName(langCode));
    // Update the metadata
    await boxMeta.put(_languagesKey, languages);
    debugPrint(' - Language: $langCode deleted successfully!');
  }

  /// Formats the Box data correctly
  static List<Map<String, dynamic>> readLanguageBox(String languageCode) {
    // Get the raw data List<dynamic>
    final raw = Hive.box(
      getBoxName(languageCode),
    ).get('data', defaultValue: {});
    return List<Map<String, dynamic>>.from(
      (raw as List).map((article) => Map<String, dynamic>.from(article as Map)),
    );
  }

  /// Get all the articles from a memory with [languageCode]
  static List<Map<String, dynamic>> getAllArticles(String languageCode) {
    return readLanguageBox(languageCode);
  }

  /// Get articles based on the type
  static List<Map<String, dynamic>> getArticles(
    String languageCode,
    String? type,
  ) {
    List<Map<String, dynamic>> allData = readLanguageBox(languageCode);
    if (type == null) {
      return allData;
    } else {
      return allData.where((element) => element['type'] == type).toList();
    }
  }

  static Map<String, dynamic> getArticleById(String languageCode, int id) {
    List<Map<String, dynamic>> allData = readLanguageBox(languageCode);
    Map<String, dynamic> result = allData.firstWhere(
      (e) => e['id'] == id,
      orElse: () => {},
    );
    return result;
  }

  static Map<String, dynamic> getArticleByTitle(
    String languageCode,
    String title,
  ) {
    List<Map<String, dynamic>> allData = getArticles(
      languageCode,
      'vastauksia_etsiville',
    );
    Map<String, dynamic> result = allData.firstWhere(
      (e) => e['title'] == title,
      orElse: () => {},
    );
    return result;
  }

  /// Gets all the possible types for a language
  static List<String> getAvailableTypes(String languageCode) {
    List<Map<String, dynamic>> allData = readLanguageBox(languageCode);
    List<String> allTypes = allData
        .map<String>((e) => e['type'])
        .toSet()
        .toList();
    debugPrint(' - Available types: $allTypes');
    return allTypes;
  }

  /// Returns the size of a data box in mega bytes
  /// example: "12 MB"
  ///
  /// If it cannot be read, returns '0'
  static Future<String> getHiveBoxSizeMB(String langCode) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${getBoxName(langCode)}.hive');

    if (await file.exists()) {
      int bytes = await file.length();
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '0';
  }
}
