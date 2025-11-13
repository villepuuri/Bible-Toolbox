import 'package:bible_toolbox/core/Widgets/list_card.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';
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
          return ListCard(
            key: ValueKey(element.abbreviation),
            title: element.fullName,
            smallInfoText: element.languagePacketSize,
            trailing: Checkbox(
              value: selectedLanguages[index],
              onChanged: (bool? value) {
                changeSelection(index, value ?? false);
              },
            ),
            onTap: () {
              // Change the value if the box is pressed
              changeSelection(index, !selectedLanguages[index]);
            },
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
                    LanguageHelper.testLoadedLanguages.add(
                      LanguageHelper.languages[i],
                    );
                  }
                }
                // todo: implement loading the languages
                Navigator.pushReplacementNamed(context, '/home');
              },
              label: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.titleLoadLanguages,
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
                AppLocalizations.of(context)!.titleWelcome,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.textWelcome,
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
