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
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../core/helpers/bookmark.dart';

class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    debugPrint('********************');
    debugPrint('    Text page');
    debugPrint('********************');

    assert(
      ModalRoute.of(context)!.settings.arguments != null,
      "There are no arguments for the text page",
    );
    Map<String, dynamic> model =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int id = model["id"];
    String? selectedHeadline = model["clicked"];

    debugPrint('id: $id');
    debugPrint('selectedHeadline: $selectedHeadline');

    ArticleData article = LanguageHelper.getArticleById(
      context.read<LanguageProvider>().locale.languageCode,
      id,
    );

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "> ${article.title}",
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
      );
    }

    // if (isDataReady && firstTimeWithData) {
    //   firstTimeWithData = false;
    //   if (selectedHeadline != null) {
    //     Future.delayed(const Duration(milliseconds: 5), () {
    //       debugPrint('len of items: ${answers[id]["items"].length}');
    //       int indexToJump = answers[id]["items"].indexWhere(
    //         (item) => item == selectedHeadline,
    //       );
    //       debugPrint('itemToJump: $indexToJump');
    //       itemScrollController.jumpTo(index: indexToJump + 1);
    //     });
    //   }
    // }

    return Scaffold(
      appBar: MainAppBar(
        title: article.title,
        useSmallAppBar: true,
        showBookmarkButton: false,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: titleBox(article),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     if (article.authors.isNotEmpty)
              //       authorBox(author: article.writerNames),
              //     if (article.translators.isNotEmpty)
              //       authorBox(translator: article.translatorNames),
              //   ],
              // ),
            ),
            SliverToBoxAdapter(
              child: ApiTextWidget(
                pageType: PageType.other,
                body: ApiTextCleaner.cleanText(article.body),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 60)),
          ],
        ),
      ),
    );
  }
}
