import 'package:bible_toolbox/core/Widgets/extendable_headline.dart';
import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:bible_toolbox/core/helpers/box_service.dart';
import 'package:bible_toolbox/core/theme.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  bool sortExtended = false;

  Map<String, bool> selectedSorts = {
    "Kaikki": true,
    "Vastaukset": false,
    "Raamattu": false,
    "Katekismus": false,
    "Tunnustuskirjat": false,
  };

  Widget dividerLine({double width = 1}) =>
      Container(color: Theme.of(context).colorScheme.primary, height: width);

  Widget sortBox(String name) {
    bool selected = selectedSorts[name] ?? false;
    return OutlinedButton(
      style: AppThemeData.outlinedButtonTheme.style?.copyWith(
        backgroundColor: selected
            ? WidgetStateProperty.all(Theme.of(context).primaryColor)
            : null,
      ),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: selected
                ? Theme.of(context).textTheme.labelSmall?.apply(
                    color: Colors.white,
                    fontWeightDelta: 2,
                  )
                : Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  List<Bookmark> getSortedBookmarks() {
    List<Bookmark> list = [];
    int typeIndex = selectedSorts.values.toList().indexOf(true);
    for (var b in boxBookmarks.values) {
      if (typeIndex == 0) {
        list.add(b);
      } else if (typeIndex - 1 == b.type.index) {
        list.add(b);
      }
    }
    list.sort((a, b) => a.creationTime.compareTo(b.creationTime));
    debugPrint('List len: ${list.length}');
    // todo: create the sorting
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<Bookmark> bookmarkList = getSortedBookmarks();

    void moveToPage(String path) {
      /* When pressing a bookmark, this function is used to navigate
      * to the new page */
      // todo: Build navigation to a new page
      debugPrint('User wants to move to page: $path');
      UnimplementedError();
    }

    Widget bookmarkTile(Bookmark b) {
      return Material(
        // Material-widget is required to build the bg well
        child: Padding(
          key: ValueKey(b.id),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(b.name, style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(
              b.path,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: PopupMenuButton(
              itemBuilder: (menuContext) {
                return [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.titleGo,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.titleRemove,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.bookmark_remove_outlined),
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                // if value 1 show dialog
                if (value == 1) {
                  moveToPage(b.path);
                }
                // if value 2 show dialog
                else if (value == 2) {
                  // Remove item from the bookmarks
                  debugPrint('Deleting the following bookmark: ${b.name}');
                  boxBookmarks.delete(b.id);
                  setState(() {});
                }
              },
            ),
            splashColor: AppThemeData.opaqueGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            onTap: () {
              moveToPage(b.path);
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: MainAppBar(
        title: AppLocalizations.of(context)!.titleBookmarks,
        useSmallAppBar: true,
        showBookmarkButton: false,
        showLanguageButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ExtendableHeadline(
                title: AppLocalizations.of(context)!.titleSort,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 0,
                    children: [
                      sortBox("Kaikki"),
                      sortBox("Vastaukset"),
                      sortBox("Raamattu"),
                      sortBox("Katekismus"),
                      sortBox("Tunnustuskirjat"),
                    ],
                  ),
                ],
              ),
            ),
            /* The actual bookmarks */
            SliverList(
              delegate: SliverChildListDelegate(
                bookmarkList.map(((b) => bookmarkTile(b))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
