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

  /// Cleaner for pages
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

    // Remove all the comments
    RegExp commentRE = RegExp(r'<!-*.*?-*>', dotAll: true);
    raw = raw.replaceAll(commentRE, '');

    // Handle the specific cases
    switch (pageType) {
      case (PageType.home):
        // Clean tables only in the home page
        debugPrint('Home');
        assert(randomQuestionID != null);
        raw = homePage2CodeBlock(raw);
        break;
      case (PageType.answers):
        // Set links to codeBlocs
        raw = cleanAnswerLinks(raw);
        break;
      case (PageType.bible):
        // Set links to codeBlocs
        raw = biblePage2CodeBlock(raw);
        break;

      default:
        break;
    }
    return raw;
  }

  /// Convert the necessary text in the Bible page to a code block
  static String biblePage2CodeBlock(String raw) {
    debugPrint('');
    debugPrint('*** Converting Bible page ***');
    debugPrint('');

    // Get the blocks
    RegExp blockRE = RegExp(r'(?<=.)(###.*?$)', dotAll: true);
    int? dataBlockIndex = blockRE.firstMatch(raw)?.start;

    assert(
      dataBlockIndex != null,
      "Data block could not be read from the Bible page",
    );

    // Create the data string
    // "String before the block" + ``` + ID + separator + block + ```
    String finalString =
        "${raw.substring(0, dataBlockIndex!)}```\n${Constants.bibleListID}${Constants.idSeparator}${raw.substring(dataBlockIndex)}\n```";
    // debugPrint(finalString.substring(finalString.length-100));
    return finalString;
  }

  /// Convert the necessary text in the Home page to a code block
  static String homePage2CodeBlock(String raw) {
    debugPrint(' - Cleaning homePage tables to codeBlock');

    // Clean unused elements
    final blockRE = RegExp(r'(\[!.*?$)', dotAll: true);
    int? dataBlockIndex = blockRE.firstMatch(raw)?.start;

    if (dataBlockIndex == null) {
      assert(
        dataBlockIndex != null,
        "Data block could not be read from the Bible page",
      );
      return "";
    }

    // The index of the first new line
    int indexPlace = raw.indexOf("\r\n\r\n");

    // Create the data string
    // "String before the block" + ``` + ID + separator + block + ```
    String finalString =
        "${raw.substring(0,dataBlockIndex)}\n```\n${Constants.homePageID}${Constants.idSeparator}\n${raw.substring(dataBlockIndex)}```";
    if (indexPlace > 0) {
      // "String before the block" + ``` + ID + separator + block + ``` + String after the block
      finalString =
          "${raw.substring(0, indexPlace)}\n```\n${Constants.homePageID}${Constants.idSeparator}\n${raw.substring(dataBlockIndex)}```\n${raw.substring(indexPlace, dataBlockIndex)}";
    }
    return finalString;
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

    return raw.substring(0, blockIndex) +
        allCodeBlocks +
        raw.substring(blockIndex);
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
