import 'package:bible_toolbox/core/Widgets/link_headline.dart';
import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/data/services/api_text_cleaner.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:bible_toolbox/data/widgets/api_text_widget.dart';
import 'package:bible_toolbox/data/widgets/page_widget.dart';
import 'package:bible_toolbox/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants.dart';
import '../../core/helpers/bookmark.dart';

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

    // todo: translations
    Widget authorBox({String? author, String? translator}) {
      assert(
        !(author == null && translator == null),
        "You must give at least one",
      );
      if (author != null && author.isEmpty) return SizedBox();
      if (translator != null && translator.isEmpty) return SizedBox();
      return Text(
        author != null ? "Kirjoittanut: $author" : "Kääntänyt: $translator",
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    Widget titleBox(ArticleData article) {
      bool isBookmarked = BookmarkHelper.isPageBookmarked(article.title);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      if (article.authors.isNotEmpty)
                        authorBox(author: article.writerNames),
                      if (article.translators.isNotEmpty)
                        authorBox(translator: article.translatorNames),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    debugPrint('User wants to share: ${article.title}');
                    SharePlus.instance.share(
                        ShareParams(uri: Uri.parse(article.urlLink))
                    );
                    // todo: fix sharing
                  },
                  icon: Constants.iconShare,
                ),
                IconButton(
                  onPressed: () async {
                    if (!isBookmarked) {
                      await BookmarkHelper.addBookmark(article.title, article.url);
                    } else {
                      await BookmarkHelper.deleteBookmark(title: article.title);
                    }
                    setState(() {});
                  },
                  icon: isBookmarked
                      ? Icon(
                          Constants.iconSelectedBookmark,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          Constants.iconAddBookmark,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                ),
              ],
            ),
            const Divider()
          ],
        ),
      );
    }

    if (firstBuild) {
      firstBuild = false;
      if (selectedID != null) {
        Future.delayed(const Duration(milliseconds: 5), () {
          int jumpIndex = articles.indexWhere((a) => a.id == selectedID);
          if (jumpIndex > -1) {
            debugPrint('itemToJump: $jumpIndex');
            itemScrollController.jumpTo(index: jumpIndex + 1);
          }
        });
      }
    }

    Widget singleArticleWidget(ArticleData article, {bool? scrollable}) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Divider(),
            titleBox(article),
            ApiTextWidget(
              pageType: PageType.article,
              scrollable: scrollable,
              body: ApiTextCleaner.cleanText(article.body),
            ),
            const SizedBox(height: 50),
          ],
        );

    Widget introWidget() => Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: articles.map((a) => LinkHeadline(text: a.title, onTap: () {
          itemScrollController.scrollTo(
            index: articles.indexOf(a) + 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut
          );
        },)).toList(),
      ),
    );

    return Scaffold(
      appBar: MainAppBar(
        title: headline ?? articles.first.title,
        useSmallAppBar: true,
        showBookmarkButton: false,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                    child: singleArticleWidget(
                      articles.first,
                      scrollable: true,
                    ),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 60)),
                ],
              ),
      ),
    );
  }
}
