import 'dart:developer';

import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/nodes_repository.dart';

abstract class ShortestPathAlgorithm {
  Future<void> doAlgorithm(Node startNode);
  Future<void> visitNode(Node currentlyLookingNode, Node parentNode);
  void sortNodesStackAfterOneTurn(List<Node> nodesStack);
}

/// Defines what a path finding algorithm needs and tools to visualize it
abstract class PathFindingAlgorithm implements ShortestPathAlgorithm {
  List<Node> nodesStack = [];
  List<Node> doneNodes = [];
  Node? goalNode;
  double _diagonalPathCost = 1;
  double _horizontalAndVerticalPathCost = 1;
  bool isRunning = false;
  final void Function(NodesArray nodes) onStepUpdate;
  late final NodesArray allNodes;

  PathFindingAlgorithm({
    required this.onStepUpdate,
    required List<List<Node>>? nodesToStartWith,
  }) {
    allNodes = nodesToStartWith ?? _generateInitialEmptyNodes();
  }

  static List<List<Node>> _generateInitialEmptyNodes() {
    return List.generate(
        NodesRepository.numberOfNodesInRow,
        (x) => List.generate(
            NodesRepository.numberOfNodesInRow, (y) => Node(x: x, y: y),
            growable: false),
        growable: false);
  }

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
      await _showUpdatedNodes();
    }
    isRunning = false;
  }

  /// Goes through all children of the node, so all the neighbors.
  /// Skips any node that is a wall, a parent node and if the currenlty looking at child node is allready done
  Future<void> goThroughChildren(Node parentNode) async {
    final nodeX = parentNode.x;
    final nodeY = parentNode.y;
    final nodesLength = allNodes.length;
    for (int i = nodeX - 1; i <= (nodeX + 1); i++) {
      for (int j = nodeY - 1; j <= (nodeY + 1); j++) {
        // Inside the bonus
        if (i < 0 || j < 0 || i >= nodesLength || j >= nodesLength) {
          continue;
        }
        if (i == nodeX && j == nodeY) {
          continue;
        }
        final currentlyLookingNode = allNodes[i][j];
        //
        // final isOnDiagonal = (parentNode.x != currentlyLookingNode.x &&
        //     parentNode.y != currentlyLookingNode.y);
        // if (isOnDiagonal) {
        //   continue;
        // }
        if (currentlyLookingNode.isWall ||
            doneNodes
                .any(((element) => element.id == currentlyLookingNode.id))) {
          continue;
        }
        visitNode(currentlyLookingNode, parentNode);
      }
    }
    doneNodes.add(parentNode);
  }

  /// Visualize shortest path, going from the end node back to the starting point.
  Future<void> showShortestPath(Node endNode) async {
    allNodes[endNode.x][endNode.y].isOnTraceablePathToGoal = true;
    var child = endNode.cameFromNode;
    while (child != null) {
      allNodes[child.x][child.y].isOnTraceablePathToGoal = true;
      child = child.cameFromNode;
    }
    await _showUpdatedNodes();
  }

  void clearStacks() {
    doneNodes.clear();
    nodesStack.clear();
  }

  /// Sends updated version of nodes to be shown on the screen.
  Future<void> _showUpdatedNodes() async {
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(milliseconds: 10));
  }

  void setDiagonalPathCostTo({required double cost}) =>
      _diagonalPathCost = cost;

  void setHorizontalAndVerticalPathCostTo({required double cost}) =>
      _horizontalAndVerticalPathCost = cost;

  double get diagonalPathCost => _diagonalPathCost;

  double get horizontalAndVerticalPathCost => _horizontalAndVerticalPathCost;

  void setGoalAt(int x, int y) async {
    allNodes[x][y].isGoalNode = true;
    goalNode = allNodes[x][y];
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(microseconds: 0));
  }

  void setWallAt(int x, int y) async {
    allNodes[x][y].isWall = true;
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(microseconds: 0));
  }

  void resetAt(int x, int y) async {
    if (allNodes[x][y].isGoalNode) {
      goalNode = null;
    }
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
    goalNode = null;
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(microseconds: 0));
    isRunning = false;
  }

  /// Resets algorithm, without walls and goal nodes
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
