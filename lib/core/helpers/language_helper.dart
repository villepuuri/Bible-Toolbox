
import 'package:bible_toolbox/core/helpers/box_service.dart';
import 'package:bible_toolbox/data/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class LanguageClass {
  final String displayName;
  final String? englishName;
  final String abbreviation;
  final String languagePacketSize;

  const LanguageClass({
    required this.displayName,
    this.englishName,
    required this.abbreviation,
    required this.languagePacketSize,
  });

  /// Get a text to display for the language
  ///
  /// For non-Latin alphabet, this adds an English name of the language as well.
  String get fullName =>
      englishName != null ? '$displayName ($englishName)' : displayName;

  // An easier way to get the language code
  String get code => abbreviation;

  @override
  String toString() => "$displayName ($abbreviation)";
}

/// LanguageHelper is a general class that uses ApiService and BoxService classes
/// to handle the language functions
class LanguageHelper {

  /// List of all available languages
  static const List<LanguageClass> languages = [
    LanguageClass(
      displayName: "العربية",
      englishName: "Arabic",
      abbreviation: "ar",
      languagePacketSize: "1 MB",
    ),
    LanguageClass(
      displayName: "မြန်မာဘာသာ",
      englishName: "Burmese",
      abbreviation: "my",
      languagePacketSize: "2 MB",
    ),
    LanguageClass(
      displayName: "Eesti",
      abbreviation: "et",
      languagePacketSize: "3 MB",
    ),
    LanguageClass(
      displayName: "English",
      abbreviation: "en",
      languagePacketSize: "3 MB",
    ),
    LanguageClass(
      displayName: "日本語",
      englishName: "Japanese",
      abbreviation: "ja",
      languagePacketSize: "7 MB",
    ),
    LanguageClass(
      displayName: "Kiswahili",
      abbreviation: "sw",
      languagePacketSize: "1 MB",
    ),
    LanguageClass(
      displayName: "فارسی",
      englishName: "Persian",
      abbreviation: "fa",
      languagePacketSize: "1 MB",
    ),
    LanguageClass(
      displayName: "Русский",
      englishName: "Russian",
      abbreviation: "ru",
      languagePacketSize: "2 MB",
    ),
    LanguageClass(
      displayName: "Suomi",
      abbreviation: "fi",
      languagePacketSize: "3 MB",
    ),
    LanguageClass(
      displayName: "Svenska",
      abbreviation: "sv",
      languagePacketSize: "1 MB",
    ),
  ];

  /// The language, which is defaulted when starting the app for the first time.
  static final defaultLanguageCode = "en";

  static int languageCount = languages.length;

  static List<LanguageClass> get loadedLanguages {
    List<String> codeList = BoxService.getInstalledLanguages();
    return languages.where((l) => codeList.contains(l.code)).toList();
  }

  /// Returns the languages, which have not been loaded on the device
  static List<LanguageClass> get loadableLanguages {
    List<LanguageClass> loadableLanguages = [];
    for (LanguageClass l in languages) {
      if (!loadedLanguages.contains(l)) {
        loadableLanguages.add(l);
      }
    }
    return loadableLanguages;
  }

  static Future<bool> loadLanguage(LanguageClass language) async {
    debugPrint('*** Loading the data of $language');
    bool result = await ApiService.getDataForLanguage(language);
    debugPrint('   - Did the loading succeeded: $result');
    return result;
  }

  static Future<bool> removeLoadedLanguage(LanguageClass language) async {
    // Throw an assert if the language is not loaded
    assert(
      loadedLanguages.contains(language),
      "The language to be removed is not in the loaded languages",
    );
    BoxService.delete(language.code);
    // todo: fix the case where removing the selected language
    return true;
  }

  static setLoadedLanguages(List<LanguageClass> languages) {
    UnimplementedError("Setting the languages has not yet been implemented");
  }
}
