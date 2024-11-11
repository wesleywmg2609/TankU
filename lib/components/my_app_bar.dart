import 'package:flutter/material.dart';
import 'package:tanku/components/my_button.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_text.dart';

// ignore: must_be_immutable
class MyAppBar extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final dynamic Function()? onLeadingPressed;
  final bool? isLeadingPressed;
  final Widget? trailing;
  final dynamic Function()? onTrailingPressed;
  final bool? isTrailingPressed;

  const MyAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onLeadingPressed,
    this.isLeadingPressed,
    this.trailing,
    this.onTrailingPressed,
    this.isTrailingPressed,
  });

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.leading != null &&
              widget.onLeadingPressed != null &&
              widget.isLeadingPressed != null)
            MyButton(
              onPressed: widget.onLeadingPressed!,
              resetAfterPress: false,
              isPressed: widget.isLeadingPressed!,
              child: widget.leading!,
            )
          else if (widget.leading != null && widget.onLeadingPressed != null)
            MyButton(
              onPressed: widget.onLeadingPressed!,
              resetAfterPress: true,
              child: widget.leading!,
            )
          else
            MyButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const MyIcon(icon: Icons.arrow_back),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.subtitle != null) ...[
                MyText(
                  text: widget.title,
                  isBold: true,
                  letterSpacing: 2.0,
                  size: 12,
                ),
                MyText(
                  text: widget.subtitle!,
                  isBold: true,
                  letterSpacing: 2.0,
                  size: 20,
                ),
              ] else ...[
                MyText(
                  text: widget.title,
                  isBold: true,
                  letterSpacing: 2.0,
                  size: 20,
                ),
              ],
            ],
          ),
          if (widget.trailing != null)
            MyButton(
              onPressed: widget.onTrailingPressed!,
              child: widget.trailing!,
            )
          else
            const SizedBox(width: 54, height: 54)
        ],
      ),
    );
  }
}
