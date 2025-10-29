import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/Widgets/main_drawer.dart';
import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget myTile(String title, String imageURL) => ListTile(
      leading: Image.asset(imageURL),
      splashColor: AppThemeData.opaqueGreen,
      minLeadingWidth: 50,
      title: Text(title),
      titleTextStyle: Theme.of(context).textTheme.labelLarge,
      onTap: () {
        debugPrint('Pressed a tile: $title');
      },
    );

    Column pageButtons = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
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

    return Scaffold(
      appBar: MainAppBar(title: "Hei!"),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Tervetuloa oppimaan Raamattua!",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              "Tämä sivusto on tarkoitettu avuksi kaikille, jotka etsivät elävää Jumalaa ja tarvitsevat apua uskonelämänsä rakentamiseen.\n\nNämä apuvälineet Raamatun opiskeluun tarjoaa sinulle Suomen luterilainen evankeliumiyhdistys SLEY, luterilainen lähetysjärjestö.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            pageButtons,
          ],
        ),
      ),
    );
  }
}
