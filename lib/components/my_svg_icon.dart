import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MySvgIcon extends StatelessWidget {
  final String filepath;
  final Color? color;
  final double? size;

  const MySvgIcon({
    super.key,
    required this.filepath,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      filepath,
      width: size ?? 50,
      height: size ?? 50,
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}