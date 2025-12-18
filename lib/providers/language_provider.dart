

import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/core/helpers/shared_preferences_keys.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider to handle the selected language data
class LanguageProvider extends ChangeNotifier {

  /// Selected locale
  Locale _locale = const Locale('en');

  /// The texts based on the [_locale]
  final Map<String, dynamic> _localizedTexts = {};

  Locale get locale => _locale;
  Map<String, dynamic> get localizedTexts => _localizedTexts;

  /// Initialize the provider by loading the locale and the language data
  Future<void> init() async {
    // Get the correct locale
    await loadLocale();
    // todo: load the language data
    // await loadLanguage(systemLocale.languageCode);
  }

  /// Get locale from memory or on the first run from system.
  ///
  /// Updates the [_locale] parameter
  Future<void> loadLocale() async {

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

  /// Set a locale and save it to memory
  Future<void> setLocale(String code) async {
    _locale = Locale(code);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      SharedPreferencesKeys.localeCode,
      code,
    );
  }


  /// Call this function to change the language based on the languageCode
  Future<void> changeLanguage(String languageCode) async {
    await setLocale(languageCode);
    notifyListeners();
  }

}