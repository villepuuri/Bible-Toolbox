import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget{

  final String title;

  const MainAppBar({
    required this.title,
    super.key});

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      actions: [
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
          )));
  }

}
