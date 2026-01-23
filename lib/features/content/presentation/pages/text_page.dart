import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/features/content/data/models/article_data.dart';
import 'package:bible_toolbox/features/content/data/services/api_text_cleaner.dart';
import 'package:bible_toolbox/features/content/presentation/widgets/api_text_widget.dart';
import 'package:bible_toolbox/features/content/presentation/widgets/article_title_widget.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:bible_toolbox/features/language/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../widgets/link_headline.dart';
import '../../../../core/widgets/main_app_bar.dart';

class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    debugPrint('********************');
    debugPrint('    Text page');
    debugPrint('********************');

    assert(
      ModalRoute.of(context)!.settings.arguments != null,
      "There are no arguments for the text page",
    );
    // Extract the data passed from the previous page
    Map<String, dynamic> model =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<int> idList = model["idList"];
    int? selectedID = model["selectedID"];
    String? headline = model["headline"];

    debugPrint('idList length: ${idList.length}');
    debugPrint('selectedID: $selectedID');

    String languageCode = context.read<LanguageProvider>().locale.languageCode;

    List<ArticleData> articles = [];
    for (final id in idList) {
      if (LanguageHelper.articleExists(languageCode, id: id)) {
        articles.add(LanguageHelper.getArticleById(languageCode, id));
      }
    }

    if (firstBuild) {
      firstBuild = false;
      if (selectedID != null) {
        Future.delayed(const Duration(milliseconds: 5), () {
          int jumpIndex = articles.indexWhere((a) => a.id == selectedID);
          if (jumpIndex > -1) {
            // todo: Don't jump, if there is only one article!
            debugPrint('itemToJump: $jumpIndex');
            itemScrollController.jumpTo(index: jumpIndex + 1);
          }
        });
      }
    }

    Widget singleArticleWidget(ArticleData article, {bool? scrollable}) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Divider(),
            ArticleTitleWidget(article: article),
            const SizedBox(height: 10),
            ApiTextWidget(
              pageType: PageType.article,
              scrollable: scrollable,
              body: ApiTextCleaner.cleanText(article.body),
            ),
            const SizedBox(height: 10),
            SizedBox(width: 100, child: const Divider()),
            const SizedBox(height: 50),
          ],
        );

    Widget introWidget() => Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: articles
            .map(
              (a) => LinkHeadline(
                text: a.title,
                onTap: () {
                  itemScrollController.scrollTo(
                    index: articles.indexOf(a) + 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            )
            .toList(),
      ),
    );

    return Scaffold(
      appBar: MainAppBar(
        title: headline ?? articles.first.title,
        useSmallAppBar: true,
        showBookmarkButton: false,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: articles.length > 1
            ? ScrollablePositionedList.builder(
                itemCount: articles.length + 1,
                itemScrollController: itemScrollController,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Build the intro widget
                    return introWidget();
                  } else {
                    // Build the
                    return singleArticleWidget(articles[index - 1]);
                  }
                },
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: singleArticleWidget(articles.first),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 60)),
                ],
              ),
      ),
    );
  }
}
