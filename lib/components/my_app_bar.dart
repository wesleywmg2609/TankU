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
          MyButton(
            onPressed: widget.onLeadingPressed ?? () => Navigator.pop(context),
            resetAfterPress: widget.isLeadingPressed != null ? false : true,
            isPressed: widget.isLeadingPressed ?? false,
            child: widget.leading ?? const MyIcon(icon: Icons.arrow_back),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyText(
                text: widget.title,
                isBold: true,
                letterSpacing: 2.0,
                size: widget.subtitle != null ? 12 : 20,
              ),
              if (widget.subtitle != null)
                MyText(
                  text: widget.subtitle!,
                  isBold: true,
                  letterSpacing: 2.0,
                  size: 20,
                ),
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
