import 'dart:convert';

import 'package:bible_toolbox/core/Widgets/extendable_headline.dart';
import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:bible_toolbox/core/helpers/box_service.dart';
import 'package:bible_toolbox/core/theme.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/helpers/language_helper.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  bool sortExtended = false;

  Map<BookmarkType, bool> selectedSorts = {
    BookmarkType.other: true,
    BookmarkType.answer: false,
    BookmarkType.bible: false,
    BookmarkType.catechism: false,
    BookmarkType.concord: false,
  };

  Widget dividerLine({double width = 1}) =>
      Container(color: Theme.of(context).colorScheme.primary, height: width);

  Widget sortBox(BookmarkType type) {
    bool selected = selectedSorts[type] ?? false;
    return OutlinedButton(
      style: AppThemeData.outlinedButtonTheme.style?.copyWith(
        backgroundColor: selected
            ? WidgetStateProperty.all(Theme.of(context).primaryColor)
            : null,
      ),
      onPressed: () {
        if (!(selectedSorts[type] ?? false)) {
          // Deselect all
          for (BookmarkType key in selectedSorts.keys) {
            selectedSorts[key] = false;
          }
          selectedSorts[type] = true;
          setState(() {});
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type.name,
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
    // Get the selected sorting method (0=all)
    BookmarkType selectedType = selectedSorts.entries
        .firstWhere((e) => e.value, orElse: () => selectedSorts.entries.first)
        .key;
    debugPrint('Selected: $selectedType');
    for (Bookmark b in boxBookmarks.values) {
      debugPrint(' - ${b.type}');
      if (selectedType == BookmarkType.other) {
        list.add(b);
      } else if (selectedType.name == b.type.name) {
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

    /// When pressing a bookmark, this function is used to navigate
    /// to the new page with id: pageId
    Future<void> moveToPage(int pageId) async {
      // todo: Build navigation to a new page
      debugPrint('User wants to move to page: $pageId');

      String jsonString = await rootBundle.loadString(
        'assets/test_data/answersCategories.json',
      );
      Map<String, dynamic> dataMap = jsonDecode(jsonString);
      for (final category in dataMap.entries) {
        if (category.value["elementit"]['fi'].contains(pageId) &&
            context.mounted) {
          // Get the articles in the same category
          List<int> idList = category.value["elementit"]['fi'].cast<int>();
          String categoryTitle = LanguageHelper.getArticleById(
            'fi',
            category.value["kategoria"]["fi"],
          ).title;
          // Move to the text page
          Navigator.pushReplacementNamed(
            context,
            '/showText',
            arguments: {
              'idList': idList,
              'selectedID': pageId,
              'headline': categoryTitle,
            },
          );
          break;
        }
      }
    }

    Widget bookmarkTile(Bookmark b) {
      return Material(
        // Material-widget is required to build the bg well
        child: Padding(
          key: ValueKey(b.id),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(b.name, style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text("- ${b.creationDate}"),
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
                  moveToPage(b.id);
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
              moveToPage(b.id);
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
                    children: selectedSorts.keys
                        .map((BookmarkType type) => sortBox(type))
                        .toList(),
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
