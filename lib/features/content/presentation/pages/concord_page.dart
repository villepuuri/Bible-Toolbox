import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/core/services/result.dart';
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
  Result<ArticleData?>? articleResult;

  @override
  Widget build(BuildContext context) {
    articleResult ??= LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      65,
    );

    if (articleResult!.isError) {
      return Scaffold(body: Center(child: Text(articleResult!.error.toString())),);
    }

    return Scaffold(
      appBar: MainAppBar(
        title: "",
        showBookmarkButton: false,
        showBottomLine: false,
      ), // todo: text
      body: PageWidget(
        page: articleResult?.value,
        pageType: PageType.concord,
        showTitle: true,
      ),
    );
  }
}
