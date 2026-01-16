import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class Constants {
  /* Icon constants */
  static IconData iconSelectedBookmark = Icons.bookmark;
  static IconData iconAddBookmark = Icons.bookmark_add_outlined;
  static Icon iconShare = Icon(Icons.share, color: AppThemeData.black);

  /* Data converters */

  /// The lists have keywords, which are in the URLs. This translates the
  /// keywords to app links.
  static Map<String, List<String>> internalLinkConvert = {
    '/bible': ['raamattu', 'bible'],
    '/answers': ['vastauksia', 'answers'],
    '/catechism': ['katekismus', 'catechism'],
    '/concord': ['tunnustuskirjat', 'concord'],
    '/showText': [],
    '/about': ['tervetuloa-kotiin'],
  };

  /// Return a path for a page based on a pre-defined text in internalLinkConverter
  static String? getPath(String text) {
    for (String key in internalLinkConvert.keys) {
      if (internalLinkConvert[key]!.contains(text)) {
        return key;
      }
    }
    debugPrint(' ~ Not path found for: $text');
    return null;
  }

  /* Markdown cleaner constants */
  static const String idSeparator = "^^^^";

  // IDs need to be only one character
  static const String homePageID = "H";
  static const String answerListID = "A";
  static const String bibleListID = "B";
}
