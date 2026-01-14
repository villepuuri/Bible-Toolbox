import 'package:bible_toolbox/core/Widgets/extendable_headline.dart';
import 'package:bible_toolbox/core/Widgets/link_headline.dart';
import 'package:bible_toolbox/core/Widgets/page_button.dart';
import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/core/helpers/box_service.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:bible_toolbox/data/widgets/bible_page_list.dart';
import 'package:bible_toolbox/data/widgets/home_page_list.dart';
import 'package:bible_toolbox/data/widgets/page_widget.dart';
import 'package:bible_toolbox/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:provider/provider.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class ApiTextWidget extends StatefulWidget {
  /// Body text in markdown format
  final String body;
  final PageType pageType;

  const ApiTextWidget({super.key, required this.body, required this.pageType});

  @override
  State<ApiTextWidget> createState() => _ApiTextWidgetState();
}

class _ApiTextWidgetState extends State<ApiTextWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('type: ${widget.pageType}');
    if (widget.pageType == PageType.home) {
      debugPrint('*-*_*_*_*_');
      debugPrint(widget.body);
      debugPrint('*-*_*_*_*_');
    }

    return SelectionArea(
      child: Markdown(
        data: widget.body,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 32),
        builders: {
          // Custom builder for blockquotes
          'blockquote': BlockquoteElementBuilder(),
          'code': TableBuilder(),
        },
        styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.bodyMedium,
          h1: Theme.of(context).textTheme.headlineLarge,
          h1Padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          h3: Theme.of(context).textTheme.headlineMedium,
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

    debugPrint(text);

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

class TableBuilder extends MarkdownElementBuilder {


  Widget buildAnswerList(List<String> answerList, BuildContext context) {
    debugPrint('Length of answerList: ${answerList.length}');

    // {blockName: {title: url}}
    Map<String, String> answerMap = {};
    List<Widget> blockWidgets = [];

    for (String block in answerList) {
      List<String> rows = block.split(Constants.rowSeparator);

      assert(
        !rows[0].contains(Constants.colSeparator),
        "The first row should be the blockName",
      );
      String blockName = rows[0];

      List<Widget> titleWidgets = rows
          .sublist(1)
          .map((row) {
            List<String> elements = row.split(Constants.colSeparator);
            assert(elements.length == 2);
            String title = elements[0];
            String url = elements[1];

            // todo: remove this
            if (!LanguageHelper.articleExists(
              context.read<LanguageProvider>().locale.languageCode,
              title,
            )) {
              debugPrint('Missing:\t $title');
            }

            if (LanguageHelper.articleExists(
              context.read<LanguageProvider>().locale.languageCode,
              title,
            )) {
              return LinkHeadline(
                text: title,
                onTap: () async {
                  debugPrint('User wants to open: $title');

                  ArticleData answer = LanguageHelper.getArticleByTitle(
                    context.read<LanguageProvider>().locale.languageCode,
                    title,
                  );
                  // Navigator.pushNamed(context, '/showText',
                  //     arguments: {
                  //       'id': entry.key,
                  //       'clicked': question
                },
              );
            } else {
              return const SizedBox();
            }
          })
          .cast<Widget>()
          .toList();
      blockWidgets.add(
        ExtendableHeadline(title: blockName, children: titleWidgets),
      );
    }

    return Column(children: blockWidgets);
  }


  @override
  Widget? visitElementAfter(var element, TextStyle? preferredStyle) {
    debugPrint('\nModifying the codeBlock');

    assert(element.children != null, "The table doesn't have children!");
    assert(
      element.children!.length == 1,
      "The table has wrong amount of children!",
    );

    print(element.textContent);

    final rows = element.children!.first.textContent
        .split(Constants.idSeparator)
        .toList(); // [ID][blockSeparator][rawData]

    debugPrint(rows.length.toString());

    String id = rows[0];
    String rawData = rows[1];


    debugPrint(' - Block type: $id, length: ${rawData.length}');
    // print(element.textContent.substring(0, element.textContent.length < 100 ? 1 : 100));
    switch (id) {
      case Constants.homePageID:
        return HomePageList(rawData: rawData);
      case Constants.bibleListID:
        return BiblePageList(raw: rawData);
      case Constants.answerListID:
        debugPrint('Answer LIst');
        return Builder(
          builder: (context) {
            return buildAnswerList(rows.sublist(1), context);
          },
        );
      default:
        debugPrint('Returning null');
        return null;
    }
  }
}
