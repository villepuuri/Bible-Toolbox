import 'dart:convert';
import 'dart:io';

/*
* This file generates the .arb files based on the master_translations.json
*
* */

void main() async {
  final sourceFile = File('lib/l10n/master_translations.json');
  final jsonData = jsonDecode(await sourceFile.readAsString()) as Map<String, dynamic>;

  // Map from language → map of keys and translations
  final Map<String, Map<String, dynamic>> languages = {};

  for (final entry in jsonData.entries) {
    final key = entry.key;
    final translations = entry.value as Map<String, dynamic>;

    // Handle optional description
    final description = translations['description'];

    for (final langEntry in translations.entries) {
      final lang = langEntry.key;

      // Skip the "description" key when writing normal translations
      if (lang == 'description') continue;

      languages.putIfAbsent(lang, () => {});

      // Add the text
      languages[lang]![key] = langEntry.value;

      // If this is the English file, include the description metadata
      if (lang == 'en' && description != null) {
        languages[lang]!['@$key'] = {"description": description};
      }
    }
  }

  final outputDir = Directory('lib/l10n');
  if (!outputDir.existsSync()) outputDir.createSync();

  for (final lang in languages.keys) {
    final arbFile = File('${outputDir.path}/app_$lang.arb');
    final arbContent = const JsonEncoder.withIndent('  ').convert(languages[lang]);
    await arbFile.writeAsString(arbContent);
    print('✅ Generated ${arbFile.path}');
  }
}
