import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/features/content/presentation/widgets/answer_page_list.dart';
import 'package:bible_toolbox/features/content/presentation/widgets/bible_page_list.dart';
import 'package:bible_toolbox/features/content/presentation/widgets/home_page_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiTextWidget extends StatefulWidget {
  /// Body text in markdown format
  final String body;
  final PageType pageType;
  final bool? scrollable;

  const ApiTextWidget({
    super.key,
    required this.body,
    required this.pageType,
    this.scrollable,
  });

  @override
  State<ApiTextWidget> createState() => _ApiTextWidgetState();
}

class _ApiTextWidgetState extends State<ApiTextWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.pageType == PageType.catechism) {
      // debugPrint('*-*_*_*_*_');
      // debugPrint(widget.body);
      // debugPrint('*-*_*_*_*_');
    }

    return SelectionArea(
      child: Markdown(
        data: widget.body,
        physics: widget.scrollable != null
            ? null
            : NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 16),
        builders: {
          // Custom builder for blockquotes
          'blockquote': BlockquoteElementBuilder(),
          'code': CustomBuilder(),
        },
        styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.bodyMedium,
          h1: Theme.of(context).textTheme.headlineLarge,
          h1Padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          h2: Theme.of(context).textTheme.headlineLarge,
          h3: Theme.of(context).textTheme.headlineMedium,
          h4: Theme.of(context).textTheme.headlineMedium,
          h5: Theme.of(context).textTheme.headlineSmall,
          h6: Theme.of(context).textTheme.headlineSmall,
          a: Theme.of(context).textTheme.labelMedium,
          blockquote: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
          pPadding: EdgeInsets.zero,
          blockquotePadding: EdgeInsets.zero,
          codeblockPadding: EdgeInsets.zero,
          tablePadding: EdgeInsets.zero,
          blockquoteDecoration: BoxDecoration(),
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
              bottom: BorderSide(width: 15, color: Colors.transparent),
            ),
          ),
        ),
        onTapLink: (title, url, _) async {
          /*
          * Handle opening the links
          * - If external link -> open in browser
          * - If internal link (includes bibletoolbox) -> open in the app
          * */
          debugPrint('User wants to open: $url');
          debugPrint('User wants to open: $title');
          if (url != null && url.contains('bibletoolbox.net')) {
            // An internal link
            debugPrint('Internal link');
            String keyWord = url.substring(url.lastIndexOf("/") + 1);
            debugPrint(' - KeyWord for the internal link is: $keyWord');

            // Find the correct link
            for (String key in Constants.internalLinkConvert.keys) {
              if (Constants.internalLinkConvert[key]!.contains(keyWord)) {
                debugPrint(' - Page to move: $key');
                if (ModalRoute.of(context)?.settings.name == "/home") {
                  // If in home page, push the next page on top of it
                  Navigator.pushNamed(context, key);
                } else {
                  // If not in home page, push the next page as replacement
                  Navigator.pushReplacementNamed(context, key);
                }
                return;
              }
            }
            assert(false, "No key for keyWord: $keyWord");
          } else if (url != null && !await launchUrl(Uri.parse(url))) {
            throw Exception('Could not launch $url');
          }
        },
      ),
    );
  }
}

/// Build the blockQuote element for displaying the quoteBlock properly
class BlockquoteElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(var element, TextStyle? preferredStyle) {
    // element.textContent is the text inside the blockquote
    String text = element.textContent;

    // Fix the line brake marks set previously
    text = text.replaceAll("<br>", "\n");

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote_rounded,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style:
                      (preferredStyle ??
                              Theme.of(context).textTheme.bodyMedium!)
                          .copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(var element, TextStyle? preferredStyle) {
    debugPrint('\nModifying the codeBlock');

    assert(element.children != null, "The table doesn't have children!");
    assert(
      element.children!.length == 1,
      "The table has wrong amount of children!",
    );

    // Extract the ID and the data
    final rows = element.children!.first.textContent
        .split(Constants.idSeparator)
        .toList(); // [ID][blockSeparator][rawData]
    String id = rows[0];
    String rawData = rows[1];

    debugPrint(' - Block type: $id, data length: ${rawData.length}');
    switch (id) {
      case Constants.homePageID:
        return HomePageList(rawData: rawData);
      case Constants.bibleListID:
        return BiblePageList(rawData: rawData);
      case Constants.answerListID:
        debugPrint('Answer LIst');
        return AnswerPageList(rawData: rawData);
      default:
        debugPrint('Returning null');
        return null;
    }
  }
}
