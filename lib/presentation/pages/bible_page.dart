import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    // article = await LanguageHelper.getRandomBibleArticle(
    //   context.read<LanguageProvider>().locale.languageCode,
    // );
    article = LanguageHelper.getArticleById(
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
          setState(() {});
        },
      ),
      appBar: MainAppBar(title: article?.title ?? ""),
      body: PageWidget(
        page: article,
        pageType: PageType.home,
      ),
    );
  }
}
