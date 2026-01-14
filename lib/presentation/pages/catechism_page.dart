import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/language_helper.dart';
import '../../data/services/article_data.dart';
import '../../data/widgets/page_widget.dart';
import '../../providers/language_provider.dart';

class CatechismPage extends StatefulWidget {
  const CatechismPage({super.key});

  @override
  State<CatechismPage> createState() => _CatechismPageState();
}

class _CatechismPageState extends State<CatechismPage> {
  ArticleData? article;

  @override
  Widget build(BuildContext context) {
    article ??= LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      23,
    );

    return Scaffold(
      appBar: MainAppBar(title: "Katekismus"), // todo: text
      body: PageWidget(page: article),
    );
  }
}
