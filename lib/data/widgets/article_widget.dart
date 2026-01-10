import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:bible_toolbox/data/widgets/api_text_widget.dart';
import 'package:bible_toolbox/data/widgets/page_widget.dart';
import 'package:flutter/material.dart';

class ArticleWidget extends StatefulWidget {
  final ArticleData? article;
  final bool showFullTitle;

  const ArticleWidget({
    super.key,
    required this.article,
    this.showFullTitle = true,
  });

  @override
  State<ArticleWidget> createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  @override
  Widget build(BuildContext context) {
    /// Return 2 widgets, author and translator
    List<Widget> authorBox() {
      return [
        Text(
          // todo: translations
          "Kirjoittanut: ${widget.article!.writerNames}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (widget.article!.translators.isNotEmpty)
          Text(
            // todo: translations
            "Kääntänyt: ${widget.article!.translatorNames}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ];
    }

    /// The big title widget
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
              children:
                  [
                    Text(
                      "> ${widget.article!.title}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                  ] +
                  authorBox(),
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     debugPrint('User wants to share ${widget.article!.title}');
          //   },
          //   icon: Constants.iconShare,
          // ),
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

    /// Build the smallTitle using only author and translator
    Widget smallTitle() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: authorBox(),
    );

    return widget.article != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: widget.showFullTitle ? titleWidget() : smallTitle(),
                ),
                if (widget.showFullTitle)
                  SliverToBoxAdapter(child: Divider(thickness: 1)),
                SliverToBoxAdapter(
                  child: ApiTextWidget(
                    body: widget.article!.cleanBody,
                    pageType: PageType.other,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
