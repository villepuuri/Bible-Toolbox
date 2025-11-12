// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get titleWelcome => 'Добро пожаловать!';

  @override
  String get textWelcome =>
      'Выберите языки для загрузки ниже. Позже вы сможете добавить другие.';

  @override
  String get titleLoadLanguages => 'Загрузить языки';

  @override
  String get titleHomePage => 'Привет!';

  @override
  String get titleLanguageSettings => 'Языковые настройки';

  @override
  String get textLanguageSettings =>
      'Вы можете выбрать, какие языки будут загружены на устройство. Учтите, что для разных языков доступно разное количество материалов.';

  @override
  String get titleLoadedLanguages => 'Загруженные языки';

  @override
  String get titleUnloadedLanguages => 'Языки для загрузки';

  @override
  String get titleBookmarks => 'Закладки';

  @override
  String get titleSort => 'Фильтр';

  @override
  String get errorTextNotFound => 'Текст не найден';
}
