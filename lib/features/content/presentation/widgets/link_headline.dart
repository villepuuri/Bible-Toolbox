import 'package:flutter/material.dart';


class LinkHeadline extends StatefulWidget {

  final String text;
  final VoidCallback? onTap;

  const LinkHeadline({super.key, required this.text, this.onTap});

  @override
  State<LinkHeadline> createState() => _LinkHeadlineState();
}

class _LinkHeadlineState extends State<LinkHeadline> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      child: TextButton(
        onPressed: widget.onTap,
        child: Text("> ${widget.text}"),
      ),
    );
  }
}
