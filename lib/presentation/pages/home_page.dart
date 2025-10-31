import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/Widgets/main_drawer.dart';
import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    // Tile widget to display the content tiles
    Widget myTile(String title, String imageURL) => ListTile(
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
      },
    );

    Column pageButtons = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        myTile(
          "Vastauksia elämän suuriin kysymyksiin",
          'assets/btb_images/kysymysmerkki.png',
        ),
        myTile(
          "Opetuksia Raamatusta teemoittain ja kirjoittain",
          'assets/btb_images/raamattu.png',
        ),
        myTile(
          "Katekismus - Kristinusko pähkinänkuoressa",
          'assets/btb_images/katekismus.png',
        ),
        myTile(
          "Luterilaiset Tunnustuskirjat",
          'assets/btb_images/tunnustuskirjat.png',
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
        FilledButton(onPressed: () {
          debugPrint('QuestionButton pressed');
        }, child: Text((DateTime.now().second % 2 == 0) ? "Miten voin seurata Jeesusta?" : "Miten pääsisin kärryille siitä, minkälainen on Jumalan luonne?"),
        ),
      ],
    );

    Widget emptySpace = const SizedBox(height: 40,);

    return Scaffold(
      appBar: MainAppBar(title: "Hei!"),
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
            emptySpace
          ],
        ),
      ),
    );
  }
}
