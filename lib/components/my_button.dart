import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:tanku/components/my_box_shadow.dart';

// ignore: must_be_immutable
class MyButton extends StatefulWidget {
  final Widget child;
  final dynamic Function() onPressed;
  final bool resetAfterPress;
  bool isPressed;
  final EdgeInsets padding;

  MyButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.resetAfterPress = true,
    this.isPressed = false,
    this.padding = const EdgeInsets.all(15),
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  void _onTap() async {
    FocusScope.of(context).unfocus();
    setState(() {
      widget.isPressed = !widget.isPressed;
    });

    if (widget.resetAfterPress) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        widget.isPressed = !widget.isPressed;
      });
    }
    widget.onPressed.call();
  }

  @override
  Widget build(BuildContext context) {
    MyBoxShadows shadows = MyBoxShadows();

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: widget.isPressed ? const Duration(milliseconds: 100) : const Duration(milliseconds: 200),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: widget.isPressed
              ? [
                  shadows.darkShadowPressed(context),
                  shadows.lightShadowPressed(context),
                ]
              : [
                  shadows.darkShadow(context),
                  shadows.lightShadow(context),
                ],
        ),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
