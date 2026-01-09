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

    // Clean tables only in the home page
    if (pageType == PageType.home) {
      assert(randomQuestionID != null);
      raw = cleanTables(raw, randomQuestionID!);
    }

    return raw;
  }

  static String cleanTables(String raw, int randomQuestionID) {
    debugPrint(' - Cleaning tables');

    // Clean unused elements
    final unusedRegExp = RegExp(r'<!.*>', dotAll: true);
    raw = raw.replaceAll(unusedRegExp, '');

    // Extracting the table elements
    // final elementRegExp = RegExp(r'(\[!.*)-{3}', dotAll: true);
    final elementRegExp = RegExp(r'\[!(.*?)-{3,}\|-{3,}', dotAll: true);
    List<String?> elements = elementRegExp
        .allMatches(raw)
        .map((e) => e.group(0))
        .toList();
    debugPrint(' - category length: ${elementRegExp.allMatches(raw).length}');

    // Remove the elements
    raw = raw.replaceAll(elementRegExp, '');

    // Add the opening symbol of the code block and the identifier
    String mdButtons = "```${Constants.homeButtonID}${Constants.rowSeparator}";
    final mdButtonsInitialLength = mdButtons.length;

    for (final element in elements) {
      if (element == null) break;
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

      // Add a custom line break
      if (mdButtons.length > mdButtonsInitialLength) {
        mdButtons += Constants.rowSeparator;
      }
      String mdRow =
          '$labelString${Constants.colSeparator}$pathString${Constants.colSeparator}$imageString';

      mdButtons += "$mdRow ";
    }
    // Add the closing symbol for the code block
    mdButtons += "```";

    // The index of the first new line
    int indexPlace = raw.indexOf("\n");

    String randomQuestionBox =
        '```${Constants.questionButtonID}${Constants.rowSeparator}$randomQuestionID```';

    String mdFinal =
        "${raw.substring(0, indexPlace)} $mdButtons $randomQuestionBox ${raw.substring(indexPlace)}";

    return mdFinal;
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
