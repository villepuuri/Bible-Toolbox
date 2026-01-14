import 'package:bible_toolbox/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Widgets/extendable_headline.dart';
import '../../core/Widgets/link_headline.dart';
import '../../core/helpers/language_helper.dart';
import '../services/article_data.dart';

class AnswerPageList extends StatelessWidget {
  final String rawData;

  const AnswerPageList({super.key, required this.rawData});

  @override
  Widget build(BuildContext context) {
    List<Widget> categories() {
      Map<String, List<Widget>> categories = {};

      // Extract the question blocks from the data
      RegExp blockSeparatorRE = RegExp(
        // r'(\[[\s\S]*?)(?<=)\r\n\r\n',
        // r'(?<=^|(\n){2,})(.*?)(?<=\n{2,})',
        r'(?<=^|(\n){2,})(.*?)(\n){2,}',
        dotAll: true,
      );
      List<String?> blocks = blockSeparatorRE
          .allMatches(rawData)
          .map((e) => e.group(2))
          .toList();

      debugPrint('Blocks length: ${blocks.length}');

      int questionCount = 0;

      for (final dataBlock in blocks) {
        // If data is null, skip the element
        if (dataBlock == null) {
          debugPrint(' *** Block NOT FOUND: ${dataBlock.toString()}');
          continue;
        }

        // Extract the question element from the data
        RegExp elementSeparatorRE = RegExp(
          r'(\[[\s\S]*?)(?<=)(\n|$)',
          dotAll: true,
        );
        List<String?> elements = elementSeparatorRE
            .allMatches(dataBlock)
            .map((e) => e.group(1))
            .toList();

        String? blockName;

        // Go through each question element

        List<Widget> categoryWidgets = [];
        for (final element in elements) {
          // If data is null, skip the element
          if (element == null) {
            debugPrint(' *** ELEMENT NOT FOUND: ${element.toString()}');
            continue;
          }

          // Extract title and url
          RegExp titleSeparatorRE = RegExp(r'\[([\s\S]*?)\]', dotAll: true);
          RegExp urlSeparatorRE = RegExp(r'\]\s*\(([\s\S]*?)\)', dotAll: true);

          String title = titleSeparatorRE.firstMatch(element)?.group(1) ?? "";
          String url = urlSeparatorRE.firstMatch(element)?.group(1) ?? "";

          // Try to extract the blockName
          // All urls don't contain the block name, but most of them do
          RegExp blockNameRE = RegExp(r'([\w-]*?)(?<=)(#)', dotAll: true);
          blockName = blockName ?? blockNameRE.firstMatch(url)?.group(1);

          categoryWidgets.add(
            LinkHeadline(
              text: title,
              onTap: () {
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
            ),
          );

          questionCount++;
        }
        debugPrint('    * $blockName');
        if (blockName == null) {
          assert(blockName != null, "BlockName is null");
          continue;
        }

        if (categories.keys.contains(blockName)) {
          categories[blockName] = categories[blockName]! + categoryWidgets;
        } else {
          categories[blockName] = categoryWidgets;
        }
      }

      List<Widget> finalWidgets = categories.entries
          .map(
            (entry) => ExtendableHeadline(
              title: entry.key,
              children: entry.value,
            ),
          )
          .toList();

      debugPrint(' - QuestionCount: $questionCount');

      return finalWidgets;
    }

    return Column(children: categories());
  }
}
