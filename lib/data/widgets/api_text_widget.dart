import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class ApiTextWidget extends StatefulWidget {
  /// Body text in markdown format
  final String body;

  const ApiTextWidget({super.key, required this.body});

  @override
  State<ApiTextWidget> createState() => _ApiTextWidgetState();
}

class _ApiTextWidgetState extends State<ApiTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: widget.body,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      builders: {
        // Custom builder for blockquotes
        'blockquote': BlockquoteElementBuilder(),
      },
      styleSheet: MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyMedium,
        h1: Theme.of(context).textTheme.headlineLarge,
        h1Padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
        a: Theme.of(context).textTheme.labelMedium,
        blockquote: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
        blockquoteDecoration: BoxDecoration(),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
            bottom: BorderSide(width: 15, color: Colors.transparent),
          ),
        ),
      ),
      onTapLink: (title, url, _) {
        debugPrint('User wants to open: $url');
      },
    );
  }
}

/// Build the blockQuote element for displaying the quoteBlock properly
class BlockquoteElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(var element, TextStyle? preferredStyle) {
    // element.textContent is the text inside the blockquote
    String text = element.textContent;

    // Fix the line brake marks set previously
    text = text.replaceAll("<br>", "\n");

    debugPrint(text);

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote_rounded,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style:
                      (preferredStyle ??
                              Theme.of(context).textTheme.bodyMedium!)
                          .copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
