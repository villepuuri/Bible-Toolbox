import 'package:bible_toolbox/core/helpers/box_service.dart';
import 'package:bible_toolbox/data/services/api_service.dart';
import 'package:bible_toolbox/providers/language_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LanguageClass {
  final String displayName;
  final String? englishName;
  final String abbreviation;
  final String languagePacketSize;
  bool _isLoading = false;
  double _loadingValue = 0.0;

  LanguageClass({
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

  // The loading states
  void setLoadingState(bool state) => _isLoading = state;

  bool get isLoading => _isLoading;

  void setLoadingValue(double value) => _loadingValue = value;

  double get loadingValue => _loadingValue;

  // An easier way to get the language code
  String get code => abbreviation;

  @override
  String toString() => "$displayName ($abbreviation)";
}

/// LanguageHelper is a general class that uses ApiService and BoxService classes
/// to handle the language functions
class LanguageHelper {
  /// List of all available languages
  static List<LanguageClass> languages = [
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

  static Future<bool> loadLanguage(
    LanguageClass language, {
    Function? updateParent,
  }) async {
    debugPrint('*** Loading the data of $language');
    bool result = await ApiService.getDataForLanguage(language, updateParent);
    debugPrint('   - Did the loading succeeded: $result');
    return result;
  }

  static Future<bool> removeLoadedLanguage(
    LanguageClass language,
    BuildContext context,
  {Function? updateParent}
  ) async {
    // Throw an assert if the language is not loaded
    assert(
      loadedLanguages.contains(language),
      "The language to be removed is not in the loaded languages",
    );
    assert(
      !(loadedLanguages.contains(language) && loadedLanguages.length == 1),
      "The last language is tried to be deleted!",
    );

    // If the selected language is being deleted, select the first loaded language
    if (context.mounted &&
        context.read<LanguageProvider>().locale.languageCode == language.code) {
      debugPrint(' - Changing the selected language...');
      await context.read<LanguageProvider>().changeLanguage(
        loadedLanguages.firstWhere((lang) => lang.code != language.code).code,
      );
      debugPrint(' - Language changed before the old is deleted!');
    }

    // Delete the language after rebuild is completed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await BoxService.delete(language.code);
      if (updateParent != null) {
        updateParent();
      }
    });

    return true;
  }

  static setLoadedLanguages(List<LanguageClass> languages) {
    UnimplementedError("Setting the languages has not yet been implemented");
  }
}
