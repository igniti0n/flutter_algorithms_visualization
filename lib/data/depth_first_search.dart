import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/common/utils.dart';
import 'package:path_finding/data/visualizable_algorithm.dart';

class DepthFirstSearch extends VisualizableAlgorithm {
  DepthFirstSearch({required super.onStepUpdate, super.nodesToStartWith});
  int lowerHorizontalBoundary = 0;
  int upperHorizontalBoundary = 0;

  @override
  Future<void> algorithmImplementation(Node startNode) async {
    lowerHorizontalBoundary = 0;
    upperHorizontalBoundary = allNodes[0].length;
    final goalNodeX = goalNode?.x ?? 0;
    if (goalNodeX <= startNode.x) {
      lowerHorizontalBoundary = startNode.x;
    } else {
      upperHorizontalBoundary = startNode.x;
    }
    await doDFS(startNode);
  }

  Future<void> doDFS(Node node) async {
    for (var j = node.y - 1; j <= node.y + 1; j++) {
      for (var i = node.x - 1; i <= node.x + 1; i++) {
        if (!isRunning) {
          return;
        }
        if (isNodeParentNodeOrOutsideOfBounds(i: i, j: j, parentNode: node)) {
          continue;
        }
        if (isNodeOnDiagonalForCoordinates(
            startX: i, startY: j, endX: node.x, endY: node.y)) {
          continue;
        }
        if (i >= lowerHorizontalBoundary && i <= upperHorizontalBoundary) {
          continue;
        }
        final currentlyLookingNode = allNodes[i][j];
        if (isNodeWallOrDone(node: currentlyLookingNode)) {
          continue;
        }
        if (currentlyLookingNode.isVisited) {
          continue;
        }
        allNodes[i][j].cameFromNode = node;
        if (currentlyLookingNode.isGoalNode) {
          isRunning = false;
          await showShortestPath(currentlyLookingNode, milliseconds: 10);
          return;
        } else {
          allNodes[i][j].isVisited = true;
          await showUpdatedNodes();
          await doDFS(allNodes[i][j]);
        }
      }
    }
  }
}
