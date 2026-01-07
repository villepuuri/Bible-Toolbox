import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/data/services/api_service.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:bible_toolbox/data/widgets/article_widget.dart';
import 'package:bible_toolbox/data/widgets/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  ArticleData? article;

  @override
  void initState() {
    super.initState();
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

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // debugPrint(article.toString());
          debugPrint(article?.body.substring(article!.body.length - 600));
        },
      ),
      appBar: MainAppBar(title: article?.title ?? ""),
      body: PageWidget(page: article),
    );
  }
}
