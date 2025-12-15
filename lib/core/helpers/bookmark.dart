import 'package:bible_toolbox/core/helpers/box_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'bookmark.g.dart';

enum BookmarkType { answer, bible, catechism, concord, other }

@HiveType(typeId: 1)
class Bookmark {
  @HiveField(0)
  String id = DateTime.now().millisecondsSinceEpoch.toString();

  @HiveField(1)
  String name;

  @HiveField(2)
  String path;

  @HiveField(3)
  late DateTime creationTime;

  // todo: Before building the app, make sure that these are correct
  // todo: Maybe add type?

  Bookmark({required this.name, required this.path, DateTime? creationTime})
    : creationTime = creationTime ?? DateTime.now();

  @override
  String toString() {
    return "Bookmark: $name, ID: $id, path: $path, creationTime: $creationTime";
  }

  BookmarkType get type {
    // todo: Fix this after getting the correct path
    if (creationTime.second % 2 == 0) {
      return BookmarkType.answer;
    } else if (creationTime.second % 3 == 0) {
      return BookmarkType.concord;
    }
    return BookmarkType.bible;
    // return BookmarkType.values[Random().nextInt(BookmarkType.values.length)];
  }
}

class BookmarkHelper {
  /// Function returns true/false depending if the page is in bookmarks
  static bool isPageBookmarked(String title) =>
      boxBookmarks.values.any((b) => b.name == title);

  static Future<void> addBookmark(String title, String path) async {
    Bookmark bookmark = Bookmark(name: title, path: path);
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
