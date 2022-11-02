import 'dart:math' as math;

double calculateDistance(double startX, startY, endX, endY) {
  final distX = (startX - endX).abs();
  final distY = (startY - endY).abs();
  return math.sqrt(distX * distX + distY * distY);
}
