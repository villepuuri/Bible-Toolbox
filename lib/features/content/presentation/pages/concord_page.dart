import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/article_data.dart';
import 'package:bible_toolbox/features/language/providers/language_provider.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../widgets/page_widget.dart';

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
      appBar: MainAppBar(
        title: "",
        showBookmarkButton: false,
        showBottomLine: false,
      ), // todo: text
      body: PageWidget(
        page: article,
        pageType: PageType.concord,
        showTitle: true,
      ),
    );
  }
}
