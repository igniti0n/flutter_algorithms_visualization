import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_finding/ui/widgets/square.dart';

// Not used because performance loss for now :(, does make a nice brick wall tough...
class Brick extends StatelessWidget {
  const Brick({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        willChange: false,
        size: const Size(Square.size, Square.size),
        isComplex: false,
        painter: BrickPainter(),
      ),
    );
  }
}

class BrickPainter extends CustomPainter {
  static const radius = 2.0;
  static const spacing = 2;
  late final double middleRowOffset;
  late final double bottomRowOffset;

  BrickPainter() : super() {
    middleRowOffset = Random().nextDouble() * 8;
    bottomRowOffset = Random().nextDouble() * 8;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final brickPaint = Paint()..color = Colors.deepOrangeAccent.withOpacity(0.3);
    final brickWidth = size.width / 1.9;
    final brickHeight = size.height / 3.5;

// top row
    var rRect2 = RRect.fromLTRBAndCorners(
      0,
      0,
      brickWidth,
      brickHeight,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );

    var rRect = RRect.fromLTRBAndCorners(
      brickWidth + spacing,
      0,
      brickWidth + spacing + brickWidth,
      brickHeight,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );

    // middle row
    var rRect3 = RRect.fromLTRBAndCorners(
      0 - middleRowOffset,
      brickHeight + spacing,
      brickWidth - middleRowOffset,
      brickHeight + spacing + brickHeight,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );

    var rRect4 = RRect.fromLTRBAndCorners(
      brickWidth + spacing - middleRowOffset,
      brickHeight + spacing,
      brickWidth + spacing + brickWidth - middleRowOffset + 10,
      brickHeight + spacing + brickHeight,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );
    // bottom row
    var rRect5 = RRect.fromLTRBAndCorners(
      -10 + bottomRowOffset,
      brickHeight * 2 + spacing * 2,
      brickWidth + bottomRowOffset,
      brickHeight * 3 + spacing * 2,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );

    var rRect6 = RRect.fromLTRBAndCorners(
      brickWidth + spacing + bottomRowOffset,
      brickHeight * 2 + spacing * 2,
      brickWidth + spacing + brickWidth + bottomRowOffset,
      brickHeight * 3 + spacing * 2,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );

    canvas.drawRRect(rRect, brickPaint);
    canvas.drawRRect(rRect2, brickPaint);
    canvas.drawRRect(rRect3, brickPaint);
    canvas.drawRRect(rRect4, brickPaint);
    canvas.drawRRect(rRect5, brickPaint);
    canvas.drawRRect(rRect6, brickPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
