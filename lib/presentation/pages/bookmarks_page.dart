import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:bible_toolbox/core/helpers/boxes.dart';
import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  Map<String, bool> selectedSorts = {
    "Kaikki": true,
    "Vastaukset": false,
    "Raamattu": false,
    "Katekismus": false,
    "Tunnustuskirjat": false,
    "Uusin": true,
    "Vanhin": false,
  };

  Widget sortBox(String name, {String? imageURL, bool selected = false}) {
    bool selected = selectedSorts[name] ?? false;
    return FilledButton(

      onPressed: () {
        if (!(selectedSorts[name] ?? false)) {
          // Deselect all
          for (String key in selectedSorts.keys) {
            selectedSorts[key] = false;
          }
          selectedSorts[name] = true;
          setState(() {});
        }
      },
      child: Container(
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(18),
        //   border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        //   color: selected
        //       ? Theme.of(context).primaryColor
        //       : Theme.of(context).colorScheme.surface,
        // ),
        // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            imageURL != null
                ? Container(
              width: 30,
                height: 30,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme.of(context).colorScheme.surface
                ),
                child: Image.asset(imageURL))
                : const SizedBox(),
            SizedBox(width: imageURL != null ? 8 : 0),
            Text(
              name,
              style: selected
                  ? Theme.of(context).textTheme.bodyMedium?.apply(
                      color: Colors.white,
                      fontWeightDelta: 2,
                    )
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Kirjanmerkit"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Bookmark bookmark = Bookmark(
            name: "Kirjanmerkki ${boxBookmarks.length +1}",
            path: "/testi/kirjan/merkki",
          );
          boxBookmarks.put(bookmark.id, bookmark);
          debugPrint('Test bookmark added, box size: ${boxBookmarks.length}');
          setState(() {});
          for (Bookmark value in boxBookmarks.values) {
            debugPrint(" - $value");
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Rajaa ja järjestä",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  sortBox("Kaikki"),
                  sortBox(
                    "Vastaukset",
                    imageURL: 'assets/btb_images/kysymysmerkki.png',
                  ),
                  sortBox(
                    "Raamattu",
                    imageURL: 'assets/btb_images/raamattu.png',
                  ),
                  sortBox(
                    "Katekismus",
                    imageURL: 'assets/btb_images/katekismus.png',
                  ),
                  sortBox(
                    "Tunnustuskirjat",
                    imageURL: 'assets/btb_images/tunnustuskirjat.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
