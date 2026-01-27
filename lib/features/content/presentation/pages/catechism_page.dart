import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/core/services/result.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/article_data.dart';
import 'package:bible_toolbox/features/language/providers/language_provider.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../widgets/page_widget.dart';

class CatechismPage extends StatefulWidget {
  const CatechismPage({super.key});

  @override
  State<CatechismPage> createState() => _CatechismPageState();
}

class _CatechismPageState extends State<CatechismPage> {
  Result<ArticleData?>? articleResult;

  @override
  Widget build(BuildContext context) {
    articleResult ??= LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      23,
    );

    if (articleResult!.isError) {
      return Scaffold(body: Center(child: Text(articleResult!.error.toString())),);
    }

    return Scaffold(
      appBar: MainAppBar(
        title: "",
        showBottomLine: false,
        showBookmarkButton: false,
      ),
      // todo: text
      body: PageWidget(page: articleResult?.value, pageType: PageType.catechism),
    );
  }
}
