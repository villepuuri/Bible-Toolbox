import 'package:bible_toolbox/core/theme.dart';
import 'package:flutter/material.dart';

class SimpleBox extends StatefulWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;

  const SimpleBox({super.key, required this.child, EdgeInsetsGeometry? padding})
   : padding = padding ?? const EdgeInsets.symmetric(horizontal: 4);

  @override
  State<SimpleBox> createState() => _SimpleBoxState();
}

class _SimpleBoxState extends State<SimpleBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: AppThemeData.lightGreen),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            offset: Offset(-4, 2),
            color: AppThemeData.shadowBlack,
            blurRadius: 2,
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
