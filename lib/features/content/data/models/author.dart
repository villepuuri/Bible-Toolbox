

class Author {
  /// The taxonomy id of the author
  final int tid;

  final String name;

  /// The vocabulary ID of the autor (the id of the author type)
  final int vid;

  /// The type of the author (equivalent to vid)
  final String vocabulary;

  Author({
    required this.name,
    required this.vid,
    required this.vocabulary,
    required this.tid,
  });

  @override
  String toString() {
    return '$name ($tid), $vocabulary';
  }

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      tid: json["tid"],
      name: json["name"],
      vid: json["vid"],
      vocabulary: json["vocabulary"],
    );
  }
}