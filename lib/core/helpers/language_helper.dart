import 'package:flutter/cupertino.dart';

class LanguageClass {
  final String displayName;
  final String abbreviation;
  final String languagePacketSize;

  const LanguageClass({
    required this.displayName,
    required this.abbreviation,
    required this.languagePacketSize,
  });

  // An easier way to get the language code
  String get code => abbreviation;

  @override
  String toString() => "$displayName ($abbreviation)";
}

class LanguageHelper {
  static const languages = [
    LanguageClass(
      displayName: "English",
      abbreviation: "en",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "日本語",
      abbreviation: "ja",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "Eesti",
      abbreviation: "et",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "Suomi",
      abbreviation: "fi",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "Svenska",
      abbreviation: "sv",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "Русский",
      abbreviation: "ru",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "Kiswahili",
      abbreviation: "sw",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "العربية",
      abbreviation: "ar",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "فارسی",
      abbreviation: "fa",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "မြန်မာဘာသာ",
      abbreviation: "my",
      languagePacketSize: "14 Mb",
    ),
  ];

  static LanguageClass selectedLanguage =
      languages.first; // todo: fix also this one
  static int languageCount = languages.length;

  static List<LanguageClass> testLoadedLanguages = [];

  static setUsedLanguage(LanguageClass language) {
    selectedLanguage = language;
    UnimplementedError("Setting the language has not yet been implemented");
  }

  static List<LanguageClass> get loadedLanguages {
    UnimplementedError("Getting the languages has not yet been implemented");
    // todo: fix this function
    return testLoadedLanguages;
  }

  static List<LanguageClass> get loadableLanguages {
    /* Return the languages, that has not been loaded to the device
    * */
    UnimplementedError("Getting the languages has not yet been implemented");
    // todo: fix this function
    List<LanguageClass> loadableLanguages = [];
    for (LanguageClass l in languages) {
      if (!loadedLanguages.contains(l)) {
        loadableLanguages.add(l);
      }
    }
    return loadableLanguages;
  }

  static Future<bool> loadLanguage(LanguageClass language) async {
    testLoadedLanguages.add(language);
    return true;
  }

  static Future<bool> removeLoadedLanguage(LanguageClass language) async {
    // Throw an assert if the language is not loaded
    assert(
      loadedLanguages.contains(language),
      "The language to be removed is not in the loaded languages",
    );
    testLoadedLanguages.remove(language);
    if (selectedLanguage == language) {
      // Set new selected language
      setUsedLanguage(loadedLanguages.first);
    }
    return true;
  }

  static setLoadedLanguages(List<LanguageClass> languages) {
    UnimplementedError("Setting the languages has not yet been implemented");
  }
}
