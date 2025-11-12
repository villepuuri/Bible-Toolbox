// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get titleWelcome => 'Tere tulemast!';

  @override
  String get textWelcome =>
      'Vali allpool allalaaditavad keeled. Sa saad hiljem veel lisada.';

  @override
  String get titleLoadLanguages => 'Laadi keeled';

  @override
  String get titleHomePage => 'Tere!';

  @override
  String get titleLanguageSettings => 'Keele seaded';

  @override
  String get textLanguageSettings =>
      'Sa saad valida, millised keeled on seadmesse alla laaditud. Pange tähele, et eri keeltes võib olla erinev hulk materjale.';

  @override
  String get titleLoadedLanguages => 'Allalaaditud keeled';

  @override
  String get titleUnloadedLanguages => 'Allalaaditavad keeled';

  @override
  String get titleBookmarks => 'Järjehoidjad';

  @override
  String get titleSort => 'Filtreeri';

  @override
  String get errorTextNotFound => 'Teksti ei leitud';
}
