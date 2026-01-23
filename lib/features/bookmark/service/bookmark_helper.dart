

import 'package:bible_toolbox/features/content/data/models/article_data.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/services/boxes.dart';
import '../models/bookmark.dart';

class BookmarkHelper {
  /// Function returns true/false depending if the page is in bookmarks
  static bool isPageBookmarked(String title) =>
      boxBookmarks.values.any((b) => b.name == title);

  static Future<void> addBookmark(ArticleData article, {BookmarkType? type}) async {
    BookmarkType newType = BookmarkType.other;
    switch (article.type) {
      case (ArticleType.catechism):
        newType = BookmarkType.catechism;
        break;
      case (ArticleType.bible):
        newType = BookmarkType.bible;
        break;
      case (ArticleType.answers):
        newType = BookmarkType.answer;
        break;
      default:
        break;
    }

    Bookmark bookmark = Bookmark(
      name: article.title,
      typeId: type?.index ?? newType.index,
      id: article.id,
      languageCode: article.language,
    );
    debugPrint('Adding a new bookmark: $bookmark');
    await boxBookmarks.put(bookmark.id, bookmark);
  }

  /// Deletes a bookmark based on a title or id
  static Future<void> deleteBookmark({String? title, String? id}) async {
    assert(title == null || id == null, "Either title or id needs to be given");
    Bookmark? bookmarkToDelete;
    if (title != null) {
      bookmarkToDelete = boxBookmarks.values.firstWhere((b) => b.name == title);
    } else if (id != null) {
      bookmarkToDelete = boxBookmarks.values.firstWhere((b) => b.id == id);
    }
    assert(bookmarkToDelete != null, "No bookmark found");

    debugPrint(
      'Page: ${bookmarkToDelete?.name} is to be removed from bookmarks ${bookmarkToDelete?.id}',
    );
    await boxBookmarks.delete(bookmarkToDelete?.id);
  }

  static void printBookmarks() {
    debugPrint('\n Bookmarks:');
    for (var b in boxBookmarks.keys) {
      debugPrint('  ${b.toString()}');
    }
  }
}