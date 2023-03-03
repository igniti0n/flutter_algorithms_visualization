import 'dart:math';

import '../common/models/node.dart';

/// Algo works like this:
/// - Slice V or H
/// - Take a random point to slice the array V or H with a wall
/// - Take a random point to make a gap in the wall
/// - Make wall V or H at the chosen point, leave a gap in the wall
/// - Make corrections if the wall is blocking any previously created passages
/// - Repeat for the both slices of arrays
Future<void> recursiveDivisionMazeGenerate(List<List<Node>> allNodes, int xLow, int xHigh, int yLow, int yHigh,
    void Function({int? overriddenAnimationDelayInMilliseconds}) showUpdates) async {
  final random = Random();
  final xLength = xHigh - xLow;
  final yLength = yHigh - yLow;
  final isCutVertical = xLength > yLength;
  if (xLength < 2 || yLength < 2 || xLength == 2 && yLength == 2) {
    return;
  }
  await Future.delayed(const Duration(milliseconds: 300));
  showUpdates.call();

  final xPoint = (xLow + random.nextInt((xHigh - xLow) ~/ 2)).clamp(xLow + 1, xHigh - 1);
  final yPoint = (yLow + random.nextInt((yHigh - yLow) ~/ 2)).clamp(yLow + 1, yHigh - 1);

  if (isCutVertical) {
    // Make vertical wall with a random gap
    for (var y = yLow; y < yHigh; y++) {
      if (y != yPoint) {
        allNodes[xPoint][y].isWall = true;
      }
    }
    // Unblock any previously created passages
    final isTopOnPassage = allNodes[xPoint][yLow - 1].isWall == false;
    final isBottomOnPassage = allNodes[xPoint][yHigh].isWall == false;
    if ((isTopOnPassage || isBottomOnPassage) && yLength > 2) {
      allNodes[xPoint][yPoint].isWall = true;
    }
    if (isTopOnPassage) {
      allNodes[xPoint][yLow].isWall = false;
    }
    if (isBottomOnPassage) {
      allNodes[xPoint][yHigh - 1].isWall = false;
    }
    // Repeat for the splitted arrays
    recursiveDivisionMazeGenerate(allNodes, xLow, xPoint, yLow, yHigh, showUpdates);
    recursiveDivisionMazeGenerate(allNodes, xPoint + 1, xHigh, yLow, yHigh, showUpdates);
  } else {
    // Make horizontal wall with a random gap
    for (var x = xLow; x < xHigh; x++) {
      if (x != xPoint) {
        allNodes[x][yPoint].isWall = true;
      }
    }
    // Unblock any previously created passages
    final isLeftOnPassage = allNodes[xLow - 1][yPoint].isWall == false;
    final isRightOnPassage = allNodes[xHigh][yPoint].isWall == false;
    if ((isLeftOnPassage || isRightOnPassage) && xLength > 2) {
      allNodes[xPoint][yPoint].isWall = true;
    }
    if (isLeftOnPassage) {
      allNodes[xLow][yPoint].isWall = false;
    }
    if (isRightOnPassage) {
      allNodes[xHigh - 1][yPoint].isWall = false;
    }
    // Repeat for the splitted arrays
    recursiveDivisionMazeGenerate(allNodes, xLow, xHigh, yLow, yPoint, showUpdates);
    recursiveDivisionMazeGenerate(allNodes, xLow, xHigh, yPoint + 1, yHigh, showUpdates);
  }
}
