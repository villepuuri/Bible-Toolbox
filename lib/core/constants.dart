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
  static String rowSeparator = "^^^";
  static String colSeparator = "^^";
  static String homeButtonID = "homeButton";
  static String questionButtonID = "questionButton";

}