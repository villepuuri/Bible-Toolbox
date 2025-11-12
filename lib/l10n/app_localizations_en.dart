// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titleWelcome => 'Welcome!';

  @override
  String get textWelcome =>
      'Select the languages to download below. You can add more later.';

  @override
  String get titleLoadLanguages => 'Load Languages';

  @override
  String get titleHomePage => 'Hi!';

  @override
  String get titleLanguageSettings => 'Language Settings';

  @override
  String get textLanguageSettings =>
      'You can choose which languages are downloaded to your device. Note that different languages may have varying amounts of available material.';

  @override
  String get titleLoadedLanguages => 'Downloaded Languages';

  @override
  String get titleUnloadedLanguages => 'Languages to Download';

  @override
  String get titleBookmarks => 'Bookmarks';

  @override
  String get titleSort => 'Filter';

  @override
  String get titleGo => 'Go';

  @override
  String get titleSelect => 'Select';

  @override
  String get titleRemove => 'Remove';

  @override
  String get errorTextNotFound => 'Text not found';
}
