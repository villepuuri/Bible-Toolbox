import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:bible_toolbox/core/helpers/boxes.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool useSmallAppBar;
  final bool showActionButtons;

  const MainAppBar({
    required this.title,
    this.useSmallAppBar = false,
    this.showActionButtons = true,
    super.key,
  });

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    void onBookmarkPressed() {
      // todo: fix this expression
      if (boxBookmarks.values.any((b) => b.name == widget.title)) {
        // The page is in bookmarks
        debugPrint('Page: ${widget.title} is to be removed from bookmarks');
        Bookmark bookmark = boxBookmarks.values.firstWhere(
          (b) => b.name == widget.title,
        );
        boxBookmarks.delete(bookmark.id);
      } else {
        debugPrint('Page: ${widget.title} is to be set as a bookmark');
        Bookmark bookmark = Bookmark(
          name: widget.title,
          path: "Etusivu/Raamattu/${widget.title}", // todo: fix this path
        );
        boxBookmarks.put(bookmark.id, bookmark);
      }
      setState(() {});
    }

    List<PopupMenuEntry> getLanguageChangingButtons() {
      List<PopupMenuEntry> buttons = LanguageHelper.loadedLanguages
          .map<PopupMenuEntry<dynamic>>(
            (language) => PopupMenuItem(
              enabled: true,
              // todo: disable when the page is not available
              key: ValueKey(language.abbreviation),
              value: language.abbreviation,
              padding: EdgeInsets.all(0),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                title: Text(
                  language.displayName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                tileColor: language == LanguageHelper.selectedLanguage
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surface,
              ),
            ),
          )
          .toList();
      // Add the possibility to move to downloading more languages
      buttons.addAll([
        PopupMenuDivider(indent: 4, endIndent: 4),
        PopupMenuItem(
          value: "settings",
          child: ListTile(
            title: Text(
              "Kieliasetukset",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ]);
      return buttons;
    }

    return AppBar(
      title: Text(
        widget.title,
        maxLines: 3, // Todo: Can all the texts fit here?
        style: widget.useSmallAppBar
            ? Theme.of(context).textTheme.titleSmall
            : Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      scrolledUnderElevation: 0,

      actions: widget.showActionButtons
          ? [
              widget.useSmallAppBar
                  ? IconButton(
                      onPressed: onBookmarkPressed,
                      icon: Icon(
                        // todo: fix this expression
                        (boxBookmarks.values.any((b) => b.name == widget.title))
                            ? Icons.bookmark
                            : Icons.bookmark_add_outlined,
                      ),
                    )
                  : const SizedBox(),
              PopupMenuButton(
                icon: Icon(Icons.language),
                itemBuilder: (BuildContext popUpContext) {
                  return getLanguageChangingButtons();
                },
                onSelected: (dynamic value) {
                  debugPrint('User selected: $value');
                  if (value == "settings") {
                    // Open language page
                    Navigator.pushNamed(context, "/languages");
                  } else {
                    // Change language
                    LanguageHelper.setUsedLanguage(
                      LanguageHelper.languages.firstWhere(
                        (LanguageClass l) => l.abbreviation == value,
                        orElse: () {
                          // todo: set an error
                          return LanguageHelper.selectedLanguage;
                        },
                      ),
                    );
                    setState(() {});
                  }
                },
              ),
            ]
          : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          color: AppThemeData.lightGreen,
          height: 2.0,
        ),
      ),
    );
  }
}
