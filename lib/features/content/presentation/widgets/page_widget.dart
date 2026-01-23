import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/features/content/data/models/article_data.dart';
import 'package:bible_toolbox/features/content/data/services/api_text_cleaner.dart';
import 'package:bible_toolbox/features/content/presentation/widgets/article_title_widget.dart';
import 'package:flutter/material.dart';
import 'api_text_widget.dart';

class PageWidget extends StatefulWidget {
  final ArticleData? page;
  final PageType pageType;
  final bool showTitle;

  const PageWidget({
    super.key,
    required this.page,
    PageType? pageType,
    bool? showTitle,
  }) : pageType = pageType ?? PageType.other,
       showTitle = showTitle ?? true;

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  @override
  Widget build(BuildContext context) {
    Widget? titleWidget() {
      return widget.showTitle
          ? widget.pageType != PageType.home ? ArticleTitleWidget(
              article: widget.page!,
              bookmarkType: widget.pageType == PageType.concord
                  ? BookmarkType.concord
                  : null,
            ) : Text(widget.page!.title, style: Theme.of(context).textTheme.titleMedium,)
          : null;
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
