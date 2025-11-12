// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get titleWelcome => 'ようこそ！';

  @override
  String get textWelcome => '下からダウンロードする言語を選択してください。後で追加することもできます。';

  @override
  String get titleLoadLanguages => '言語を読み込む';

  @override
  String get titleHomePage => 'こんにちは！';

  @override
  String get titleLanguageSettings => '言語設定';

  @override
  String get textLanguageSettings =>
      'デバイスにダウンロードする言語を選択できます。言語によって利用可能なコンテンツの量が異なる場合があります。';

  @override
  String get titleLoadedLanguages => 'ダウンロード済みの言語';

  @override
  String get titleUnloadedLanguages => 'ダウンロード可能な言語';

  @override
  String get titleBookmarks => 'ブックマーク';

  @override
  String get titleSort => '絞り込み';

  @override
  String get errorTextNotFound => 'テキストが見つかりません';
}
