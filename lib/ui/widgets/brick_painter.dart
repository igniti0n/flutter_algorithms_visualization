import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_finding/ui/widgets/square.dart';

// Not used because perfomance loss for now :(, does make a nice brick wall tough...
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
  late final double middleRowOfset;
  late final double bottomRowOfset;

  BrickPainter() : super() {
    middleRowOfset = Random().nextDouble() * 8;
    bottomRowOfset = Random().nextDouble() * 8;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final brickPaint = Paint()
      ..color = Colors.deepOrangeAccent.withOpacity(0.3);
    final brickWidth = size.width / 1.9;
    final brickHeight = size.height / 3.5;

// top row
    var rrect2 = RRect.fromLTRBAndCorners(
      0,
      0,
      brickWidth,
      brickHeight,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );

    var rrect = RRect.fromLTRBAndCorners(
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
    var rrect3 = RRect.fromLTRBAndCorners(
      0 - middleRowOfset,
      brickHeight + spacing,
      brickWidth - middleRowOfset,
      brickHeight + spacing + brickHeight,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );

    var rrect4 = RRect.fromLTRBAndCorners(
      brickWidth + spacing - middleRowOfset,
      brickHeight + spacing,
      brickWidth + spacing + brickWidth - middleRowOfset + 10,
      brickHeight + spacing + brickHeight,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );
    // bottom row
    var rrect5 = RRect.fromLTRBAndCorners(
      -10 + bottomRowOfset,
      brickHeight * 2 + spacing * 2,
      brickWidth + bottomRowOfset,
      brickHeight * 3 + spacing * 2,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );

    var rrect6 = RRect.fromLTRBAndCorners(
      brickWidth + spacing + bottomRowOfset,
      brickHeight * 2 + spacing * 2,
      brickWidth + spacing + brickWidth + bottomRowOfset,
      brickHeight * 3 + spacing * 2,
      bottomLeft: const Radius.circular(radius),
      bottomRight: const Radius.circular(radius),
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
    );

    canvas.drawRRect(rrect, brickPaint);
    canvas.drawRRect(rrect2, brickPaint);
    canvas.drawRRect(rrect3, brickPaint);
    canvas.drawRRect(rrect4, brickPaint);
    canvas.drawRRect(rrect5, brickPaint);
    canvas.drawRRect(rrect6, brickPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
