import 'package:bible_toolbox/core/widgets/size_changing_widget.dart';
import 'package:flutter/material.dart';

/// Widget that displays the title of a Bible book and if it is pressed, it
/// shows the chapters in the book.
class BiblePageBookWidget extends StatefulWidget {
  final String chapterTitle;

  const BiblePageBookWidget({super.key, required this.chapterTitle});

  @override
  State<BiblePageBookWidget> createState() => _BiblePageBookWidgetState();
}

class _BiblePageBookWidgetState extends State<BiblePageBookWidget>
    with TickerProviderStateMixin {
  bool visible = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<String> testChapters = [
    'Tämä on vain testi',
    'Johdanto',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6-7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13-14',
    '15',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Row(
            children: [
              Icon(
                visible
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
              ),
              Expanded(child: Text(widget.chapterTitle)),
            ],
          ),
          onTap: () {
            visible = !visible;
            if (visible) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
            setState(() {});
          },
        ),
        const SizedBox(height: 4),

        SizeChangingWidget(
          controller: _controller,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: testChapters
                  .map<Widget>(
                    (chap) => OutlinedButton(
                      onPressed: () {
                        debugPrint('Pressed: $chap in ${widget.chapterTitle}');
                      },
                      child: Text(chap),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
