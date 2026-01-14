import 'package:bible_toolbox/data/services/api_text_cleaner.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:flutter/material.dart';
import 'api_text_widget.dart';

enum PageType { home, bible, answers, other }

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
      return Text(
        widget.page!.title,
        style: Theme.of(context).textTheme.titleMedium,
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
