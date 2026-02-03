import 'package:bible_toolbox/core/widgets/size_changing_widget.dart';
import 'package:flutter/material.dart';

class ExtendableHeadline extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final GestureTapCallback? onTap;

  const ExtendableHeadline({
    super.key,
    required this.title,
    required this.children,
    this.onTap
  });

  @override
  State<ExtendableHeadline> createState() => _ExtendableHeadlineState();
}

class _ExtendableHeadlineState extends State<ExtendableHeadline>
    with TickerProviderStateMixin {
  bool isOpen = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeState() {
    /*
    * Change the visibility/state/height of the child widget
    * */
    isOpen = !isOpen;
    if (isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* The Headline */
          InkWell(
            onTap: widget.onTap ?? changeState,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: IconButton(
                    onPressed: changeState,
                    padding: const EdgeInsets.all(1),
                    constraints: BoxConstraints(),
                    icon: Image.asset(
                      isOpen
                          ? 'assets/btb_images/miinus.png'
                          : 'assets/btb_images/plussa.png',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          /* The widget opened after a tap */
          SizeChangingWidget(
            controller: _controller,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ),

          /* The divider line */
          Divider(thickness: isOpen ? 2 : 1),

        ],
      ),
    );
  }
}


