import 'package:flutter/material.dart';

class LoadingProgressWidget extends StatefulWidget {
  final double loadingValue;
  final double size;


  const LoadingProgressWidget({super.key, required this.loadingValue, this.size = 30});

  @override
  State<LoadingProgressWidget> createState() => _LoadingProgressWidgetState();
}

class _LoadingProgressWidgetState extends State<LoadingProgressWidget> {

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: widget.loadingValue),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return CircularProgressIndicator(
          constraints: BoxConstraints(
            minHeight: widget.size,
            minWidth: widget.size,
          ),
          value: value,
          backgroundColor: Colors.black12,
        );
      },
    );
  }

}
