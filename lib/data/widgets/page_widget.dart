import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:flutter/material.dart';

import 'api_text_widget.dart';

class PageWidget extends StatefulWidget {
  final ArticleData? page;

  const PageWidget({super.key, required this.page});

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
                  child: ApiTextWidget(body: widget.page!.cleanBody),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
