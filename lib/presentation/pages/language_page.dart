import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/helpers/language_helper.dart';
import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  Widget loadedButton(LanguageClass language) {
    // todo: for some reason the menu with 2 widgets is extra wide
    bool isSelectedLanguage =
        language.abbreviation == LanguageHelper.selectedLanguage.abbreviation;
    return LanguageHelper.loadedLanguages.length > 1 ? PopupMenuButton(
      itemBuilder: (menuContext) {
        return [
          if (!isSelectedLanguage)
            PopupMenuItem(
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
            value: 2,
            child: Row(
              children: [
                Text("Poista", style: Theme.of(context).textTheme.bodyMedium),
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
          LanguageHelper.setUsedLanguage(language);
          setState(() {});
        }
        // if value 2 show dialog
        else if (value == 2) {
          if (LanguageHelper.loadedLanguages.length > 1) {
            // Delete the downloaded language
            debugPrint('Deleting the following language: $language');
            LanguageHelper.removeLoadedLanguage(language);
            setState(() {});
          }
          else {
            // The user cannot delete the only language
            assert(true, "User is trying to delete the only language");
          }
        }
      },
    ) : const SizedBox();
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
    return Card(
      key: ValueKey(language.abbreviation),
      margin: const EdgeInsets.symmetric(vertical: 0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      elevation: 1,
      child: ListTile(
        title: Text(language.displayName),
        trailing: isLoaded ? loadedButton(language) : loadButton(language),
        // splashColor: AppThemeData.opaqueGreen,
        tileColor:
            LanguageHelper.selectedLanguage.abbreviation ==
                language.abbreviation
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: "Kieliasetukset",
        useSmallAppBar: true,
        showActionButtons: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          slivers: [
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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: languageTile(
                    LanguageHelper.loadedLanguages[index],
                    isLoaded: true,
                  ),
                );
              }, childCount: LanguageHelper.loadedLanguages.length),
            ),

            // The divider line
            // SliverToBoxAdapter(child: Divider(height: 50, thickness: 1)),
            SliverToBoxAdapter(child: SizedBox(height: 30,)),

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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: languageTile(LanguageHelper.loadableLanguages[index]),
                );
              }, childCount: LanguageHelper.loadableLanguages.length),
            ),
          ],
        ),
      ),
    );
  }
}
