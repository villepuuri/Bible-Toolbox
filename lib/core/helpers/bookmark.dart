import 'package:bible_toolbox/core/helpers/box_service.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'bookmark.g.dart';

enum BookmarkType { answer, bible, catechism, concord, other }

@HiveType(typeId: 1)
class Bookmark {
  @HiveField(1)
  String name;

  @HiveField(2)
  int typeId;

  @HiveField(3)
  late DateTime creationTime;

  @HiveField(4)
  int id;

  @HiveField(5)
  String languageCode;

  // todo: Before building the app, make sure that these are correct

  Bookmark({
    required this.name,
    required this.typeId,
    required this.id,
    required this.languageCode,
    DateTime? creationTime,
  }) : creationTime = creationTime ?? DateTime.now();

  BookmarkType get type => BookmarkType.values[typeId];

  @override
  String toString() {
    return "Bookmark: $name, ID: $id, typeId: $typeId, creationTime: $creationTime";
  }
}

class BookmarkHelper {
  /// Function returns true/false depending if the page is in bookmarks
  static bool isPageBookmarked(String title) =>
      boxBookmarks.values.any((b) => b.name == title);

  static Future<void> addBookmark(ArticleData article) async {
    BookmarkType type = BookmarkType.other;
    switch (article.type) {
      case (ArticleType.catechism):
        type = BookmarkType.catechism;
        break;
      case (ArticleType.bible):
        type = BookmarkType.bible;
        break;
      case (ArticleType.answers):
        type = BookmarkType.answer;
        break;
      default:
        break;
    }

    Bookmark bookmark = Bookmark(
      name: article.title,
      typeId: type.index,
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
