import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("3D Cube with Width, Depth, Height"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
          child: CustomPaint(
            size: Size(300, 300),
            painter: CubePainter(),
          ),
        ),
      ),
    );
  }
}

class CubePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 66, 66, 66)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Calculate center
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Cube dimensions
    final cubeSize = 60.0;

    // Define points for the cube in 3D space
    // Front face of the cube
    final frontTopLeft = Offset(centerX - cubeSize, centerY - cubeSize / 2);
    final frontTopRight = Offset(centerX, centerY - cubeSize / 2);
    final frontBottomLeft = Offset(centerX - cubeSize, centerY + cubeSize / 2);
    final frontBottomRight = Offset(centerX, centerY + cubeSize / 2);

    // Back face of the cube (shifted to the right and upwards)
    final backTopLeft = Offset(centerX - cubeSize / 2, centerY - cubeSize);
    final backTopRight = Offset(centerX + cubeSize / 2, centerY - cubeSize);
    final backBottomLeft = Offset(centerX - cubeSize / 2, centerY);
    final backBottomRight = Offset(centerX + cubeSize / 2, centerY);

    // Draw front face
    canvas.drawLine(frontTopLeft, frontTopRight, paint);
    canvas.drawLine(frontTopRight, frontBottomRight, paint);
    canvas.drawLine(frontBottomRight, frontBottomLeft, paint);
    canvas.drawLine(frontBottomLeft, frontTopLeft, paint);

    // Draw back face
    canvas.drawLine(backTopLeft, backTopRight, paint);
    canvas.drawLine(backTopRight, backBottomRight, paint);
    canvas.drawLine(backBottomRight, backBottomLeft, paint);
    canvas.drawLine(backBottomLeft, backTopLeft, paint);

    // Connect front and back faces
    canvas.drawLine(frontTopLeft, backTopLeft, paint);
    canvas.drawLine(frontTopRight, backTopRight, paint);
    canvas.drawLine(frontBottomLeft, backBottomLeft, paint);
    canvas.drawLine(frontBottomRight, backBottomRight, paint);

    // Labels for each axis
    // Place "Width (X)" at the bottom of the front-bottom edge
    final textPainterX = TextPainter(
      text: TextSpan(
        text: 'Width (X)',
        style: TextStyle(color: Color.fromARGB(255, 66, 66, 66)),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterX.layout();
    textPainterX.paint(
      canvas,
      Offset(frontBottomLeft.dx - 15, frontBottomLeft.dy + 2),
    );

    // Place "Height (Y)" next to the vertical (standing) axis on the left
    final textPainterY = TextPainter(
      text: TextSpan(
        text: 'Height (Y)',
        style: TextStyle(color: Color.fromARGB(255, 66, 66, 66)),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterY.layout();
    textPainterY.paint(
      canvas,
      Offset(frontTopLeft.dx + 95, frontTopLeft.dy - 10),
    );

    // Place "Depth (Z)" on the other side of the width axis
    final textPainterZ = TextPainter(
      text: TextSpan(
        text: 'Depth (Z)',
        style: TextStyle(color: Color.fromARGB(255, 66, 66, 66)),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterZ.layout();
    textPainterZ.paint(
      canvas,
      Offset(backBottomRight.dx - 10, backBottomRight.dy + 10),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
