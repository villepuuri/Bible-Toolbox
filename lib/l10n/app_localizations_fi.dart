// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get titleWelcome => 'Tervetuloa!';

  @override
  String get textWelcome =>
      'Valitse alta ladattavat kielet. Voit myöhemmin ladata lisää kieliä.';

  @override
  String get titleLoadLanguages => 'Lataa kielet';

  @override
  String get titleHomePage => 'Hei!';

  @override
  String get titleLanguageSettings => 'Kieliasetukset';

  @override
  String get textLanguageSettings =>
      'Voit valita, mitkä kielet on ladattuna laitteelle. Huomioithan, että eri kielillä voi olla eri määrä materiaalia saatavilla.';

  @override
  String get titleLoadedLanguages => 'Ladatut kielet';

  @override
  String get titleUnloadedLanguages => 'Ladattavat kielet';

  @override
  String get titleBookmarks => 'Kirjanmerkit';

  @override
  String get titleSort => 'Rajaa';

  @override
  String get errorTextNotFound => 'Tekstiä ei löytynyt';
}
