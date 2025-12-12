// how to run: flutter packages pub run build_runner build
import 'dart:convert';

import 'package:hive/hive.dart';

part 'raw_json_data.g.dart';

@HiveType(typeId: 2)
class RawJsonData {
  /// The rawData got from the API
  /// The data is encoded JSON
  @HiveField(0)
  final String rawData;

  /// The language of the data
  @HiveField(1)
  final String languageCode;

  /// Keeps track of the time when is the most recent time the data has been updated
  @HiveField(2)
  final DateTime updatedTime = DateTime.now();

  RawJsonData({required this.rawData, required this.languageCode});

  List<Map<String, dynamic>> get jsonData =>
      List<Map<String, dynamic>>.from(jsonDecode(rawData));


  @override
  String toString() {
    return "Rawdata of $languageCode, has ${jsonData.length} data points, updated: $updatedTime";
  }

}
