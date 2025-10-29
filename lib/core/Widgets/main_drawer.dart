import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppThemeData.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight,),
            Image.asset('assets/btb_images/logo.png')

          ],
        ),
      ),
    );
  }
}
