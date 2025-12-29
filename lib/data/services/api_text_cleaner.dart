


class ApiTextCleaner{

  /// Calls different functions to clean the raw api data
  static String cleanText(String raw) {

    String result = cleanLink(raw);
    result = cleanFont(result);

    // Fix the bolded text
    result = result.replaceAll('<b>', '**').replaceAll('</b>', '**');

    result = fixQuoteBlocks(result);

    return result;
  }

  /// Change the possible HTML link to markdown syntax
  static String cleanLink(String raw) {
    int htmlIndex = raw.indexOf("<hr>"); // todo: maybe change this
    if (htmlIndex != -1) {
      String htmlLink = raw.substring(0,htmlIndex);

      // Regular Expression to detect the link items
      final linkRegex = RegExp(
        r'<a\s+href="([^"]+)"[^>]*>(.*?)<\/a>',
        caseSensitive: false,
      );

      // Changing the html link to markdown link
      String mdLink = htmlLink.replaceAllMapped(linkRegex, (match) {
        final url = match.group(1)!;
        final text = match.group(2)!;
        return '[$text]($url)';
      });

      return "$mdLink\n---\n${raw.substring(htmlIndex+4)}";
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
    final regex = RegExp(
      r'\r\n>([\s\S]*?)\r\n\r\n',
      multiLine: true,
    );
    return raw.replaceAllMapped(regex, (match) {
      // final full = match.group(0)!;       // whole matched quote block
      final inner = match.group(1)!;      // text inside the block (after '>')

      // Removes unnecessary ">" marks
      var convertedInner = inner.replaceAll('>', '');
      // Replace CRLF inside the block
      convertedInner = convertedInner.replaceAll('\r\n', '<br>');

      // Rebuild the block with replaced linebreaks
      return '\r\n>$convertedInner\r\n\r\n';
    });
  }

}