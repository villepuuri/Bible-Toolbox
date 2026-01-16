import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/Widgets/main_drawer.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';
import 'package:bible_toolbox/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/language_helper.dart';
import '../../data/widgets/page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ArticleData? article;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    debugPrint('Current locale: ${lang.locale.languageCode}');

    // In the first build, update article and randomQuestionID
    article ??= LanguageHelper.getArticleById(
        lang.locale.languageCode,
        21,
      );

    return Scaffold(
      appBar: MainAppBar(title: AppLocalizations.of(context)!.titleHomePage),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          debugPrint('on pressed');
          // print(ExtractKeyInformation.getMainCategories('fi'));
        },
      ),
      drawer: MainDrawer(),
      body: PageWidget(
        page: article,
        pageType: PageType.home,
      ),
    );
  }
}
