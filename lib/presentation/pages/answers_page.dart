import 'dart:convert';

import 'package:bible_toolbox/core/Widgets/extendable_headline.dart';
import 'package:bible_toolbox/core/Widgets/link_headline.dart';
import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:bible_toolbox/data/widgets/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

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
      appBar: MainAppBar(title: page?.title ?? "", showBookmarkButton: false,),
      floatingActionButton: FloatingActionButton(onPressed: () {
        LanguageHelper.getDoubles();
      }),
      body: PageWidget(page: page, pageType: PageType.answers, showTitle: false,)
    );
  }
}
