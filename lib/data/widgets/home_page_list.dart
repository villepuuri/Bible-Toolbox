import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Widgets/page_button.dart';
import '../../core/helpers/language_helper.dart';
import '../../providers/language_provider.dart';
import '../services/article_data.dart';

/// Builds the home page buttons based on [rawData] produced by the ApiTextCleaner
class HomePageList extends StatelessWidget {
  final String rawData;

  const HomePageList({super.key, required this.rawData});

  @override
  Widget build(BuildContext context) {
    Widget buildQuestionButton() {
      return Builder(
        builder: (context) {
          ArticleData randomQuestion = LanguageHelper.getRandomQuestion(
            context.read<LanguageProvider>().locale.languageCode,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Löydä vastauksia:",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint('QuestionButton pressed');
                  // todo: implement navigation
                  // Navigator.pushNamed(context, '/showText');
                },
                child: Text(randomQuestion.title),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      );
    }

    List<Widget> extractWidgets() {
      List<Widget> widgetList = [];
      // Extracting the table elements
      final elementRegExp = RegExp(r'\[!(.*?)-{3,}\|-{3,}', dotAll: true);
      List<String?> elements = elementRegExp
          .allMatches(rawData)
          .map((e) => e.group(0))
          .toList();
      debugPrint(
        ' - category length: ${elementRegExp.allMatches(rawData).length}',
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
