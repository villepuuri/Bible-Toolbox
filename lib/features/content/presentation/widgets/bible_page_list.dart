import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/features/content/presentation/widgets/api_text_widget.dart';
import 'package:bible_toolbox/features/content/presentation/widgets/bible_page_book_widget.dart';
import 'package:bible_toolbox/core/widgets/extendable_headline.dart';
import 'package:flutter/material.dart';

/// Turns raw markdown data from the Bible page to different links
class BiblePageList extends StatefulWidget {
  final String rawData;

  const BiblePageList({super.key, required this.rawData});

  @override
  State<BiblePageList> createState() => _BiblePageListState();
}

class _BiblePageListState extends State<BiblePageList> {
  List<Widget> extractData(BuildContext context) {
    // Separate blocks (starting with ###)
    List<Widget> blockWidgets = [];

    RegExp blockRE = RegExp(r'(###.*?)(?=(###)|(<!)|$)', dotAll: true);
    List<String?> blocks = blockRE
        .allMatches(widget.rawData)
        .map((match) => match.group(1))
        .toList();

    for (String? block in blocks) {
      if (block == null) continue;

      List<Widget> rowWidgets = [];

      // Get the title of the block
      RegExp blockNameRE = RegExp(r'(?<=###)(.*?)(?=(\n)|$)');
      String? blockName = blockNameRE.firstMatch(block)?.group(1);

      debugPrint('\n\n - Block: $blockName');

      // Cut block name from the block
      block = block.replaceAll(blockNameRE, "").replaceAll("###", "");

      // If the block contains list of links
      if (block.contains('*   [')) {
        // if(false) {
        debugPrint('   * has a list of links');

        // Separate links (starting with '*   ')
        RegExp linkRE = RegExp(r'(\s*\*.*)', multiLine: true);
        List<String?> links = linkRE
            .allMatches(block)
            .map((match) => match.group(1))
            .toList();

        debugPrint('   * Links length: ${links.length}');

        for (String? link in links) {
          if (link == null) continue;

          // Get link url
          RegExp linkUrlRE = RegExp(r'\((.*?)\)');
          // String? linkUrl = linkUrlRE.firstMatch(link)?.group(1);

          // Cut links and brackets away
          link = link
              .replaceAll(linkUrlRE, "")
              .replaceAll(RegExp(r'[\[\]]'), "");

          // Get link text
          RegExp linkTextRE = RegExp(r'\*\s*(.*?)\s*\\r\\n');
          String? linkText = linkTextRE.firstMatch(link)?.group(1);

          // debugPrint('LINK:--$link--');

          RegExp mainLinkRE = RegExp(r'(\n\*\s{3,})', dotAll: true);
          RegExp subLinkRE = RegExp(r'(\s\*\s)');

          int? linkType = link.contains(mainLinkRE)
              ? 1
              : (link.contains(subLinkRE) ? 2 : null);

          if (linkType == null) {
            debugPrint(' ~LINKTYPE NULL: $link');
            continue;
          }

          // If there is not a link, use the whole text as title
          linkText ??= link.replaceAll("*", '').trim();

          debugPrint('${linkType == 2 ? '   ' : ''}$linkText');

          rowWidgets.add(BiblePageBookWidget(chapterTitle: linkText));
        }
        // Cut links from the block
        block = block.replaceAll(linkRE, "");
      } else {
        // The block does not contain links
        rowWidgets.add(ApiTextWidget(body: block, pageType: PageType.other));
      }

      blockWidgets.add(
        ExtendableHeadline(title: blockName ?? "", children: rowWidgets),
      );
    }
    // debugPrint(codeBlock.substring(codeBlock.length-300, codeBlock.length));
    // print(codeBlock);
    // final RegExp pattern = RegExp('.{1,800}');
    // pattern.allMatches(codeBlock).forEach((match) => print(match.group(0)));
    debugPrint('');

    return blockWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: extractData(context),
    );
  }
}
