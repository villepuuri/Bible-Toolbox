import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';

part 'bookmark.g.dart';

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

  // todo: internalize this
  String get creationDate => DateFormat('d.M.yyyy').format(creationTime);

  @override
  String toString() {
    return "Bookmark: $name, ID: $id, typeId: $typeId, creationTime: $creationTime";
  }
}
