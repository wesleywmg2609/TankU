import 'package:flutter/material.dart';
import 'package:tanku/widgets/my_button2.dart';

class MyNavBar2 extends StatefulWidget {
  final List<MyButton2> buttons;

  const MyNavBar2({
    super.key,
    required this.buttons,
  });

  @override
  State<MyNavBar2> createState() => _MyNavBar2State();
}

class _MyNavBar2State extends State<MyNavBar2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.buttons.map((button) {
          return Expanded(child: button);
        }).toList(),
      ),
    );
  }
}
