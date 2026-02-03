import 'package:flutter/material.dart';


class SizeChangingWidget extends StatefulWidget {
  final Widget child;
  final AnimationController controller;

  const SizeChangingWidget({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<SizeChangingWidget> createState() => _SizeChangingWidgetState();
}

class _SizeChangingWidgetState extends State<SizeChangingWidget> {
  late final Animation<double> _animation = CurvedAnimation(
    parent: widget.controller,
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizeTransition(
        sizeFactor: _animation,
        axisAlignment: -1,
        child: widget.child,
      ),
    );
  }
}