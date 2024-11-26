import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton2 extends StatefulWidget {
  IconData icon;
  IconData? iconPressed;
  String? labelText;
  bool isPressed;
  VoidCallback onTap;
  double? size;

  MyButton2({
    super.key,
    required this.icon,
    this.iconPressed,
    this.labelText,
    this.isPressed = false,
    required this.onTap,
    this.size = 30,
  });

  @override
  State<MyButton2> createState() => _MyButton2State();
}

class _MyButton2State extends State<MyButton2> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.iconPressed == null) {
          setState(() => widget.isPressed = !widget.isPressed);
        }
        widget.onTap();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Icon(
                widget.iconPressed != null
                    ? (widget.isPressed ? widget.iconPressed : widget.icon)
                    : widget.icon,
                key: ValueKey(widget.isPressed),
                color: const Color(0xff282a29),
                size: widget.size,
              ),
            ),
            if (widget.labelText != null) ...[
              const SizedBox(height: 2),
              Text(
                widget.labelText!,
                style: const TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff282a29),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
