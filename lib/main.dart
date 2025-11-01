import 'package:bible_toolbox/presentation/pages/home_page.dart';
import 'package:bible_toolbox/presentation/pages/answers_page.dart';
import 'package:bible_toolbox/presentation/pages/loading_page.dart';
import 'package:bible_toolbox/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';

import 'core/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemeData.lightTheme,
      routes: {
        '/': (context) => const LoadingPage(),
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => const HomePage(),
        '/answers': (context) => const AnswersPage(),
        // '/bible': (context) => const BiblePage(),
        // '/catechism': (context) => const CatechismPage(),
        // '/concord': (context) => const ConcordPage(),
      },
    );
  }
}

