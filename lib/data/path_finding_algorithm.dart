import 'dart:developer';

import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/nodes_repository.dart';

abstract class ShortestPathAlgorithm {
  Future<void> doAlgorithm(Node startNode, Node goalNode);
  Future<void> visitNode(Node currentlyLookingNode, Node parentNode);
}

/// Defines what a path finding alogrithm needs and tools to visualize it
abstract class PathFindingAlgorithm implements ShortestPathAlgorithm {
  List<Node> nodesStack = [];
  List<Node> doneNodes = [];
  double diagonalPathCost = 15;
  double horizontalAndVerticalPathCost = 15;
  bool isRunning = false;
  final NodesArray allNodes = List.generate(
      NodesRepository.numberOfNodesInRow,
      (x) => List.generate(
          NodesRepository.numberOfNodesInRow, (y) => Node(x: x, y: y),
          growable: false),
      growable: false);
  final void Function(NodesArray nodes) onStepUpdate;

  PathFindingAlgorithm({
    required this.onStepUpdate,
  });

  /// Assembles core steps of a path finding algorithm
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
      goThroughChildren(currentNode, goalNode);
      nodesStack.sort(
        (a, b) => b.currentCost.compareTo(a.currentCost),
      );
      await showUpdatedNodes();
    }
    isRunning = false;
  }

  /// Goes throuh all children of the node, so all the neighbors.
  /// Skips any node that is a wall, a parent node and if the currenlty looking at child node is allready done
  Future<void> goThroughChildren(Node parentNode, Node goalNode) async {
    final nodeX = parentNode.x;
    final nodeY = parentNode.y;
    final nodesLength = allNodes.length;
    for (int i = nodeX - 1; i <= (nodeX + 1); i++) {
      for (int j = nodeY - 1; j <= (nodeY + 1); j++) {
        // Inside the bouns
        if (i < 0 || j < 0 || i >= nodesLength || j >= nodesLength) {
          continue;
        }
        if (i == nodeX && j == nodeY) {
          continue;
        }
        final currentlyLookingNode = allNodes[i][j];
        if (currentlyLookingNode.isWall ||
            doneNodes
                .any(((element) => element.id == currentlyLookingNode.id))) {
          continue;
        }
        visitNode(currentlyLookingNode, parentNode);
      }
    }
    doneNodes.add(parentNode);
    nodesStack.sort(
      (a, b) => a.currentCost <= b.currentCost ? -1 : 1,
    );
  }

  /// Visualize shortest path, going from the end node back to the starting point.
  Future<void> showShortestPath(Node endNode) async {
    allNodes[endNode.x][endNode.y].isOnTracablePathToGoal = true;
    var child = endNode.cameFromNode;
    while (child != null) {
      allNodes[child.x][child.y].isOnTracablePathToGoal = true;
      child = child.cameFromNode;
    }
    await showUpdatedNodes();
  }

  void clearStacks() {
    doneNodes.clear();
    nodesStack.clear();
  }

  Future<void> showUpdatedNodes() async {
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(microseconds: 4));
  }

  void setDiagonalPathCostTo({required double cost}) => diagonalPathCost = cost;

  void setHorizotalAndVerticalPathCostTo({required double cost}) =>
      horizontalAndVerticalPathCost = cost;

  void setGoalAt(int x, int y) async {
    allNodes[x][y].isGoalNode = true;
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(microseconds: 0));
  }

  void setWallAt(int x, int y) async {
    allNodes[x][y].isWall = true;
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(microseconds: 0));
  }

  void resetAt(int x, int y) async {
    allNodes[x][y].reset();
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(microseconds: 0));
  }

  /// Resets everything
  void resetAll() async {
    for (var nodesRow in allNodes) {
      for (var node in nodesRow) {
        node.reset();
      }
    }
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(microseconds: 0));
    isRunning = false;
  }

  /// Resets algorithm, wihout walls and goal nodes
  void resetAlgorithmToStart() async {
    for (var nodesRow in allNodes) {
      for (var node in nodesRow) {
        node.resetVisualAlgorithmSteps();
      }
    }
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(microseconds: 0));
    isRunning = false;
  }
}
