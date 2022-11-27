import 'dart:developer';

import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/common/utils.dart';
import 'package:path_finding/data/nodes_repository.dart';
import 'package:path_finding/data/visualizable_algorithm.dart';

/// Defines what a path finding algorithm needs and tools to visualize it
class DijkstraAlgorithm extends VisualizableAlgorithm {
  DijkstraAlgorithm({
    required Function(NodesArray nodes) onStepUpdate,
    List<List<Node>>? nodesToStartWith,
  }) : super(onStepUpdate: onStepUpdate, nodesToStartWith: nodesToStartWith);

  /// Assembles core steps of a path finding algorithm, based on the starting point
  @override
  Future<void> doAlgorithm(Node startNode) async {
    if (isRunning) {
      return;
    }
    clearStacks();
    isRunning = true;
    startNode.currentPathCost = 0;
    nodesStack.add(startNode);
    while (true) {
      if (!isRunning) {
        resetAll();
        break;
      }
      if (nodesStack.isEmpty) {
        log('Stack is empty, done!');
        break;
      }
      final currentNode = nodesStack.removeAt(nodesStack.length - 1);
      if (currentNode.isGoalNode == true) {
        log('Found shortest path! At: ${currentNode.x} - ${currentNode.y}');
        await showShortestPath(currentNode);
        return;
      }
      goThroughChildren(currentNode);
      sortNodesStackAfterOneTurn(nodesStack);
      await showUpdatedNodes();
    }
    isRunning = false;
  }

  /// Goes through all children of the node, so all the neighbors.
  /// Skips any node that is a wall, a parent node and if the currenlty looking at child node is allready done
  Future<void> goThroughChildren(Node parentNode) async {
    final nodeX = parentNode.x;
    final nodeY = parentNode.y;

    for (int i = nodeX - 1; i <= (nodeX + 1); i++) {
      for (int j = nodeY - 1; j <= (nodeY + 1); j++) {
        if (isNodeOutsideOfBounds(i: i, j: j, parentNode: parentNode)) {
          continue;
        }
        final currentlyLookingNode = allNodes[i][j];
        if (isNodeWallOrDone(node: currentlyLookingNode)) {
          continue;
        }
        //
        // final isOnDiagonal = (parentNode.x != currentlyLookingNode.x &&
        //     parentNode.y != currentlyLookingNode.y);
        // if (isOnDiagonal) {
        //   continue;
        // }
        visitNode(currentlyLookingNode, parentNode);
      }
    }
    doneNodes.add(parentNode);
    allNodes[nodeX][nodeY].isVisited = true;
  }

  Future<void> visitNode(Node currentlyLookingNode, Node parentNode) async {
    final isOnDiagonal = isNodeOnDiagonal(
        currentlyLookingNode: currentlyLookingNode, parentNode: parentNode);
    var costToGoToNode = parentNode.currentPathCost +
        (isOnDiagonal ? diagonalPathCost : horizontalAndVerticalPathCost);
    // only the path cost is being look for when moving to the node
    if (costToGoToNode < currentlyLookingNode.currentPathCost) {
      currentlyLookingNode.currentPathCost = costToGoToNode;
      currentlyLookingNode.cameFromNode = parentNode;
      nodesStack.add(currentlyLookingNode);
    }
  }

  void sortNodesStackAfterOneTurn(List<Node> nodesStack) {
    nodesStack.sort(
      (a, b) => (b.currentPathCost).compareTo(a.currentPathCost),
    );
  }
}
