import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/common/utils.dart';
import 'package:path_finding/data/visualizable_algorithm.dart';

class BreadthFirstSearch extends VisualizableAlgorithm {
  BreadthFirstSearch({required super.onStepUpdate, super.nodesToStartWith});
  int lowerHorizontalBoundary = 0;
  int upperHorizontalBoundary = 0;

  @override
  Future<void> algorithmImplementation(Node startNode) async {
    lowerHorizontalBoundary = 0;
    upperHorizontalBoundary = allNodes.length;
    final goalNodeX = goalNode.x;
    if (goalNodeX <= startNode.x) {
      lowerHorizontalBoundary = startNode.x + 1;
    } else {
      upperHorizontalBoundary = startNode.x - 1;
    }
    while (nodesStack.isNotEmpty) {
      await doBFS();
    }
  }

  Future<void> doBFS() async {
    final node = nodesStack.removeAt(0);
    for (var j = node.y - 1; j <= node.y + 1; j++) {
      for (var i = node.x - 1; i <= node.x + 1; i++) {
        if (!isRunning) {
          return;
        }
        if (shouldIgnoreNode(i, j, node)) {
          continue;
        }
        final currentlyLookingNode = allNodes[i][j];
        currentlyLookingNode.cameFromNode = node;
        if (currentlyLookingNode.isGoalNode) {
          await showShortestPath(currentlyLookingNode);
          isRunning = false;
          return;
        } else {
          currentlyLookingNode.isVisited = true;
          await showUpdatedNodes();
          nodesStack.add(currentlyLookingNode);
        }
      }
    }
  }

  bool shouldIgnoreNode(int i, int j, Node node) {
    if (isNodeParentNodeOrOutsideOfBounds(i: i, j: j, parentNode: node)) {
      return true;
    }
    if (isNodeOnDiagonalForCoordinates(
        startX: i, startY: j, endX: node.x, endY: node.y)) {
      return true;
    }
    if (i >= lowerHorizontalBoundary && i <= upperHorizontalBoundary) {
      return true;
    }
    if (isNodeWallOrDone(node: allNodes[i][j])) {
      return true;
    }
    if (allNodes[i][j].isVisited) {
      return true;
    }
    return false;
  }
}
