class LanguageClass {
  final String displayName;
  final String abbreviation;
  final String languagePacketSize;

  const LanguageClass({required this.displayName, required this.abbreviation, required this.languagePacketSize});

  // An easier way to get the language code
  String get code => abbreviation;

  @override
  String toString() => "$displayName ($abbreviation)";
}

class LanguageHelper {
  
  static const languages = [
    LanguageClass(displayName: "English", abbreviation: "en", languagePacketSize: "14 Mb"),
    LanguageClass(displayName: "日本語", abbreviation: "ja", languagePacketSize: "14 Mb"),
    LanguageClass(displayName: "Eesti", abbreviation: "et", languagePacketSize: "14 Mb"),
    LanguageClass(displayName: "Suomi", abbreviation: "fi", languagePacketSize: "14 Mb"),
    LanguageClass(displayName: "Svenska", abbreviation: "sv", languagePacketSize: "14 Mb"),
    LanguageClass(displayName: "Русский", abbreviation: "ru", languagePacketSize: "14 Mb"),
    LanguageClass(displayName: "Kiswahili", abbreviation: "sw", languagePacketSize: "14 Mb"),
    LanguageClass(displayName: "العربية", abbreviation: "ar", languagePacketSize: "14 Mb"),
    LanguageClass(displayName: "فارسی", abbreviation: "fa", languagePacketSize: "14 Mb"),
    LanguageClass(displayName: "မြန်မာဘာသာ", abbreviation: "my", languagePacketSize: "14 Mb"),
  ];

  static LanguageClass selectedLanguage = languages.first;
  static int languageCount = languages.length;

  static List<LanguageClass> testLoadedLanguages = [];

  static set setUsedLanguage(LanguageClass language) {
    UnimplementedError("Setting the language has not yet been implemented");
  }

  static List<LanguageClass> get loadedLanguages {
    UnimplementedError("Getting the languages has not yet been implemented");
    // todo: fix this function
    return testLoadedLanguages;
  }

  static set loadedLanguages(List<LanguageClass> languages) {
    UnimplementedError("Setting the languages has not yet been implemented");
  }



}
