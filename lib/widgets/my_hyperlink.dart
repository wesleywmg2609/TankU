import 'package:flutter/material.dart';
import 'package:tanku/widgets/my_text.dart';

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
      child: MyText(
        text: text,
        letterSpacing: 2.0,
      ),
    );
  }
}
