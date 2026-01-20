import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../constants.dart';
import '../helpers/bookmark.dart';

class ArticleTitleWidget extends StatefulWidget {
  final ArticleData article;
  final BookmarkType? bookmarkType;

  const ArticleTitleWidget({
    super.key,
    required this.article,
    this.bookmarkType,
  });

  @override
  State<ArticleTitleWidget> createState() => _ArticleTitleWidgetState();
}

class _ArticleTitleWidgetState extends State<ArticleTitleWidget> {
  @override
  Widget build(BuildContext context) {
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

    bool isBookmarked = BookmarkHelper.isPageBookmarked(widget.article.title);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
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
                      widget.article.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    if (widget.article.authors.isNotEmpty)
                      authorBox(author: widget.article.writerNames),
                    if (widget.article.translators.isNotEmpty)
                      authorBox(translator: widget.article.translatorNames),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  debugPrint('User wants to share: ${widget.article.title}');
                  SharePlus.instance.share(
                    ShareParams(uri: Uri.parse(widget.article.urlLink)),
                  );
                  // todo: fix sharing
                },
                icon: Constants.iconShare,
              ),
              IconButton(
                onPressed: () async {
                  if (!isBookmarked) {
                    await BookmarkHelper.addBookmark(
                      widget.article,
                      type: widget.bookmarkType,
                    );
                  } else {
                    await BookmarkHelper.deleteBookmark(
                      title: widget.article.title,
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
          ),
          const Divider(),
        ],
      ),
    );
  }
}
