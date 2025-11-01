import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late List<bool> selectedLanguages;

  @override
  void initState() {
    super.initState();
    debugPrint('\n*** In Welcome page ***');
    selectedLanguages = List.filled(LanguageHelper.languageCount, false);
  }

  @override
  Widget build(BuildContext context) {
    void changeSelection(int index, bool value) {
      selectedLanguages[index] = value;
      setState(() {});
    }

    List<Widget> languageBoxes = LanguageHelper.languages
        .asMap() // Use this so the index is accessed
        .entries
        .map((entry) {
          int index = entry.key;
          LanguageClass element = entry.value;
          return Card(
            key: ValueKey(element.abbreviation),
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            elevation: 1,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    element.displayName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    element.languagePacketSize,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              splashColor: Theme.of(context).colorScheme.primaryContainer,
              onTap: () {
                // Change the value if the box is pressed
                changeSelection(index, !selectedLanguages[index]);
              },
              trailing: Checkbox(
                value: selectedLanguages[index],

                onChanged: (bool? value) {
                  changeSelection(index, value ?? false);
                },
              ),
            ),
          );
        })
        .toList();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !selectedLanguages.contains(true)
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                debugPrint('The user wants to load the Following languages:');
                for (int i = 0; i < LanguageHelper.languageCount; i++) {
                  if (selectedLanguages[i]) {
                    debugPrint(' - ${LanguageHelper.languages[i]}');
                  }
                }
                // todo: implement loading the languages
                Navigator.pushReplacementNamed(context, '/home');
              },
              label: Row(
                children: [
                  Text(
                    "Lataa kielet",
                    style: Theme.of(context).textTheme.headlineMedium!.apply(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Icon(Icons.download_rounded),
                ],
              ),
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
        children:
            [
              Text(
                "Tervetuloa!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Valitse alta ladattavat kielet. Voit myöhemmin ladata lisää kieliä.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 70),
            ] +
            languageBoxes +
            [const SizedBox(height: 140)],
      ),
    );
  }
}
