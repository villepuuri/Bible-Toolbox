import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:bible_toolbox/data/widgets/api_text_widget.dart';
import 'package:flutter/material.dart';

class ArticleWidget extends StatefulWidget {
  final ArticleData? article;

  const ArticleWidget({super.key, required this.article});

  @override
  State<ArticleWidget> createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  @override
  Widget build(BuildContext context) {
    Widget authorBox({String? author, String? translator}) {
      assert(
        !(author == null && translator == null),
        "You must give at least one",
      );
      return Text(
        // todo: translations
        author != null ? "Kirjoittanut: $author" : "Kääntänyt: $translator",
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    Widget titleWidget() {
      bool isBookmarked = BookmarkHelper.isPageBookmarked(
        widget.article!.title,
      );
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "> ${widget.article!.title}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                authorBox(author: widget.article?.writerNames),
                widget.article!.translators.isNotEmpty
                    ? authorBox(
                        translator: widget.article?.translators.first.name,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              debugPrint('User wants to share ${widget.article!.title}');
            },
            icon: Constants.iconShare,
          ),
          IconButton(
            onPressed: () async {
              if (!isBookmarked) {
                await BookmarkHelper.addBookmark(
                  widget.article!.title,
                  widget.article!.path,
                );
              } else {
                await BookmarkHelper.deleteBookmark(
                  title: widget.article!.title,
                );
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
      );
    }

    return widget.article != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: titleWidget()),
                SliverToBoxAdapter(
                  child: ApiTextWidget(body: widget.article!.cleanBody),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
