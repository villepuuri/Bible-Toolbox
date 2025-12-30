import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/Widgets/main_drawer.dart';
import 'package:bible_toolbox/core/theme.dart';
import 'package:bible_toolbox/data/services/api_service.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';
import 'package:bible_toolbox/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/language_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tile widget to display the content tiles
    Widget myTile(String title, String imageURL, String routeName) => ListTile(
      leading: Image.asset(imageURL),
      minLeadingWidth: 50,
      title: Text(title),
      // titleTextStyle: Theme.of(context).textTheme.bodyMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      splashColor: AppThemeData.opaqueGreen,
      tileColor: AppThemeData.opaqueGreen,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(18))
      // ),
      onTap: () {
        debugPrint('Pressed a tile: $title');
        Navigator.pushNamed(context, routeName);
      },
    );

    Column pageButtons = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        myTile(
          "Vastauksia elämän suuriin kysymyksiin",
          'assets/btb_images/kysymysmerkki.png',
          '/answers',
        ),
        myTile(
          "Opetuksia Raamatusta teemoittain ja kirjoittain",
          'assets/btb_images/raamattu.png',
          '/bible',
        ),
        myTile(
          "Katekismus - Kristinusko pähkinänkuoressa",
          'assets/btb_images/katekismus.png',
          '/catechism',
        ),
        myTile(
          "Luterilaiset Tunnustuskirjat",
          'assets/btb_images/tunnustuskirjat.png',
          '/concord',
        ),
      ],
    );

    Widget questionButton = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Löydä vastauksia:",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        ElevatedButton(
          onPressed: () {
            debugPrint('QuestionButton pressed');
          },
          child: Text("Miten voin seurata Jeesusta?"),
        ),
      ],
    );

    Widget emptySpace = const SizedBox(height: 40);

    final lang = context.watch<LanguageProvider>();
    debugPrint('Current locale: ${lang.locale.languageCode}');

    return Scaffold(
      appBar: MainAppBar(title: AppLocalizations.of(context)!.titleHomePage),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          debugPrint('on pressed');

          for (LanguageClass language in LanguageHelper.loadedLanguages) {
            ApiService.updateDataForLanguage(language);
          }

          // for (LanguageClass language in LanguageHelper.languages) {
          //   if (await LanguageBoxService.hiveBoxExists(language.code)) {
          //     debugPrint('Deleting: $language');
          //     await LanguageBoxService.delete(language.code);
          //   }
          // }
          // await ApiService.getData([LanguageHelper.languages[8]]);
          // for (String code in BoxService.getInstalledLanguages()) {
          //   debugPrint('File size of $code: ${await BoxService.getHiveBoxSizeMB(code)}');
          // }
          // LanguageBoxService.delete("fi");
          // debugPrint(boxJsonData.getAt(0).toString());
          // print(BoxService.getInstalledLanguages());
          // print(BoxService.readMeta());
          // await BoxService.delete("en");
          // await BoxService.delete("fi");
          // debugPrint('deleted');
        },
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Welcome texts
            Text(
              "Tervetuloa oppimaan Raamattua!",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              "Tämä sivusto on tarkoitettu avuksi kaikille, jotka etsivät elävää Jumalaa ja tarvitsevat apua uskonelämänsä rakentamiseen.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            emptySpace,

            // Shortcut buttons
            pageButtons,
            emptySpace,

            // Question button
            questionButton,
            emptySpace,

            // The rest of the text
            Text(
              "Nämä apuvälineet Raamatun opiskeluun tarjoaa sinulle Suomen luterilainen evankeliumiyhdistys SLEY, luterilainen lähetysjärjestö.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            emptySpace,
          ],
        ),
      ),
    );
  }
}
