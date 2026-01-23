import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/features/content/data/models/article_data.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bible_toolbox/features/language/providers/language_provider.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../widgets/page_widget.dart';

class AnswersPage extends StatefulWidget {
  const AnswersPage({super.key});

  @override
  State<AnswersPage> createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  ArticleData? page;

  @override
  Widget build(BuildContext context) {
    page ??= LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      366,
    );

    return Scaffold(
      appBar: MainAppBar(title: page?.title ?? "", showBookmarkButton: false),
      body: PageWidget(
        page: page,
        pageType: PageType.answers,
        showTitle: false,
      ),
    );
  }
}
