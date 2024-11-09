import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tanku/components/my_overlay_icon.dart';

// ignore: must_be_immutable
class MyImageLoader extends StatelessWidget {
  final File? file;
  final String? url;
  final double size;

  const MyImageLoader({
    super.key,
    required this.size,
    this.file,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: file != null
            ? Image.file(
                file!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const MyOverlayIcon(
                  icon: Icons.call_to_action,
                  svgFilepath: 'assets/fish.svg',
                  iconSize: 48,
                  svgSize: 20,
                  padding: 3,
                ),
              )
            : url != null && url!.isNotEmpty
                ? Image.network(
                    url!,
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
                      icon: Icons.call_to_action,
                      svgFilepath: 'assets/fish.svg',
                      iconSize: 48,
                      svgSize: 20,
                      padding: 3,
                    ),
                  )
                : const MyOverlayIcon(
                    icon: Icons.call_to_action,
                    svgFilepath: 'assets/fish.svg',
                    iconSize: 48,
                    svgSize: 20,
                    padding: 3,
                  ),
      ),
    );
  }
}
