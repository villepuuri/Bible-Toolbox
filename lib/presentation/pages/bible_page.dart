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


  @override
  Widget build(BuildContext context) {

    ArticleData article = LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      22,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
      ),
      appBar: MainAppBar(title: article.title, showBookmarkButton: false,),
      body: PageWidget(
        page: article,
        pageType: PageType.bible,
        showTitle: false,
      ),
    );
  }
}
