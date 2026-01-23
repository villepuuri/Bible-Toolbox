import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/features/content/data/models/article_data.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bible_toolbox/features/language/providers/language_provider.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../widgets/page_widget.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  ArticleData? article;

  @override
  Widget build(BuildContext context) {
    article ??= LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      22,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
      ),
      appBar: MainAppBar(
        title: article?.title ?? "",
        showBookmarkButton: false,
      ),
      body: PageWidget(
        page: article,
        pageType: PageType.bible,
        showTitle: false,
      ),
    );
  }
}
