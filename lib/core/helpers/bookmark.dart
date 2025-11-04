import 'dart:math';
import 'package:hive/hive.dart';

part 'bookmark.g.dart';

enum BookmarkType {
  answer,
  bible,
  catechism,
  concord,
  other
}

@HiveType(typeId: 1)
class Bookmark {
  @HiveField(0)
  String id = DateTime
      .now()
      .millisecondsSinceEpoch
      .toString();

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
    }
    else if (creationTime.second % 3 == 0) {
      return BookmarkType.concord;
    }
    return BookmarkType.bible;
    // return BookmarkType.values[Random().nextInt(BookmarkType.values.length)];
  }
}
