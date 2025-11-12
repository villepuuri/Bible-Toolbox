// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get titleWelcome => 'Karibu!';

  @override
  String get textWelcome =>
      'Chagua lugha za kupakua hapa chini. Unaweza kuongeza zaidi baadaye.';

  @override
  String get titleLoadLanguages => 'Pakia Lugha';

  @override
  String get titleHomePage => 'Hujambo!';

  @override
  String get titleLanguageSettings => 'Mipangilio ya Lugha';

  @override
  String get textLanguageSettings =>
      'Unaweza kuchagua lugha gani zipakuliwe kwenye kifaa chako. Kumbuka kuwa lugha tofauti zinaweza kuwa na kiasi tofauti cha nyenzo.';

  @override
  String get titleLoadedLanguages => 'Lugha Zilizopakuliwa';

  @override
  String get titleUnloadedLanguages => 'Lugha za kupakua';

  @override
  String get titleBookmarks => 'Alamisho';

  @override
  String get titleSort => 'Chuja';

  @override
  String get titleGo => 'Nenda';

  @override
  String get titleSelect => 'Chagua';

  @override
  String get titleRemove => 'Ondoa';

  @override
  String get errorTextNotFound => 'Maandishi hayajapatikana';
}
