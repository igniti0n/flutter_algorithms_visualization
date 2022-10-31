import 'dart:developer';

import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/path_finding_algorithm.dart';

class DijkstrasAlgorithm extends PathFindingAlgorithm
    implements ShortestPathAlgorithm {
  DijkstrasAlgorithm({required super.onStepUpdate});

  @override
  Future<void> doAlgorithm(Node startNode, Node goalNode) async {
    if (isRunning) {
      return;
    }
    clearStacks();
    isRunning = true;
    startNode.currentCost = 0;
    nodesStack.add(startNode);
    while (true) {
      if (nodesStack.isEmpty) {
        log('Stack is empty, done!');
        break;
      }
      final currentNode = nodesStack.removeAt(nodesStack.length - 1);
      // Found node
      if (currentNode.isGoalNode == true) {
        log('Found shortest path! At: ${currentNode.x} - ${currentNode.y}');
        await showShortestPath(currentNode);
        return;
      }
      goThroughChildren(currentNode, goalNode);
      nodesStack.sort(
        (a, b) => b.currentCost.compareTo(a.currentCost),
      );
      await showUpdatedNodes();
    }
    isRunning = false;
  }

  void goThroughChildren(Node parentNode, Node goalNode) async {
    final nodeX = parentNode.x;
    final nodeY = parentNode.y;
    final nodesLength = allNodes.length;
    for (int i = nodeX - 1; i <= (nodeX + 1); i++) {
      for (int j = nodeY - 1; j <= (nodeY + 1); j++) {
        // Inside bounds
        if (i < 0 || j < 0 || i >= nodesLength || j >= nodesLength) {
          continue;
        }
        if (i == nodeX && j == nodeY) {
          continue;
        }
        if (allNodes[i][j].isWall ||
            doneNodes.any(((element) => element.id == allNodes[i][j].id))) {
          continue;
        }
        allNodes[i][j].isVisited = true;
        final isOnDiagonal = (nodeX != i && nodeY != j);
        var costToGoToNode = parentNode.currentCost +
            (isOnDiagonal ? diagonalPathCost : horizontalAndVerticalPathCost);
        // testing, A* search
        // final distanceFromGoalX = (goalNode.x - allNodes[i][j].x).abs();
        // final distanceFromGoalY = (goalNode.y - allNodes[i][j].y).abs();
        // final totalDistance = distanceFromGoalX + distanceFromGoalY;
        // costToGoToNode += totalDistance * 10;
        if (costToGoToNode < allNodes[i][j].currentCost) {
          allNodes[i][j].currentCost = costToGoToNode;
          allNodes[i][j].cameFromNode = parentNode;
          nodesStack.add(allNodes[i][j]);
        }
      }
    }
    doneNodes.add(allNodes[nodeX][nodeY]);
    nodesStack.sort(
      (a, b) => a.currentCost <= b.currentCost ? -1 : 1,
    );
  }
}
