
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

  String get fullName =>
      englishName != null ? '$displayName ($englishName)' : displayName;

  // An easier way to get the language code
  String get code => abbreviation;

  @override
  String toString() => "$displayName ($abbreviation)";
}

class LanguageHelper {
  static const List<LanguageClass> languages = [
    LanguageClass(
      displayName: "العربية",
      englishName: "Arabic",
      abbreviation: "ar",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "မြန်မာဘာသာ",
      englishName: "Burmese",
      abbreviation: "my",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "Eesti",
      abbreviation: "et",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "English",
      abbreviation: "en",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "日本語",
      englishName: "Japanese",
      abbreviation: "ja",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "Kiswahili",
      abbreviation: "sw",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "فارسی",
      englishName: "Persian",
      abbreviation: "fa",
      languagePacketSize: "14 Mb",
    ),
    LanguageClass(
      displayName: "Русский",
      englishName: "Russian",
      abbreviation: "ru",
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
  ];

  static final defaultLanguageCode = "en";

  static int languageCount = languages.length;

  static List<LanguageClass> testLoadedLanguages = [];

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
    // todo: fix the case where removing the selected language
    return true;
  }

  static setLoadedLanguages(List<LanguageClass> languages) {
    UnimplementedError("Setting the languages has not yet been implemented");
  }
}
