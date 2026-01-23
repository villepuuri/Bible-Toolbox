import 'package:bible_toolbox/core/widgets/list_card.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bible_toolbox/features/language/providers/language_provider.dart';
import '../../../core/services/box_service.dart';
import '../../../core/services/internet_connection.dart';
import '../../../core/widgets/loading_progress_widget.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late List<bool> selectedLanguages;
  bool isLoadingLanguages = false;

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
            trailing: SizedBox(
              width: 30,
              child: !element.isLoading
                  ? (!LanguageHelper.loadedLanguages.contains(element)
                        ? Checkbox(
                            value: selectedLanguages[index],
                            onChanged: (bool? value) {
                              changeSelection(index, value ?? false);
                            },
                          )
                        : Icon(Icons.check_circle))
                  : LoadingProgressWidget(loadingValue: element.loadingValue),
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
              onPressed: () async {
                // Check that is the button already pressed
                if (!isLoadingLanguages) {
                  if (!(await InternetConnection.isConnected)) {
                    debugPrint('No internet connection!');
                    // todo: Create an error message
                    return;
                  }

                  // Update the state of the loading flag
                  isLoadingLanguages = true;
                  setState(() {});

                  debugPrint('The user wants to load the Following languages:');
                  for (int i = 0; i < LanguageHelper.languageCount; i++) {
                    if (selectedLanguages[i]) {
                      setState(() {
                        LanguageHelper.languages[i].setLoadingState(true);
                      });
                      await LanguageHelper.loadLanguage(
                        LanguageHelper.languages[i],
                        updateParent: () {
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      );
                      setState(() {
                        LanguageHelper.languages[i].setLoadingState(false);
                      });
                    }
                  }
                  // todo: What if the user does not choose the default language?

                  // If the default language has not been selected, select the first selected language
                  if (!LanguageHelper.loadedLanguages.any(
                    (l) =>
                        l.code ==
                        context.read<LanguageProvider>().locale.languageCode,
                  )) {
                    if (context.mounted) {
                      debugPrint(
                        'The default language is not selected, selecting ${LanguageHelper.loadedLanguages.first}',
                      );
                      await context.read<LanguageProvider>().changeLanguage(
                        LanguageHelper.loadedLanguages.first.code,
                      );
                    }
                  } else {
                    // Default language selected, opening the box
                    if (context.mounted) {
                      await BoxService.open(
                        // todo: test that the opening works!
                        context.read<LanguageProvider>().locale.languageCode,
                      );
                    }
                  }

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                }
              },
              label: !isLoadingLanguages
                  ? Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.titleLoadLanguages,
                          style: Theme.of(context).textTheme.headlineMedium!
                              .apply(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                        ),
                        const SizedBox(width: 15),

                        Icon(Icons.download_rounded),
                      ],
                    )
                  : Text(
                      "(${LanguageHelper.loadedLanguages.length}/${selectedLanguages.where((e) => e).length})",
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            color: Theme.of(context).colorScheme.surface,
                          ),
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
