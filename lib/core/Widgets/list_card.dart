import 'package:flutter/material.dart';

class ListCard extends StatefulWidget {
  final String title;
  final String? smallInfoText;
  final Widget? leading;
  final Widget? trailing;
  final Color? tileColor;
  final GestureTapCallback? onTap;

  const ListCard({
    super.key,
    required this.title,
    this.smallInfoText,
    this.leading,
    this.trailing,
    this.onTap,
    this.tileColor,
  });

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      key: widget.key,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      elevation: 1,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
            widget.smallInfoText != null ? Text(
              widget.smallInfoText!,
              style: Theme.of(context).textTheme.headlineSmall!.apply(fontSizeDelta: -4),
            ) : const SizedBox(),
          ],
        ),
        tileColor: widget.tileColor,
        splashColor: Theme.of(context).colorScheme.primaryContainer,
        onTap: widget.onTap,
        leading: widget.leading,
        trailing: widget.trailing,
      ),
    );
  }
}
