import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class Constants {

  /* Icon constants */
  static IconData iconSelectedBookmark = Icons.bookmark;
  static IconData iconAddBookmark = Icons.bookmark_add_outlined;
  static Icon iconShare = Icon(Icons.share, color: AppThemeData.black,);

  /* Data converters */
  static Map<String, List<String>> internalLinkConvert = {
    '/bible': ['raamattu'],
    '/answers': ['vastauksia'],
    '/catechism': ['katekismus'],
    '/concord': ['tunnustuskirjat'],
    '/showText': [],
    '/about': ['tervetuloa-kotiin']
  };

  /* Markdown cleaner constants */
  static const String idSeparator = "^^^^";
  static const String blockSeparator = "^^^^";
  static const String rowSeparator = "^^^";
  static const String colSeparator = "^^";

  // IDs need to be only one character
  static const String homePageID = "H";
  static const String answerListID = "A";
  static const String bibleListID = "B";

}