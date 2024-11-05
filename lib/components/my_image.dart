import 'package:flutter/material.dart';
import 'package:tankyou/components/my_overlay_icon.dart';
import 'package:tankyou/models/tank.dart';


// ignore: must_be_immutable
class MyImageLoader extends StatefulWidget {
  Tank tank;
  double size;

  MyImageLoader({
    super.key,
    required this.tank,
    required this.size,
  });

  @override
  State<MyImageLoader> createState() => _MyImageLoaderState();
}

class _MyImageLoaderState extends State<MyImageLoader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
    width: widget.size,
    height: widget.size,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        (widget.tank.imageUrl != null && widget.tank.imageUrl!.isNotEmpty)
            ? widget.tank.imageUrl.toString()
            : '',
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const MyOverlayIcon(
            icon:  Icons.call_to_action, svgFilepath: 'assets/fish.svg', iconSize: 48, svgSize: 20, padding: 3),
      ),
    ),
  );
  }
}