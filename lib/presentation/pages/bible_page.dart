import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/data/services/api_service.dart';
import 'package:bible_toolbox/data/widgets/api_text_widget.dart';
import 'package:flutter/material.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  String body = "";

  @override
  void initState() {
    super.initState();
    _loadData(); // <- start async work here
  }


  Future<void> _loadData() async {
    String result = await ApiService.fetchData();

    // Change the possible HTML link to markdown
    int htmlIndex = result.indexOf("<hr>"); // todo: maybe change this
    if (htmlIndex != -1) {
      String htmlLink = result.substring(0,htmlIndex);

      // Regular Expression to detect the link items
      final linkRegex = RegExp(
        r'<a\s+href="([^"]+)"[^>]*>(.*?)<\/a>',
        caseSensitive: false,
      );

      // Changing the html link to markdown link
      String mdLink = htmlLink.replaceAllMapped(linkRegex, (match) {
        final url = match.group(1)!;
        final text = match.group(2)!;
        return '[$text]($url)';
      });

      result = "$mdLink\n---\n${result.substring(htmlIndex+4)}";
    }

    // Remove opening <FONT ...> and closing </FONT>
    // Case insensitive, also handles attributes
    final fontRegex = RegExp(r'<\s*FONT[^>]*>', caseSensitive: false);
    final fontCloseRegex = RegExp(r'<\s*/\s*FONT\s*>', caseSensitive: false);
    result = result.replaceAll(fontRegex, '');     // remove opening tag
    result = result.replaceAll(fontCloseRegex, '');  // remove closing tag

    // Fix the bolded text
    result = result.replaceAll('<b>', '**').replaceAll('</b>', '**');

    // Try to fix the line brakes in the quote block
    final regex = RegExp(
      r'\r\n>([\s\S]*?)\r\n\r\n',
      multiLine: true,
    );
    result = result.replaceAllMapped(regex, (match) {
      final full = match.group(0)!;       // whole matched quote block
      final inner = match.group(1)!;      // text inside the block (after '>')
      // Replace CRLF inside the block
      final convertedInner = inner.replaceAll('\r\n', '<br>');
      // Rebuild the block with replaced linebreaks
      return '\r\n>$convertedInner\r\n\r\n';
    });

    if (!mounted) return;
    setState(() {
      body = result;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MainAppBar(title: "Raamattu"),
      body: ApiTextWidget(body: body),
    );
  }
}
