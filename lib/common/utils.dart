import 'dart:math' as math;

import 'package:path_finding/common/models/node.dart';

double calculateDistance(startX, startY, endX, endY) {
  final distX = (startX - endX).abs();
  final distY = (startY - endY).abs();
  return math.sqrt(distX * distX + distY * distY);
}

bool isNodeOnDiagonal(
        {required Node currentlyLookingNode, required Node parentNode}) =>
    isNodeOnDiagonalForCoordinates(
        startX: currentlyLookingNode.x,
        startY: currentlyLookingNode.y,
        endX: parentNode.x,
        endY: parentNode.y);

bool isNodeOnDiagonalForCoordinates({
  required int startX,
  required int startY,
  required int endX,
  required int endY,
}) =>
    (endX != startX && endY != startY);
