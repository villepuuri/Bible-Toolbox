import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

late Box boxBookmarks;
late Box boxMeta;

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

  /// Formats the meta output correctly
  static Map<String, Map<String, dynamic>> readMeta() {
    final raw = boxMeta.get('languages', defaultValue: {});
    return Map<String, Map<String, dynamic>>.from(
      (raw as Map).map(
            (k, v) => MapEntry(
          k as String,
          Map<String, dynamic>.from(v as Map),
        ),
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
    return file.exists();
  }

  /// Save the data to Hive
  static Future<void> saveLanguageData(
    String langCode,
    List<Map<String, dynamic>> data, {
    int version = 1,
  }) async {
    final box = await BoxService.open(langCode);

    await box.put('data', data);
    await box.put('version', version);
    await box.put('lastUpdated', DateTime.now());

    // Update meta info
    final languages = readMeta();
    languages[langCode] = {
      'version': version,
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
    };
    await boxMeta.put(_languagesKey, languages);

    debugPrint(' - Data saved - $languages');
  }

  /// Removes a language box
  static Future<void> delete(String langCode) async {
    debugPrint('Before error 1');
    // Update the metadata
    final languages = readMeta();
    debugPrint('Before error 2');
    languages.remove(langCode);
    debugPrint('Before error 3');
    await boxMeta.put(_languagesKey, languages);
    debugPrint('Before error 4');
    // Delete the box
    await Hive.deleteBoxFromDisk(getBoxName(langCode));
    debugPrint('Before error 5');
    debugPrint(' - Language: $langCode deleted successfully!');
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
