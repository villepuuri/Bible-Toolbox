import 'package:bible_toolbox/core/services/result.dart';
import 'package:bible_toolbox/core/widgets/main_app_bar.dart';
import 'package:bible_toolbox/core/widgets/list_card.dart';
import 'package:bible_toolbox/l10n/app_localizations.dart';
import 'package:bible_toolbox/features/language/service/language_helper.dart';
import 'package:bible_toolbox/features/language/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../content/data/services/box_service.dart';
import '../../../core/widgets/loading_progress_widget.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  Map<String, String> loadedLanguageSizes = {};

  @override
  void initState() {
    super.initState();
    getLanguageSizes(useSetState: true);
  }

  Future<void> getLanguageSizes({bool useSetState = false}) async {
    for (LanguageClass language in LanguageHelper.loadedLanguages) {
      if (loadedLanguageSizes.containsKey(language.code)) {
        continue;
      }
      Result<String> sizeResult = await BoxService.getHiveBoxSizeMB(language.code);
      String? sizeString;
      if (sizeResult.isOk) sizeString = sizeResult.value;

      loadedLanguageSizes[language.code] = sizeString ?? '';
    }
    debugPrint(' - The sizes of loaded languages are: $loadedLanguageSizes');
    if (useSetState) {
      setState(() {});
    }
  }

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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.titleSelect,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.titleRemove,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.delete_outline),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              // if value 1 show dialog
              if (value == 1) {
                // Select this language
                await context.read<LanguageProvider>().changeLanguage(
                  language.code,
                );
              }
              // if value 2 show dialog
              else if (value == 2) {
                if (LanguageHelper.loadedLanguages.length > 1) {
                  // Delete the downloaded language
                  debugPrint('Deleting the following language: $language');
                  await LanguageHelper.removeLoadedLanguage(
                    language,
                    context,
                    updateParent: () {
                      setState(() {});
                    },
                  );
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
        if (!language.isLoading) {
          debugPrint('User wants to download: $language');
          setState(() {
            language.setLoadingState(true);
          });
          await LanguageHelper.loadLanguage(
            language,
            updateParent: () {
              setState(() {});
            },
          );
          await getLanguageSizes();
          setState(() {
            language.setLoadingState(false);
          });
        }
      },
      icon: !language.isLoading
          ? Icon(Icons.download)
          : LoadingProgressWidget(loadingValue: language.loadingValue),
    );
  }

  Widget languageTile(LanguageClass language, {bool isLoaded = false}) {
    return ListCard(
      title: language.fullName,
      smallInfoText:
          loadedLanguageSizes[language.code] ?? language.languagePacketSize,
      onTap: () async {
        if (isLoaded) {
          await context.read<LanguageProvider>().changeLanguage(language.code);
        }
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
        title: AppLocalizations.of(context)!.titleLanguageSettings,
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
                  AppLocalizations.of(context)!.textLanguageSettings,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                AppLocalizations.of(context)!.titleLoadedLanguages,
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
                AppLocalizations.of(context)!.titleUnloadedLanguages,
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
            SliverToBoxAdapter(child: const SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
