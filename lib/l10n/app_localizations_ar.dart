// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get titleWelcome => 'أهلاً وسهلاً!';

  @override
  String get textWelcome =>
      'اختر اللغات التي تريد تنزيلها أدناه. يمكنك إضافة المزيد لاحقًا.';

  @override
  String get titleLoadLanguages => 'تحميل اللغات';

  @override
  String get titleHomePage => 'مرحباً!';

  @override
  String get titleLanguageSettings => 'إعدادات اللغة';

  @override
  String get textLanguageSettings =>
      'يمكنك اختيار اللغات التي يتم تنزيلها على جهازك. لاحظ أن كمية المواد المتاحة قد تختلف بين اللغات.';

  @override
  String get titleLoadedLanguages => 'اللغات التي تم تنزيلها';

  @override
  String get titleUnloadedLanguages => 'اللغات المتاحة للتنزيل';

  @override
  String get titleBookmarks => 'الإشارات المرجعية';

  @override
  String get titleSort => 'تصفية';

  @override
  String get titleGo => 'انتقل';

  @override
  String get titleSelect => 'اختر';

  @override
  String get titleRemove => 'إزالة';

  @override
  String get errorTextNotFound => 'لم يتم العثور على النص';
}
