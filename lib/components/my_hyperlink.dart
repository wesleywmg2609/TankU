import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyHyperlink extends StatelessWidget {
  String text;
  VoidCallback onTap;

  MyHyperlink({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: 1.0,
          fontFamily: 'SFPro',
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
