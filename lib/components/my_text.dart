import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isBold;
  final double? letterSpacing;
  final double? size;

  const MyText({
    super.key,
    required this.text,
    this.color,
    this.isBold = false,
    this.letterSpacing,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'SFPro',
        color: color ?? Theme.of(context).colorScheme.onSurface,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        letterSpacing: letterSpacing ?? 0.0,
        fontSize: size ?? 12,
      ),
    );
  }
}