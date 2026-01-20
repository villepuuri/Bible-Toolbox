import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/language_helper.dart';
import '../../data/services/article_data.dart';
import '../../data/widgets/page_widget.dart';
import '../../providers/language_provider.dart';

class ConcordPage extends StatefulWidget {
  const ConcordPage({super.key});

  @override
  State<ConcordPage> createState() => _ConcordPageState();
}

class _ConcordPageState extends State<ConcordPage> {
  ArticleData? article;

  @override
  Widget build(BuildContext context) {
    article ??= LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      65,
    );

    return Scaffold(
      appBar: MainAppBar(title: "Tunnustuskirjat", showBookmarkButton: false,), // todo: text
      body: PageWidget(page: article, pageType: PageType.concord,),
    );
  }
}
