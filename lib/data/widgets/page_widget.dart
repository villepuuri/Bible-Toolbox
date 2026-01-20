import 'package:bible_toolbox/core/Widgets/article_title_widget.dart';
import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:bible_toolbox/data/services/api_text_cleaner.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:flutter/material.dart';
import 'api_text_widget.dart';

enum PageType { home, bible, answers, catechism, concord, article, other }

class PageWidget extends StatefulWidget {
  final ArticleData? page;
  final PageType pageType;

  const PageWidget({super.key, required this.page, PageType? pageType})
    : pageType = pageType ?? PageType.other;

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  @override
  Widget build(BuildContext context) {
    Widget titleWidget() {
      return widget.pageType == PageType.home ||
              widget.pageType == PageType.answers
          ? Text(
              widget.page!.title,
              style: Theme.of(context).textTheme.titleMedium,
            )
          : ArticleTitleWidget(
              article: widget.page!,
              bookmarkType: widget.pageType == PageType.concord
                  ? BookmarkType.concord
                  : null,
            );
    }

    return widget.page != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: titleWidget()),
                SliverToBoxAdapter(
                  child: ApiTextWidget(
                    pageType: widget.pageType,
                    body: ApiTextCleaner.cleanPage(
                      widget.page!.cleanBody,
                      pageType: widget.pageType,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: const SizedBox(height: 60)),
              ],
            ),
          )
        : const SizedBox();
  }
}
