import 'dart:convert';

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
    final data = await json.decode(response);
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
            style: Theme.of(context).textTheme.headlineLarge,
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
    Widget spacerLine({double width = 1, double paddingHeight = 12}) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(vertical: paddingHeight),
        sliver: SliverToBoxAdapter(
          child: Container(
            height: width,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    // Creates a list of listTiles of answer categories
    List<Widget> getAnswerTiles() {
      return answers.asMap().entries.map((entry) {
        int index = entry.key;
        var answer = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* The Headline */
              InkWell(
                onTap: () {
                  setState(() {
                    openHeadlines[index] = !openHeadlines[index];
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      answer["title"],
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            openHeadlines[index] = !openHeadlines[index];
                          });
                        },
                        padding: const EdgeInsets.all(1),
                        constraints: BoxConstraints(),
                        icon: Image.asset(
                          openHeadlines[index]
                              ? 'assets/btb_images/miinus.png'
                              : 'assets/btb_images/plussa.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /* The divider line */
              Container(height: 1, color: Theme.of(context).primaryColor),

              const SizedBox(height: 10,),

              /* The question titles */
              Visibility(
                visible: openHeadlines[index],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (answer["items"] as List<dynamic>)
                      .map((question) => Text("> $question", style: Theme.of(context).textTheme.bodyMedium,))
                      .toList(),
                ),
              ),
            ],
          ),
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
