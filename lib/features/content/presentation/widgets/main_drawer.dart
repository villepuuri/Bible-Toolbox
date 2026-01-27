import 'package:bible_toolbox/core/constants.dart';
import 'package:bible_toolbox/core/services/result.dart';
import 'package:bible_toolbox/core/theme.dart';
import 'package:bible_toolbox/features/content/data/services/extract_key_information.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bible_toolbox/features/language/providers/language_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String languageCode = context.read<LanguageProvider>().locale.languageCode;

    Widget drawerListTile(
      String title, {
      String? imageURL,
      IconData? icon,
      String? routeName,
    }) => ListTile(
      leading: imageURL != null
          ? SizedBox(height: 40, child: Image.asset(imageURL))
          : Icon(icon!),
      minLeadingWidth: 34,
      title: Text(title),
      titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      splashColor: AppThemeData.opaqueGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      onTap: () {
        debugPrint('Pressed a tile: $title, $routeName)');
        if (routeName != null) {
          Navigator.pop(context);
          Navigator.pushNamed(context, routeName);
        }
        // todo: Think how the navigation should go
      },
    );

    Widget drawLine({double width = 1, double padding = 10}) => Divider(
      height: padding,
      thickness: width,
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
        contactBox(
          icon: Icons.facebook,
          onPressed: () async {
            debugPrint('Facebook pressed');
            String url = 'https://www.facebook.com/bibletoolbox';
            if (!(await launchUrl(Uri.parse(url)))) {
              debugPrint(' ~ Could not launch url: $url');
            }
          },
        ),
        const SizedBox(width: 10),
        contactBox(
          icon: Icons.email,
          onPressed: () async {
            debugPrint('Email pressed');
            String url = 'mailto:bibletoolbox@gmail.com';
            if (!(await launchUrl(Uri.parse(url)))) {
              debugPrint(' ~ Could not launch url: $url');
            }
          },
        ),
      ],
    );

    Result<Map<String, Map<String, dynamic>>> categoryResult = ExtractKeyInformation.getMainCategories(languageCode);
    Map<String, Map<String, dynamic>> categories = {};
    if (categoryResult.isOk) {
      categories = categoryResult.value;
    }

    return Drawer(
      backgroundColor: AppThemeData.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children:
              [
                SizedBox(height: kToolbarHeight),
                Image.asset('assets/btb_images/logo.png'),
                Spacer(),
              ] +
              // drawerListTile(
              //   "Etusivu",
              //   imageURL: "assets/btb_images/laatikko.png",
              //   routeName: '/home',
              // ),
              // drawLine(),
              categories.entries
                  .map(
                    (entry) => drawerListTile(
                      entry.value["group1"],
                      imageURL: "assets/btb_images/${entry.value["image"]}.png",
                      routeName: Constants.getPath(entry.value["path"]),
                    ),
                  )
                  .toList() +
              [
                drawLine(),
                drawerListTile(
                  AppLocalizations.of(context)!.titleLanguageSettings,
                  icon: Icons.language,
                  routeName: '/languages',
                ),
                drawerListTile(
                  AppLocalizations.of(context)!.titleBookmarks,
                  icon: Icons.bookmark,
                  routeName: '/bookmarks',
                ),
                Spacer(),
                drawLine(),
                drawerListTile(
                  "Keitä me olemme?",
                  imageURL: "assets/btb_images/ihmiset.png",
                  routeName: '/about',
                ),
                contactRow(),
              ],
        ),
      ),
    );
  }
}
