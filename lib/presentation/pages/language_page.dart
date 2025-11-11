import 'package:bible_toolbox/core/Widgets/list_card.dart';
import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:bible_toolbox/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  Widget loadedButton(LanguageClass language) {
    // todo: for some reason the menu with 2 widgets is extra wide
    bool isSelectedLanguage =
        language.abbreviation ==
        context.read<LanguageProvider>().locale.languageCode;
    return LanguageHelper.loadedLanguages.length > 1
        ? PopupMenuButton(
            itemBuilder: (menuContext) {
              return [
                if (!isSelectedLanguage)
                  PopupMenuItem(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    value: 1,
                    child: Row(
                      children: [
                        Text(
                          "Valitse",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  value: 2,
                  child: Row(
                    children: [
                      Text(
                        "Poista",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.delete_outline),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) {
              // if value 1 show dialog
              if (value == 1) {
                // Select this language
                context.read<LanguageProvider>().setLocale(language.code);
                setState(() {});
              }
              // if value 2 show dialog
              else if (value == 2) {
                if (LanguageHelper.loadedLanguages.length > 1) {
                  // Delete the downloaded language
                  debugPrint('Deleting the following language: $language');
                  LanguageHelper.removeLoadedLanguage(language);
                  setState(() {});
                } else {
                  // The user cannot delete the only language
                  assert(true, "User is trying to delete the only language");
                }
              }
            },
          )
        : const SizedBox();
  }

  Widget loadButton(LanguageClass language) {
    return IconButton(
      onPressed: () async {
        // todo: maybe add a dialog to ask if user wants to download?
        debugPrint('User wants to download: $language');
        await LanguageHelper.loadLanguage(language);
        setState(() {});
      },
      icon: Icon(Icons.download),
    );
  }

  Widget languageTile(LanguageClass language, {bool isLoaded = false}) {
    return ListCard(
      title: language.displayName,
      smallInfoText: language.languagePacketSize,
      onTap: () async {
        await context.read<LanguageProvider>().changeLanguage(language.code);
      },
      trailing: isLoaded ? loadedButton(language) : loadButton(language),
      tileColor:
          context.read<LanguageProvider>().locale.languageCode ==
              language.abbreviation
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: "Kieliasetukset",
        useSmallAppBar: true,
        showLanguageButton: false,
        showBookmarkButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Voit valita, mitkä kielet on ladattuna laitteelle. Huomioithan, että eri kielillä voi olla eri määrä materiaalia saatavilla.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "Ladatut kielet",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                return languageTile(
                  LanguageHelper.loadedLanguages[index],
                  isLoaded: true,
                );
              }, childCount: LanguageHelper.loadedLanguages.length),
            ),

            // The divider line
            // SliverToBoxAdapter(child: Divider(height: 50, thickness: 1)),
            SliverToBoxAdapter(child: SizedBox(height: 30)),

            // todo: What about if all languages have been downloaded? Should this be hidden?
            SliverToBoxAdapter(
              child: Text(
                "Ladattavat kielet",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                return languageTile(LanguageHelper.loadableLanguages[index]);
              }, childCount: LanguageHelper.loadableLanguages.length),
            ),
          ],
        ),
      ),
    );
  }
}
