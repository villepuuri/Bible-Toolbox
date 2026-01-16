import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/Widgets/page_button.dart';
import '../../core/helpers/language_helper.dart';
import '../../providers/language_provider.dart';
import '../services/article_data.dart';

/// Builds the home page buttons based on [rawData] produced by the ApiTextCleaner
class HomePageList extends StatefulWidget {
  final String rawData;

  const HomePageList({super.key, required this.rawData});

  @override
  State<HomePageList> createState() => _HomePageListState();
}

class _HomePageListState extends State<HomePageList> {
  Map<String, dynamic>? dataMap;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String jsonString = await rootBundle.loadString(
      'assets/test_data/answersCategories.json',
    );
    dataMap = jsonDecode(jsonString);
    debugPrint('DataMap got');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget buildQuestionButton() {
      return Builder(
        builder: (context) {
          ArticleData randomQuestion = LanguageHelper.getRandomQuestion(
            context.read<LanguageProvider>().locale.languageCode,
          );

          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Löydä vastauksia:",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('QuestionButton pressed');
                    // todo: implement navigation
                    // Find the category, where the question is
                    for (final category in dataMap!.values) {
                      List<int> idList = category["elementit"]["fi"]
                          .cast<int>();
                      if (idList.contains(randomQuestion.id)) {
                        String categoryTitle = LanguageHelper.getArticleById(
                          'fi',
                          category["kategoria"]["fi"],
                        ).title;
                        Navigator.pushNamed(
                          context,
                          '/showText',
                          arguments: {
                            'idList': idList,
                            'selectedID': randomQuestion.id,
                            'headline': categoryTitle,
                          },
                        );
                      }

                    }
                  },
                  child: Text(randomQuestion.title),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    }

    List<Widget> extractWidgets() {
      List<Widget> widgetList = [];
      // Extracting the table elements
      final elementRegExp = RegExp(r'\[!(.*?)-{3,}\|-{3,}', dotAll: true);
      List<String?> elements = elementRegExp
          .allMatches(widget.rawData)
          .map((e) => e.group(0))
          .toList();
      debugPrint(
        ' - category length: ${elementRegExp.allMatches(widget.rawData).length}',
      );

      for (final element in elements) {
        if (element == null) continue;
        // Image string
        RegExp imageRE = RegExp(r'/(\w{2,})(?=\.png)', multiLine: true);
        String? imageString = imageRE
            .firstMatch(element)
            ?.group(1)
            ?.replaceAll("\n", "");

        // Path string
        RegExp pathRE = RegExp(r'(\w{2,})(?=)\)\s\|', multiLine: true);
        String? pathString = pathRE
            .firstMatch(element)
            ?.group(1)
            ?.replaceAll("\n", "");

        // URL string
        RegExp linkTextRE = RegExp(
          r'(?<=)\s\|\s\[(.*?)].*?\)(.*?)-{3,}',
          dotAll: true,
        );
        RegExpMatch? labelMatch = linkTextRE.firstMatch(element);
        String? labelString =
            ((labelMatch?.group(1) ?? "") + (labelMatch?.group(2) ?? ""))
                .replaceAll("\n", "")
                .trim();

        assert(imageString != null, "ImageString is null");
        assert(pathString != null, "PathString is null");
        if (imageString == null || pathString == null) continue;

        widgetList.add(
          PageButton(
            title: labelString,
            imagePath: imageString,
            path: pathString,
          ),
        );
      }

      List<Widget> list = widgetList + [buildQuestionButton()];
      return list;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: extractWidgets(),
      ),
    );
  }
}
