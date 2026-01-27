import 'dart:convert';

import 'package:bible_toolbox/core/services/result.dart';
import 'package:bible_toolbox/features/content/data/services/extract_key_information.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/models/article_data.dart';
import 'page_button.dart';
import 'package:bible_toolbox/features/language/providers/language_provider.dart';

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
          Result<ArticleData> randomQuestionResult = LanguageHelper.getRandomQuestion(
            context.read<LanguageProvider>().locale.languageCode,
          );
          if (randomQuestionResult.isError) return const SizedBox();

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
                      if (idList.contains(randomQuestionResult.value.id)) {
                        Result categoryResult = LanguageHelper.getArticleById(
                          'fi',
                          category["kategoria"]["fi"],
                        );
                        if (categoryResult.isError) {
                          // todo: show error
                        }
                        else {
                          Navigator.pushNamed(
                            context,
                            '/showText',
                            arguments: {
                              'idList': idList,
                              'selectedID': randomQuestionResult.value.id,
                              'headline': categoryResult.value.title,
                            },
                          );
                        }
                      }
                    }
                  },
                  child: Text(randomQuestionResult.value.title),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    }

    List<Widget> extractWidgets() {
      // Get the category map
      Result<Map<String, dynamic>> categoryMapResult =
          ExtractKeyInformation.getMainCategories(
            context.read<LanguageProvider>().locale.languageCode,
          );

      if (categoryMapResult.isError) return [];

      // Convert the map to widgets
      List<Widget> buttons = categoryMapResult.value.entries
          .map<Widget>(
            (entry) => PageButton(
              title: entry.key,
              imagePath: entry.value["image"],
              path: entry.value["path"],
            ),
          )
          .toList();

      return buttons + [buildQuestionButton()];
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
