import 'dart:math' as math;

import 'package:path_finding/common/models/node.dart';

double calculateDistance(startX, startY, endX, endY) {
  final distX = (startX - endX).abs();
  final distY = (startY - endY).abs();
  return math.sqrt(distX * distX + distY * distY);
}

bool isNodeOnDiagonal(
        {required Node currentlyLookingNode, required Node parentNode}) =>
    (parentNode.x != currentlyLookingNode.x &&
        parentNode.y != currentlyLookingNode.y);
