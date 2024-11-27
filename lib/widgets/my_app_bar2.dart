import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tanku/widgets/my_button2.dart';

// ignore: must_be_immutable
class MyAppBar2 extends StatefulWidget {
  String title;
  String? subtitle;
  VoidCallback onTap;
  bool? isBackAllowed;
  //IconData leading

  MyAppBar2({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isBackAllowed = false,
  });

  @override
  State<MyAppBar2> createState() => _MyAppBar2State();
}

class _MyAppBar2State extends State<MyAppBar2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (widget.isBackAllowed!) ...[
                  MyButton2(
                      icon: Ionicons.chevron_back_circle_outline,
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                        });
                      },
                      size: 40,
                      ),
                  const SizedBox(width: 10)
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff282a29)),
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style: const TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 20,
                            color: Color(0xff282a29)),
                      ),
                  ],
                ),
              ],
            ),
            MyButton2(
                icon: Ionicons.add_circle_outline,
                onTap: widget.onTap,
                size: 40),
          ],
        ),
      ),
    );
  }
}
