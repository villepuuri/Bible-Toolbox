

import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/core/helpers/shared_preferences_keys.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {

  Locale _locale = const Locale('en');
  final Map<String, dynamic> _localizedTexts = {};

  Locale get locale => _locale;
  Map<String, dynamic> get localizedTexts => _localizedTexts;

  // Initialize with system locale
  Future<void> init() async {
    // Get the correct locale
    await loadLocale();
    // todo: load the language data
    // await loadLanguage(systemLocale.languageCode);
  }

  Future<void> loadLocale() async {
    /* Get locale from memory or on the first run from system
    * */
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(SharedPreferencesKeys.localeCode);

    if (code != null) {
      // Use the phone's language, if the app supports it
      if (LanguageHelper.languages.any((e) => e.code == code)) {
        _locale = Locale(code);
      }
      // Default to English, if user's language is not supported
      else {
        _locale = Locale(LanguageHelper.defaultLanguageCode);
      }
    } else {
      // Default to device locale
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      await setLocale(systemLocale.languageCode);
    }
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    /* Set the locale and save it to memory
    * */
    _locale = Locale(code);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      SharedPreferencesKeys.localeCode,
      code,
    );
  }


  // Change language manually
  Future<void> changeLanguage(String languageCode) async {
    /* Call this function to change the language based on the languageCode */
    await setLocale(languageCode);
    notifyListeners();
    // await loadLanguage(newLocale.languageCode);
  }

  // Helper to get text by key
  String getText(String key) => _localizedTexts[key] ?? key;

}