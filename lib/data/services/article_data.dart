import 'package:bible_toolbox/data/services/api_text_cleaner.dart';

/// The different text types used to create the text blocks
///       ["katekismus",
///       "page",
///       "raamattu",
///       "vastauksia_etsiville",
///       "uskon_abc"]
enum ArticleType { catechism, page, bible, answers, faith, none }

/// Holds data for a text block
///
/// Based on this, a list of data can be contained and data is easily formatted
/// to text pages.

class ArticleData {
  /// The article id
  final int id;

  /// The type of the article
  final ArticleType type;

  final String title;

  final String language;

  /// Creation time in seconds
  final int created;

  /// Changed time in seconds
  final int changed;

  /// Raw body-value text
  final String body;

  final String summary;

  final List<Author> authors;

  final String url;

  ArticleData({
    required this.id,
    required this.type,
    required this.title,
    required this.language,
    required this.created,
    required this.changed,
    required this.body,
    required this.summary,
    required this.authors,
    required this.url,
  });

  /// Get the list of original writers
  List<Author> get writers =>
      authors.where((writer) => writer.vid == 6).toList();

  /// Get the list of original translators
  List<Author> get translators =>
      authors.where((writer) => writer.vid == 7).toList();

  /// Get the displayed text for the writers
  String get writerNames {
    String names = writers.first.name;
    for (int i = 1; i < writers.length; i++) {
      names += ", ${writers[i].name}";
    }
    return names;
  }

  /// Get the displayed text for the translators
  String get translatorNames {
    String translatorText = translators.first.name;
    for (int i = 1; i < translators.length; i++) {
      translatorText += ", ${translators[i].name}";
    }
    return translatorText;
  }

  DateTime get creationTime =>
      DateTime.fromMillisecondsSinceEpoch(created * 1000);

  DateTime get changeTime =>
      DateTime.fromMillisecondsSinceEpoch(changed * 1000);

  String get cleanBody => ApiTextCleaner.cleanText(body);

  String get path => type.name; // todo: fix path

  @override
  String toString() {
    return 'Title:\t$title\n'
        'authors:\t${authors.length}\n'
        'author:\t${authors.first}\n'
        'ID:\t\t$id\n'
        'type:\t${type.name}\n'
        'lang:\t$language\n'
        'created:\t$creationTime\n'
        'changed:\t$changeTime\n'
        'body:\t${cleanBody.substring(0, 50)}...\n'
        'url:\t\t$url\n';
  }

  /// Create an Article class based on a JSON data from API
  factory ArticleData.fromJson(Map<String, dynamic> json) {
    ArticleType articleType = ArticleType.none;
    switch (json['type']) {
      case "katekismus":
        articleType = ArticleType.catechism;
        break;
      case "page":
        articleType = ArticleType.page;
        break;
      case "raamattu":
        articleType = ArticleType.bible;
        break;
      case "vastauksia_etsiville":
        articleType = ArticleType.answers;
        break;
      case "uskon_abc":
        articleType = ArticleType.faith;
        break;
    }
    assert(
      articleType != ArticleType.none,
      "Article type has not been selected!",
    );

    // Get the list of authors
    List<Author> authors = [];
    for (var author in json["taxonomy"]) {
      authors.add(Author.fromJson(author));
    }

    return ArticleData(
      id: json["id"],
      type: articleType,
      title: json["title"],
      language: json["language"],
      created: json["created"],
      changed: json["changed"],
      body: json["body"]["value"],
      summary: json["body"]["summary"],
      authors: authors,
      url: json["url"],
    );
  }
}

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
