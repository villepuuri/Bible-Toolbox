import 'package:bible_toolbox/features/content/data/models/article_data.dart';
import 'package:bible_toolbox/features/language/providers/language_provider.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/main_app_bar.dart';
import '../widgets/page_widget.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  ArticleData? article;

  @override
  Widget build(BuildContext context) {
    article ??= LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      20,
    );

    return Scaffold(
      appBar: MainAppBar(
        title: article?.title ?? "",
        showBookmarkButton: false,
      ), // todo: text
      body: PageWidget(page: article, showTitle: false,),
    );
  }
}
