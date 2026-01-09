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
  int? randomQuestionID;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    // article = await LanguageHelper.getRandomBibleArticle(
    //   context.read<LanguageProvider>().locale.languageCode,
    // );
    article = await LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      21,
    );

    if (mounted) {
      randomQuestionID = (await LanguageHelper.getRandomQuestion(
        context.read<LanguageProvider>().locale.languageCode,
      )).id;
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    debugPrint('Current locale: ${lang.locale.languageCode}');

    return Scaffold(
      appBar: MainAppBar(title: AppLocalizations.of(context)!.titleHomePage),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          debugPrint('on pressed');
        },
      ),
      drawer: MainDrawer(),
      body: PageWidget(
        page: article,
        pageType: PageType.home,
        randomQuestionID: randomQuestionID,
      ),
    );
  }
}
