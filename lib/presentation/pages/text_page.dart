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
      assert(
        !(author == null && translator == null),
        "You must give at least one",
      );
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
                  Text(
                    "> $title",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  authorBox(author: "Erkki Koskenniemi"),
                  authorBox(translator: "Erkki Kääntäjä"),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                debugPrint('User wants to share $title');
              },
              icon: Constants.iconShare,
            ),
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

    Widget bodyText(String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      );
    }

    Widget quoteText(String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.format_quote_rounded, size: 35),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      );
    }

    Widget highLightText(String text) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 0, 12),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).primaryColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    Widget listBlock(List<String> texts, {bool useIndexes = false}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: texts.asMap().entries.map((entry) {
          String text = entry.value;
          int index = entry.key;
          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 0, 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !useIndexes
                    ? Icon(Icons.arrow_right, size: 20)
                    : Container(
                        alignment: Alignment.centerRight,
                        width: 30,
                        child: Text(
                          "${index + 1}. ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        titleBox(
                          answers[id]["items"][itemIndex] ?? "",
                          "Etusivu/Vastaukset/${answers[id]["title"]}",
                        ),
                        bodyText(
                          "Yksi ihmisen perustavimmista tarpeista on löytää elämälle merkitys. Voimme etsiä elämän tarkoitusta hyvän tekemisestä, rakkaista ihmisistä, työstä, elämän jatkamisesta, viisauden etsimisestä jne., mutta mikään niistä ei voi täysin rauhoittaa sielun syvimpiä kysymyksiä. \n\nElämän tarkoituksen voi löytää siitä lähtökohdasta käsin, että meidät on luotu elämään Jumalan yhteydessä. Niin kauan kuin elämme erossa Jumalasta, elämästämme puuttuu jotain täysin olennaista. Meidän tärkein päämäärämme on saada elää sillä paikalla, jolle meidät on luotu – eli Jumalan luona, ilman mitään syntiä ja pahuutta, joka erottaisi meitä hänestä. Niinpä tärkeintä elämässämme on oppia tuntemaan Jeesus, joka itse on ainoa todellinen elämä. Häneen uskoen pääsemme kerran perille Taivaallisen Isämme kotiin taivaaseen.\n\nVaikka lopullinen päämäärämme on taivaassa, ei elämämme täällä maan päälläkään ole merkityksetöntä. Me saamme elää Jumalan rakastamina, rakastaen Häntä ja levittäen Hänen rakkauttaan ympärillemme.",
                        ),
                        quoteText(
                          "Juoksen kohti maalia saavuttaakseni voittajan palkinnon, pääsyn taivaaseen. Sinne Jumala kutsuu Kristuksen Jeesuksen omat.\n(Fil. 3:14).",
                        ),
                        highLightText(
                          "Jumala, kun minä en tiedä enkä ymmärrä, näytä minulle tie, jota kulkea.",
                        ),
                        bodyText("Esimerkki listasta:"),
                        listBlock([
                          "Kirkko ja Jumalan Pyhä Henki",
                          "Paavali, joka julisti evankeliumia.",
                          "Se, ettei evankeliumia oltu vielä julistettu kaikille kansoille (Matt 24:14, Mark 13:10)",
                          "Rooman valtakunta, joka piti yllä lakia ja järjestystä.",
                        ], useIndexes: true),
                        const SizedBox(height: 40),
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
