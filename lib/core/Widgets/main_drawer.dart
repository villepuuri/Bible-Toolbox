import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget drawerListTile(String title, {String? imageURL, IconData? icon, String? routeName}) =>
        ListTile(
          leading: imageURL != null
              ? SizedBox(height: 40, child: Image.asset(imageURL))
              : Icon(icon!),
          minLeadingWidth: 34,
          title: Text(title),
          titleTextStyle: Theme.of(context).textTheme.headlineMedium,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          splashColor: AppThemeData.opaqueGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          onTap: () {
            debugPrint('Pressed a tile: $title');
            if (routeName != null){
              Navigator.pop(context);
              Navigator.pushNamed(context, routeName);
            }
            // todo: Think how the navigation should go
          },
        );

    Widget drawLine({double width = 1, double padding = 10}) => Container(
      height: width,
      margin: EdgeInsets.symmetric(vertical: padding),
      color: Theme.of(context).primaryColor,
    );

    Widget contactBox({
      required VoidCallback onPressed,
      IconData? icon,
      String? imageURL,
    }) => IconButton(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : Image.asset(imageURL!),
    );

    Widget contactRow() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        contactBox(icon: Icons.facebook, onPressed: () {
          debugPrint('Facebook pressed');
        }),
        contactBox(icon: Icons.email, onPressed: () {
          debugPrint('Email pressed');
        }),
        contactBox(icon: Icons.people, onPressed: () {
          debugPrint('People pressed');
        }),

      ],
    );

    return Drawer(
      backgroundColor: AppThemeData.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            Image.asset('assets/btb_images/logo.png'),
            Spacer(),
            drawerListTile(
              "Etusivu",
              imageURL: "assets/btb_images/laatikko.png",
              routeName: '/home'
            ),
            drawLine(),
            drawerListTile(
              "Vastaukset",
              imageURL: "assets/btb_images/kysymysmerkki.png",
              routeName: '/answers'
            ),
            drawerListTile(
              "Raamattu",
              imageURL: "assets/btb_images/raamattu.png",
            ),
            drawerListTile(
              "Katekismus",
              imageURL: "assets/btb_images/katekismus.png",
            ),
            drawerListTile(
              "Tunnustuskirjat",
              imageURL: "assets/btb_images/tunnustuskirjat.png",
            ),
            drawLine(),
            drawerListTile("Ladatut kielet", icon: Icons.language),
            drawerListTile("Kirjanmerkit", icon: Icons.bookmark),
            Spacer(),
            drawLine(),
            drawerListTile(
              "Keitä me olemme?",
              imageURL: "assets/btb_images/ihmiset.png",
            ),
            contactRow(),
          ],
        ),
      ),
    );
  }
}
