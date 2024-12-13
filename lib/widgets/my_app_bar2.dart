import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tanku/widgets/my_button2.dart';

// ignore: must_be_immutable
class MyAppBar2 extends StatefulWidget {
  String title;
  String? subtitle;
  IconData icon;
  VoidCallback onTap;
  bool? isBackAllowed;
  Color? previousNavBarColor;

  MyAppBar2({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.isBackAllowed = false,
    this.previousNavBarColor,
  });

  @override
  State<MyAppBar2> createState() => _MyAppBar2State();
}

class _MyAppBar2State extends State<MyAppBar2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.orange,
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
                        SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle(
                          systemNavigationBarColor: widget.previousNavBarColor ?? Theme.of(context).colorScheme.surface,
                          systemNavigationBarIconBrightness: Brightness.dark,
                        ));
                        Navigator.pop(context);
                      });
                    },
                    size: 40,
                  ),
                  const SizedBox(width: 20)
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                  ],
                ),
              ],
            ),
            MyButton2(icon: widget.icon, onTap: widget.onTap, size: 40),
          ],
        ),
      ),
    );
  }
}
