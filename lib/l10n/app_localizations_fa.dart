// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get titleWelcome => 'خوش آمدید!';

  @override
  String get textWelcome =>
      'زبان‌هایی را که می‌خواهید دانلود کنید در زیر انتخاب کنید. بعداً می‌توانید زبان‌های بیشتری اضافه کنید.';

  @override
  String get titleLoadLanguages => 'بارگذاری زبان‌ها';

  @override
  String get titleHomePage => 'سلام!';

  @override
  String get titleLanguageSettings => 'تنظیمات زبان';

  @override
  String get textLanguageSettings =>
      'می‌توانید انتخاب کنید کدام زبان‌ها در دستگاه شما بارگیری شوند. توجه کنید که مقدار مطالب در زبان‌های مختلف متفاوت است.';

  @override
  String get titleLoadedLanguages => 'زبان‌های دانلودشده';

  @override
  String get titleUnloadedLanguages => 'زبان‌های قابل دانلود';

  @override
  String get titleBookmarks => 'نشانک‌ها';

  @override
  String get titleSort => 'فیلتر';

  @override
  String get errorTextNotFound => 'متن یافت نشد';
}
