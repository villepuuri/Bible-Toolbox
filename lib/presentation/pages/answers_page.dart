import 'dart:convert';

import 'package:bible_toolbox/core/Widgets/extendable_headline.dart';
import 'package:bible_toolbox/core/Widgets/link_headline.dart';
import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnswersPage extends StatefulWidget {
  const AnswersPage({super.key});

  @override
  State<AnswersPage> createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  List<dynamic> answers = [];
  List<bool> openHeadlines = [];

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString(
      'assets/test_data/answersTest.json',
    );
    final data = json.decode(response);
    setState(() {
      openHeadlines = List.filled(data['answers'].length, false);
      answers = data['answers'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // The texts that are on top of the page after the app bar
    List<Widget> introToAnswers = [
      SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 12),
        sliver: SliverToBoxAdapter(
          child: Text(
            "Suuret kysymykset",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 5),
        sliver: SliverToBoxAdapter(
          child: Text(
            "Täältä löydät vastauksia elämän suuriin kysymyksiin ja useimmin esitettyihin kysymyksiin Jumalasta.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    ];

    // The line that is used to divide elements in the page
    Widget spacerLine({double width = 1, double paddingHeight = 24}) {
      return SliverToBoxAdapter(
        child: Divider(
          thickness: width,
          height: paddingHeight,
          color: Theme.of(context).primaryColor,
        ),
      );
    }

    // Creates a list of listTiles of answer categories
    List<Widget> getAnswerTiles() {
      return answers.asMap().entries.map((entry) {
        var answer = entry.value;
        return ExtendableHeadline(
          title: answer["title"],
          onTap: () {
            debugPrint('User wants to open: ${answer["title"]} with top');
            Navigator.pushNamed(context, '/showText',
                arguments: {
                  'id': entry.key,
                }
            );
          },
          children: (answer["items"] as List<dynamic>)
              .map(
                (question) => LinkHeadline(text: question, onTap: () {
                  debugPrint('User wants to open: $question');
                  Navigator.pushNamed(context, '/showText',
                      arguments: {
                        'id': entry.key,
                        'clicked': question
                      }
                  );
                },)
              )
              .toList(),
        );
      }).toList();
    }

    SliverList topicList = SliverList(
      delegate: SliverChildListDelegate(getAnswerTiles()),
    );

    return Scaffold(
      appBar: MainAppBar(title: "Vastaukset"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: CustomScrollView(
          slivers: introToAnswers + [spacerLine(), topicList],
        ),
      ),
    );
  }
}
