import 'dart:convert';

import 'package:bible_toolbox/core/Widgets/link_headline.dart';
import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  List<dynamic> answers = [];
  bool isDataReady = false;
  bool firstTimeWithData = true;

  @override
  void initState() {
    super.initState();
    debugPrint('\n*****\n IN TEXT PAGE\n*****');
    loadJson();
  }

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString(
      'assets/test_data/answersTest.json',
    );
    final data = json.decode(response);
    setState(() {
      answers = data['answers'];
      isDataReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(
      ModalRoute.of(context)!.settings.arguments != null,
      "There are no arguments for the text page",
    );
    Map<String, dynamic> model =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int id = model["id"];
    String? selectedHeadline = model["clicked"];

    debugPrint('\nIs data ready: $isDataReady');
    debugPrint('id: $id');
    debugPrint('selectedHeadline: $selectedHeadline');

    if (isDataReady && firstTimeWithData) {
      firstTimeWithData = false;
      if (selectedHeadline != null) {
        Future.delayed(const Duration(milliseconds: 5), () {
          debugPrint('len of items: ${answers[id]["items"].length}');
          int indexToJump = answers[id]["items"].indexWhere(
            (item) => item == selectedHeadline,
          );
          debugPrint('itemToJump: $indexToJump');
          itemScrollController.jumpTo(index: indexToJump + 1);
        });
      }
    }

    Widget contentList(List<dynamic> contentList) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: contentList
              .map(
                (item) => LinkHeadline(
                  text: item,
                  onTap: () {
                    debugPrint('Pressed: $item');
                    itemScrollController.scrollTo(
                      index: contentList.indexOf(item) + 1,
                      duration: const Duration(milliseconds: 100),
                    );
                  },
                ),
              )
              .toList(),
        ),
      );
    }

    Widget authorBox({String? author, String? translator}) {
      assert(!(author == null && translator == null), "You must give at least one");
      return Text(
        author != null ? "Kirjoittanut: $author" : "Kääntänyt: $translator",
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    Widget titleBox(String title, String path) {
      bool isBookmarked = BookmarkHelper.isPageBookmarked(title);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  authorBox(author: "Erkki Koskenniemi"),
                  authorBox(translator: "Erkki Kääntäjä"),
                ],
              ),
            ),
            IconButton(onPressed: () {
              debugPrint('User wants to share $title');
            }, icon: Constants.iconShare),
            IconButton(
              onPressed: () async {
                if (!isBookmarked) {
                  await BookmarkHelper.addBookmark(title, path);
                } else {
                  await BookmarkHelper.deleteBookmark(title: title);
                }
                setState(() {});
              },
              icon: isBookmarked
                  ? Icon(
                      Constants.iconSelectedBookmark,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : Icon(
                      Constants.iconAddBookmark,
                      color: Theme.of(context).colorScheme.outline,
                    ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: MainAppBar(
        title: isDataReady ? answers[id]["title"] : "",
        useSmallAppBar: true,
        showBookmarkButton: false,
      ),
      body: isDataReady
          ? ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemCount: answers[id]["items"].length + 1 ?? 0,
              itemBuilder: (context, i) {
                int itemIndex = i - 1;
                if (i == 0) {
                  return contentList(answers[id]["items"]);
                } else {
                  return Container(
                    margin: EdgeInsets.all(16),
                    // color: Colors.greenAccent,
                    height: 700,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        titleBox(
                          answers[id]["items"][itemIndex] ?? "",
                          "Etusivu/Vastaukset/${answers[id]["title"]}",
                        ),


                      ],
                    ),
                  );
                }
              },
            )
          : const SizedBox(),
    );
  }
}
