// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get titleWelcome => 'Välkommen!';

  @override
  String get textWelcome =>
      'Välj de språk du vill ladda ner nedan. Du kan lägga till fler senare.';

  @override
  String get titleLoadLanguages => 'Ladda språk';

  @override
  String get titleHomePage => 'Hej!';

  @override
  String get titleLanguageSettings => 'Språkinställningar';

  @override
  String get textLanguageSettings =>
      'Du kan välja vilka språk som ska laddas ner till enheten. Observera att tillgängligt material kan variera mellan språk.';

  @override
  String get titleLoadedLanguages => 'Nedladdade språk';

  @override
  String get titleUnloadedLanguages => 'Språk att ladda ner';

  @override
  String get titleBookmarks => 'Bokmärken';

  @override
  String get titleSort => 'Filtrera';

  @override
  String get titleGo => 'Gå';

  @override
  String get titleSelect => 'Välj';

  @override
  String get titleRemove => 'Ta bort';

  @override
  String get errorTextNotFound => 'Texten hittades inte';
}
