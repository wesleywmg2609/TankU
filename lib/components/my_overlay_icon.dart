import 'package:flutter/material.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_svg_icon.dart';

class MyOverlayIcon extends StatelessWidget {
  final IconData icon;
  final String svgFilepath;
  final double? iconSize;
  final double? svgSize;
  final double? padding;

  const MyOverlayIcon({
    super.key,
    required this.icon,
    this.iconSize,
    required this.svgFilepath,
    this.svgSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
    alignment: Alignment.center,
    children: [
      MyIcon(icon: icon, size: iconSize ?? 24),
      IgnorePointer(
        child: Padding(
          padding: EdgeInsets.only(bottom: padding ?? 0),
          child: MySvgIcon(filepath: svgFilepath, color: Theme.of(context).colorScheme.surface , size: svgSize ?? 10)
        ),
      ),
    ],
  );
  }
}