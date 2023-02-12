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
  Future<void> algorithmImplementation(Node startNode) async {
    while (true) {
      if (!isRunning) {
        resetAlgorithmToStart();
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
      await goThroughChildren(currentNode);
      sortNodesStackAfterOneTurn(nodesStack);
      nodesStack.last.isTopPriority = true;

      await showUpdatedNodes();
    }
  }

  /// Goes through all children of the node, so all the neighbors.
  /// Skips any node that is a wall, a parent node and if the currenlty looking at child node is allready done
  Future<void> goThroughChildren(Node parentNode) async {
    final nodeX = parentNode.x;
    final nodeY = parentNode.y;

    for (int i = nodeX - 1; i <= (nodeX + 1); i++) {
      for (int j = nodeY - 1; j <= (nodeY + 1); j++) {
        if (isNodeParentNodeOrOutsideOfBounds(
            i: i, j: j, parentNode: parentNode)) {
          continue;
        }
        final currentlyLookingNode = allNodes[i][j];
        if (isNodeWallOrDone(node: currentlyLookingNode)) {
          continue;
        }
        final isOnDiagonal = isNodeOnDiagonal(
            currentlyLookingNode: currentlyLookingNode, parentNode: parentNode);
        if (isOnDiagonal && !isDiagonalMovementEnabeld) {
          continue;
        }
        // currentlyLookingNode.isCurrentlyBeingVisited = true;
        // await showUpdatedNodes();
        visitNode(currentlyLookingNode, parentNode);
        // currentlyLookingNode.isCurrentlyBeingVisited = false;
        // await showUpdatedNodes();
      }
    }
    doneNodes.add(parentNode);
    allNodes[nodeX][nodeY].isVisited = true;
  }

  /// Evaluates the cost to go to the [Node], and updates it if cost is better then the already calculated one
  void visitNode(Node currentlyLookingNode, Node parentNode) {
    final isOnDiagonal = isNodeOnDiagonal(
        currentlyLookingNode: currentlyLookingNode, parentNode: parentNode);
    var costToGoToNode = parentNode.currentPathCost +
        (isOnDiagonal ? diagonalPathCost : horizontalAndVerticalPathCost);
    // only the path cost is being look for when moving to the node
    if (costToGoToNode < currentlyLookingNode.currentPathCost) {
      currentlyLookingNode.currentPathCost = costToGoToNode;
      currentlyLookingNode.cameFromNode = parentNode;
      nodesStack.add(currentlyLookingNode);
      currentlyLookingNode.isInStack = true;
    }
  }

  void sortNodesStackAfterOneTurn(List<Node> nodesStack) {
    nodesStack.sort(
      (a, b) => (b.currentPathCost).compareTo(a.currentPathCost),
    );
  }
}
