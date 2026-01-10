import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:bible_toolbox/data/widgets/page_widget.dart';
import 'package:flutter/cupertino.dart';

class ApiTextCleaner {
  /// Calls different functions to clean the raw api data
  static String cleanText(String raw) {
    String result = cleanLink(raw);
    result = cleanFont(result);

    // Fix the bolded text
    result = result.replaceAll('<b>', '**').replaceAll('</b>', '**');

    result = fixQuoteBlocks(result);

    return result;
  }

  static String cleanPage(
    String raw, {
    PageType? pageType,
    int? randomQuestionID,
  }) {
    // String result = cleanPageLink(raw);
    debugPrint("- Cleaning");
    pageType ??= PageType.other;

    // Fix the bolded text
    raw = raw.replaceAll('<br>\r\n', '');


    // Handle the specific cases
    switch (pageType) {
      case (PageType.home):
        // Clean tables only in the home page
        debugPrint('Home');
        assert(randomQuestionID != null);
        raw = cleanTables(raw, randomQuestionID!);
        break;
      case (PageType.answers):
        // Set links to codeBlocs
        raw = cleanAnswerLinks(raw);
        break;
      default:
        break;
    }
    return raw;
  }

  static String cleanTables(String raw, int randomQuestionID) {
    debugPrint(' - Cleaning tables');

    // Clean unused elements
    final unusedRegExp = RegExp(r'<!.*>', dotAll: true);
    raw = raw.replaceAll(unusedRegExp, '');

    // Extracting the table elements
    final elementRegExp = RegExp(r'\[!(.*?)-{3,}\|-{3,}', dotAll: true);
    List<String?> elements = elementRegExp
        .allMatches(raw)
        .map((e) => e.group(0))
        .toList();
    debugPrint(' - category length: ${elementRegExp.allMatches(raw).length}');

    // Remove the elements
    raw = raw.replaceAll(elementRegExp, '');

    // Add the opening symbol of the code block and the identifier
    String mdButtons = "```${Constants.homeButtonID}";

    for (final element in elements) {
      if (element == null) continue;
      // Image string
      RegExp imageRE = RegExp(r'/(\w{2,})(?=\.png)', multiLine: true);
      String? imageString = imageRE
          .firstMatch(element)
          ?.group(1)
          ?.replaceAll("\n", "");

      // Path string
      RegExp pathRE = RegExp(r'(\w{2,})(?=)\)\s\|', multiLine: true);
      String? pathString = pathRE
          .firstMatch(element)
          ?.group(1)
          ?.replaceAll("\n", "");

      // URL string
      RegExp linkTextRE = RegExp(
        r'(?<=)\s\|\s\[(.*?)].*?\)(.*?)-{3,}',
        dotAll: true,
      );
      RegExpMatch? labelMatch = linkTextRE.firstMatch(element);
      String? labelString =
          ((labelMatch?.group(1) ?? "") + (labelMatch?.group(2) ?? ""))
              .replaceAll("\n", "")
              .trim();


      mdButtons += Constants.blockSeparator;
      String mdRow =
          '$labelString${Constants.colSeparator}$pathString${Constants.colSeparator}$imageString';

      mdButtons += "$mdRow ";
    }
    // Add the closing symbol for the code block
    mdButtons += "```";

    // The index of the first new line
    int indexPlace = raw.indexOf("\n");

    String randomQuestionBox =
        '```${Constants.questionButtonID}${Constants.blockSeparator}$randomQuestionID```';

    String mdFinal =
        "${raw.substring(0, indexPlace)} $mdButtons $randomQuestionBox ${raw.substring(indexPlace)}";

    return mdFinal;
  }

  static String cleanAnswerLinks(String raw) {
    debugPrint(' - Cleaning Answer links');

    // Extract the question blocks from the data
    RegExp blockSeparatorRE = RegExp(
      r'(\[[\s\S]*?)(?<=)\r\n\r\n',
      dotAll: true,
    );
    List<String?> blocks = blockSeparatorRE
        .allMatches(raw)
        .map((e) => e.group(1))
        .toList();

    debugPrint('Blocks length: ${blocks.length}');

    int quesitonCount = 0;

    String allCodeBlocks = "```${Constants.answerListID}";
    for (final dataBlock in blocks) {
      // If data is null, skip the element
      if (dataBlock == null) {
        debugPrint(' *** Block NOT FOUND: ${dataBlock.toString()}');
        continue;
      }

      // Extract the question element from the data
      RegExp elementSeparatorRE = RegExp(
        r'(\[[\s\S]*?)(?<=)(\r\n|$)',
        dotAll: true,
      );
      List<String?> elements = elementSeparatorRE
          .allMatches(dataBlock)
          .map((e) => e.group(1))
          .toList();

      String? blockName;
      String codeBlock = "";

      // Go through each question element
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

        // Add a row separator between rows
        if (codeBlock.isNotEmpty) {
          codeBlock += Constants.rowSeparator;
        }
        codeBlock += '$title${Constants.colSeparator}$url';
        quesitonCount++;
      }
      codeBlock = (blockName ?? "") + Constants.rowSeparator + codeBlock;
      allCodeBlocks += '${Constants.blockSeparator}$codeBlock';
    }
    allCodeBlocks += "```";

    debugPrint(' - QuestionCount: $quesitonCount');

    // Get the index where to put the codeBlock
    int? blockIndex = blockSeparatorRE.firstMatch(raw)?.start;
    if (blockIndex == null) return raw;

    // Replace the original links with the code block
    raw = raw.replaceAll(blockSeparatorRE, "");

    return raw.substring(0,blockIndex) + allCodeBlocks + raw.substring(blockIndex);
  }

  /// Change the possible HTML link to markdown syntax
  static String cleanLink(String raw) {
    int htmlIndex = raw.indexOf("<hr>"); // todo: maybe change this
    if (htmlIndex != -1) {
      String htmlLink = raw.substring(0, htmlIndex);

      // Regular Expression to detect the link items
      final linkRegex = RegExp(
        r'<a\s+href="([^"]+)"[^>]*>(.*?)</a>',
        caseSensitive: false,
      );

      // Changing the html link to markdown link
      String mdLink = htmlLink.replaceAllMapped(linkRegex, (match) {
        final url = match.group(1)!;
        final text = match.group(2)!;
        return '[$text]($url)';
      });

      return "$mdLink\n---\n${raw.substring(htmlIndex + 4)}";
    }
    return raw;
  }

  /// Remove opening <FONT ...> and closing </FONT>
  static String cleanFont(String raw) {
    // Case insensitive, also handles attributes
    final fontRegex = RegExp(r'<\s*FONT[^>]*>', caseSensitive: false);
    final fontCloseRegex = RegExp(r'<\s*/\s*FONT\s*>', caseSensitive: false);
    // remove opening and closing tag
    return raw.replaceAll(fontRegex, '').replaceAll(fontCloseRegex, '');
  }

  /// Fix the line brakes in the quote blocks
  static String fixQuoteBlocks(String raw) {
    // Try to fix the line brakes in the quote block
    final regex = RegExp(r'\r\n>([\s\S]*?)\r\n\r\n', multiLine: true);
    return raw.replaceAllMapped(regex, (match) {
      // final full = match.group(0)!;       // whole matched quote block
      final inner = match.group(1)!; // text inside the block (after '>')

      // Removes unnecessary ">" marks
      var convertedInner = inner.replaceAll('>', '');
      // Replace CRLF inside the block
      convertedInner = convertedInner.replaceAll('\r\n', '<br>');

      // Rebuild the block with replaced linebreaks
      return '\r\n>$convertedInner\r\n\r\n';
    });
  }
}
