import 'package:bible_toolbox/core/helpers/bookmark.dart';
import 'package:bible_toolbox/core/helpers/boxes.dart';
import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool useSmallAppBar;

  const MainAppBar({
    required this.title,
    this.useSmallAppBar = false,
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
        Bookmark bookmark = boxBookmarks.values.firstWhere((b) => b.name == widget.title);
        boxBookmarks.delete(bookmark.id);
      } else {
        debugPrint('Page: ${widget.title} is to be set as a bookmark');
        Bookmark bookmark = Bookmark(
          name: widget.title,
          path: "Etusivu/Raamattu/${widget.title}", // todo: fix this path
        );
        boxBookmarks.put(bookmark.id, bookmark);
      }
    }

    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      scrolledUnderElevation: 0,
      actions: [
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
        IconButton(
          onPressed: () {
            debugPrint('Pressed "Change language"');
          },
          icon: Icon(Icons.language),
        ),
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
