import 'package:flutter/material.dart';

class MyLoadingIndicator extends StatelessWidget {
  final Color? backgroundColor;
  final Color? progressColor;

  const MyLoadingIndicator({
    super.key,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final progress = progressColor ?? Theme.of(context).colorScheme.onSurface;

     return Stack(
      children: [
        ModalBarrier(
          color: bg,
          dismissible: false,
        ),
        Center(

            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(progress),
            ),
          ),
      ],
    );
  }
}
