import 'package:flutter/material.dart';

import '../../core/constants.dart';

/// Turns raw markdown data from the Bible page to different links
class BiblePageList extends StatefulWidget {

  final String raw;

  const BiblePageList({super.key, required this.raw});

  @override
  State<BiblePageList> createState() => _BiblePageListState();
}

class _BiblePageListState extends State<BiblePageList> {

  List<Widget> extractData(String raw) {

  // Separate blocks (starting with ###)
  RegExp blockRE = RegExp(r'(###.*?)(?=(###)|(<!)|$)', dotAll: true);
  List<String?> blocks = blockRE
      .allMatches(raw)
      .map((match) => match.group(1))
      .toList();

  String codeBlock = "```${Constants.bibleListID}${Constants.blockSeparator}";
  int initialBlockSize0 = codeBlock.length;

  for (String? block in blocks) {
  if (block == null) continue;

  // Get the title of the block
  RegExp blockNameRE = RegExp(r'(?<=###)(.*?)(?=(\r\n)|$)');
  String? blockName = blockNameRE.firstMatch(block)?.group(1);

  debugPrint('\n\n - Block: $blockName');

  // Add the block separator
  if (codeBlock.length > initialBlockSize0)
  codeBlock += Constants.blockSeparator;
  codeBlock += '$blockName${Constants.blockSeparator}';

  int initialBlockSize1 = codeBlock.length;

  // If the block contains list of links
  if (block.contains('*   [')) {
  debugPrint('   * has a list of links');

  // Separate links (starting with '*   ')
  RegExp linkRE = RegExp(r'(\s*\*.*)', multiLine: true);
  List<String?> links = linkRE
      .allMatches(block)
      .map((match) => match.group(1))
      .toList();

  debugPrint('   * Links length: ${links.length}');

  for (String? link in links) {
  if (link == null) continue;

  // Get link url
  RegExp linkUrlRE = RegExp(r'\((.*?)\)');
  String? linkUrl = linkUrlRE.firstMatch(link)?.group(1);

  // Cut links and brackets away
  link = link
      .replaceAll(linkUrlRE, "")
      .replaceAll(RegExp(r'[\[\]]'), "");

  // Get link text
  RegExp linkTextRE = RegExp(r'\*\s*(.*?)\s*\\r\\n');
  String? linkText = linkTextRE.firstMatch(link)?.group(1);

  // debugPrint('LINK:--$link--');

  RegExp mainLinkRE = RegExp(r'(\n\*\s{3,})', dotAll: true);
  RegExp subLinkRE = RegExp(r'(\s\*\s)');

  int? linkType = link.contains(mainLinkRE)
  ? 1
      : (link.contains(subLinkRE) ? 2 : null);

  if (linkType == null) {
  debugPrint(' ~LINKTYPE NULL: $link');
  continue;
  }

  // If there is not a link, use the whole text as title
  linkText ??= link.replaceAll("*", '').trim();

  String linkRow =
  '$linkType${Constants.colSeparator}$linkText${Constants.colSeparator}$linkUrl';

  // debugPrint(
  //   '${linkType == 2 ? '   ' : ''}$linkRow',
  // );

  if (codeBlock.length > initialBlockSize1) {
  codeBlock += Constants.rowSeparator;
  }
  codeBlock += linkRow;
  }
  // Cut links from the block
  block = block.replaceAll(linkRE, "");
  }
  codeBlock += Constants.rowSeparator;
  // Cut block name from the block
  block = block.replaceAll(blockNameRE, "").replaceAll("###", "");

  // if (block.isNotEmpty) debugPrint('After links: $block');
  codeBlock += block;
  }
  codeBlock += "```";
  debugPrint('');
  // debugPrint(codeBlock.substring(codeBlock.length-300, codeBlock.length));
  // print(codeBlock);
  // final RegExp pattern = RegExp('.{1,800}');
  // pattern.allMatches(codeBlock).forEach((match) => print(match.group(0)));
  debugPrint('');

  return [];

}


  @override
  Widget build(BuildContext context) {
    return Text('moi');
  }
}
