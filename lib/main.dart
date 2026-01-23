import 'package:bible_toolbox/features/bookmark/models/bookmark.dart';
import 'package:bible_toolbox/features/bookmark/presentation/bookmarks_page.dart';
import 'package:bible_toolbox/features/language/presentation/language_page.dart';
import 'package:bible_toolbox/features/startup/presentation/loading_page.dart';
import 'package:bible_toolbox/features/startup/presentation/welcome_page.dart';
import 'package:bible_toolbox/features/language/providers/language_provider.dart';import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/services/boxes.dart';
import 'core/theme.dart';
import 'features/content/presentation/pages/about_page.dart';
import 'features/content/presentation/pages/answers_page.dart';
import 'features/content/presentation/pages/bible_page.dart';
import 'features/content/presentation/pages/catechism_page.dart';
import 'features/content/presentation/pages/concord_page.dart';
import 'features/content/presentation/pages/home_page.dart';
import 'features/content/presentation/pages/text_page.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';

void main() async {
  // Init the Hive memory
  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkAdapter());
  boxBookmarks = await Hive.openBox<Bookmark>('bookmarkBox');
  boxMeta = await Hive.openBox<Map<dynamic, dynamic>>('metaBox');

  // Initialize the Locale language
  LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.init();

  runApp(
    // Add a Provider to control the locale
    ChangeNotifierProvider(
      create: (context) => languageProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final languageProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemeData.lightTheme,
      // Internationalization
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: languageProvider.locale,
      routes: {
        '/': (context) => const LoadingPage(),
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => const HomePage(),
        '/answers': (context) => const AnswersPage(),
        '/bible': (context) => const BiblePage(),
        '/catechism': (context) => const CatechismPage(),
        '/concord': (context) => const ConcordPage(),
        '/showText': (context) => const TextPage(),
        '/bookmarks': (context) => const BookmarksPage(),
        '/languages': (context) => const LanguagePage(),
        '/about': (context) => const AboutPage()
      },
    );
  }
}
