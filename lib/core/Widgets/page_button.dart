import 'package:bible_toolbox/core/Widgets/simple_box.dart';
import 'package:bible_toolbox/core/constants.dart';
import 'package:flutter/material.dart';

class PageButton extends StatefulWidget {
  final String title;
  final String imagePath;
  final String path;

  const PageButton({
    super.key,
    required this.title,
    required this.imagePath,
    required this.path,
  });

  @override
  State<PageButton> createState() => _PageButtonState();
}

class _PageButtonState extends State<PageButton> {
  @override
  Widget build(BuildContext context) {
    String? findCorrectPath(String routeName) {
      // Find the correct link
      // todo: Fix this navigation
      for (String key in Constants.internalLinkConvert.keys) {
        if (Constants.internalLinkConvert[key]!.contains(routeName)) {
          debugPrint(' - Page to move: $key');
          return key;
        }
      }
      return null;
    }

    return SimpleBox(
      child: ListTile(
        leading: Image.asset('assets/btb_images/${widget.imagePath}.png'),
        minLeadingWidth: 50,
        title: Text(widget.title),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () {
          debugPrint('Pressed a tile: ${widget.title}');
          String? routeName = findCorrectPath(widget.path);
          if (routeName != null) {
            Navigator.pushNamed(context, routeName);
          }
        },
      ),
    );
  }
}
