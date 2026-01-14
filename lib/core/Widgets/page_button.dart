import 'package:bible_toolbox/core/constants.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

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
      for (String key in Constants.internalLinkConvert.keys) {
        if (Constants.internalLinkConvert[key]!.contains(routeName)) {
          debugPrint(' - Page to move: $key');
          return key;
        }
      }
      return null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: AppThemeData.lightGreen),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            offset: Offset(-4, 2),
            color: AppThemeData.shadowBlack,
            blurRadius: 2,
          ),
        ],
      ),
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
