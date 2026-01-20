import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/core/theme.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';
import 'package:bible_toolbox/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool useSmallAppBar;
  final bool showLanguageButton;
  final bool showBookmarkButton;

  const MainAppBar({
    required this.title,
    this.useSmallAppBar = false,
    this.showLanguageButton = true,
    this.showBookmarkButton = true,
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
    void onBookmarkPressed() async {
      if (BookmarkHelper.isPageBookmarked(widget.title)) {
        // The page is in bookmarks
        await BookmarkHelper.deleteBookmark(title: widget.title);
      } else {
        BookmarkHelper.addBookmark(
          LanguageHelper.getArticleByTitle(
            context.read<LanguageProvider>().locale.languageCode,
            widget.title,
          ),
        ); // todo: fix this path
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
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                tileColor:
                    language.code ==
                        context.read<LanguageProvider>().locale.languageCode
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
              AppLocalizations.of(context)!.titleLanguageSettings,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ]);
      return buttons;
    }

    return AppBar(
      title: AutoSizeText(
        widget.title,
        maxLines: widget.useSmallAppBar ? 2 : 1,
        minFontSize: 14,
        overflow: TextOverflow.ellipsis,
        style: widget.useSmallAppBar
            ? Theme.of(context).textTheme.titleSmall
            : Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      scrolledUnderElevation: 0,

      actions: [
        widget.useSmallAppBar && widget.showBookmarkButton
            ? IconButton(
                onPressed: onBookmarkPressed,
                icon: BookmarkHelper.isPageBookmarked(widget.title)
                    ? Icon(
                        Constants.iconSelectedBookmark,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : Icon(
                        Constants.iconAddBookmark,
                        color: Theme.of(context).colorScheme.outline,
                      ),
              )
            : const SizedBox(),
        widget.showLanguageButton
            ? PopupMenuButton(
                icon: Icon(Icons.language),
                itemBuilder: (BuildContext popUpContext) {
                  return getLanguageChangingButtons();
                },
                onSelected: (dynamic value) async {
                  debugPrint('User selected: $value');
                  if (value == "settings") {
                    // Open language page
                    Navigator.pushNamed(context, "/languages");
                  } else {
                    // Change language
                    await context.read<LanguageProvider>().changeLanguage(
                      LanguageHelper.languages
                          .firstWhere(
                            (LanguageClass l) => l.abbreviation == value,
                          )
                          .code,
                    );
                  }
                },
              )
            : const SizedBox(),
      ],
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
