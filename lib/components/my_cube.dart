import 'package:flutter/material.dart';

class MyCube extends StatelessWidget {
  final int width;
  final int depth;
  final int height;

  const MyCube({
    super.key,
    required this.width, 
    required this.depth, 
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 170),
      painter: CubePainter(
        context: context,
        width: width,
        depth: depth,
        height: height,
      ),
    );
  }
}

class CubePainter extends CustomPainter {
  final BuildContext context;
  final int width;
  final int depth;
  final int height;

  CubePainter({
    required this.context,
    required this.width,
    required this.depth,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).colorScheme.onSurface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final centerX = size.width / 2 - 30;
    final centerY = size.height / 2 + 18;

    if (width == depth && depth == height) {
      final frontTopLeft = Offset(centerX - 100 / 2, centerY - 100 / 2);
      final frontTopRight = Offset(centerX + 100 / 2, centerY - 100 / 2);
      final frontBottomLeft = Offset(centerX - 100 / 2, centerY + 100 / 2);
      final frontBottomRight = Offset(centerX + 100 / 2, centerY + 100 / 2);

      final backTopLeft = Offset(centerX - 100 / 2 + 100 / 2, centerY - 100 / 2 - 100 / 2);
      final backTopRight = Offset(centerX + 100 / 2 + 100 / 2, centerY - 100 / 2 - 100 / 2);
      final backBottomRight = Offset(centerX + 100 / 2 + 100 / 2, centerY + 100 / 2 - 100 / 2);

      canvas.drawLine(frontTopLeft, frontTopRight, paint);
      canvas.drawLine(frontTopRight, frontBottomRight, paint);
      canvas.drawLine(frontBottomRight, frontBottomLeft, paint);
      canvas.drawLine(frontBottomLeft, frontTopLeft, paint);

      canvas.drawLine(backTopLeft, backTopRight, paint);
      canvas.drawLine(backTopRight, backBottomRight, paint);

      canvas.drawLine(frontTopLeft, backTopLeft, paint);
      canvas.drawLine(frontTopRight, backTopRight, paint);
      canvas.drawLine(frontBottomRight, backBottomRight, paint);

      drawWidthCenteredText(canvas, width, frontBottomLeft.dx + ((frontBottomRight.dx - frontBottomLeft.dx) / 2), frontBottomLeft.dy + 2, Theme.of(context).colorScheme.onSurface, "Width");
      drawHeightCenteredText(canvas, depth, frontBottomRight.dx + ((backBottomRight.dx - frontBottomRight.dx) / 2) + 7, frontBottomRight.dy - ((frontBottomRight.dy - backBottomRight.dy) / 2), Theme.of(context).colorScheme.onSurface, "Depth");
      drawHeightCenteredText(canvas, height, backTopRight.dx + 2, backTopRight.dy + ((backBottomRight.dy - backTopRight.dy) / 2), Theme.of(context).colorScheme.onSurface, "Height");

    } else {
      const fixedWidth = 150.0;
      const fixedDepth = 100.0;
      const fixedHeight = 100.0;

      final frontTopLeft = Offset(centerX - fixedWidth / 2, centerY - fixedHeight / 2);
      final frontTopRight = Offset(centerX + fixedWidth / 2, centerY - fixedHeight / 2);
      final frontBottomLeft = Offset(centerX - fixedWidth / 2, centerY + fixedHeight / 2);
      final frontBottomRight = Offset(centerX + fixedWidth / 2, centerY + fixedHeight / 2);

      final backTopLeft = Offset(centerX - fixedWidth / 2 + fixedDepth / 2, centerY - fixedHeight / 2 - fixedDepth / 2);
      final backTopRight = Offset(centerX + fixedWidth / 2 + fixedDepth / 2, centerY - fixedHeight / 2 - fixedDepth / 2);
      final backBottomRight = Offset(centerX + fixedWidth / 2 + fixedDepth / 2, centerY + fixedHeight / 2 - fixedDepth / 2);

      canvas.drawLine(frontTopLeft, frontTopRight, paint);
      canvas.drawLine(frontTopRight, frontBottomRight, paint);
      canvas.drawLine(frontBottomRight, frontBottomLeft, paint);
      canvas.drawLine(frontBottomLeft, frontTopLeft, paint);

      canvas.drawLine(backTopLeft, backTopRight, paint);
      canvas.drawLine(backTopRight, backBottomRight, paint);

      canvas.drawLine(frontTopLeft, backTopLeft, paint);
      canvas.drawLine(frontTopRight, backTopRight, paint);
      canvas.drawLine(frontBottomRight, backBottomRight, paint);

      drawWidthCenteredText(canvas, width, frontBottomLeft.dx + ((frontBottomRight.dx - frontBottomLeft.dx) / 2), frontBottomLeft.dy + 2, Theme.of(context).colorScheme.onSurface, "Width");
      drawHeightCenteredText(canvas, depth, frontBottomRight.dx + ((backBottomRight.dx - frontBottomRight.dx) / 2) + 7, frontBottomRight.dy - ((frontBottomRight.dy - backBottomRight.dy) / 2), Theme.of(context).colorScheme.onSurface, "Depth");
      drawHeightCenteredText(canvas, height, backTopRight.dx + 2, backTopRight.dy + ((backBottomRight.dy - backTopRight.dy) / 2), Theme.of(context).colorScheme.onSurface, "Height");
    }
  }

  void drawHeightCenteredText(Canvas canvas, int value, double x, double y, Color color, String dimension) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: value == 0 ? dimension : value.toString(),
        style: TextStyle(color: color, fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offsetX = x;
    final offsetY = y - textPainter.height / 2;
    textPainter.paint(canvas, Offset(offsetX, offsetY));
  }

  void drawWidthCenteredText(Canvas canvas, int value, double x, double y, Color color, String dimension) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: value == 0 ? dimension : value.toString(),
        style: TextStyle(color: color, fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offsetX = x - textPainter.width / 2;
    final offsetY = y;
    textPainter.paint(canvas, Offset(offsetX, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
