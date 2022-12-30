import 'dart:developer';

import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/nodes_repository.dart';

/// Defines what a path finding algorithm needs and tools to visualize it
abstract class VisualizableAlgorithm {
  List<Node> nodesStack = [];
  List<Node> doneNodes = [];
  Node goalNode = Node(x: 20, y: 20);
  Node startNode = Node(x: 10, y: 20);
  double _diagonalPathCost = 2;
  double _horizontalAndVerticalPathCost = 1;
  bool isRunning = false;
  int animationTimeDelay = 100;
  final void Function(NodesArray nodes) onStepUpdate;
  late final NodesArray allNodes;

  VisualizableAlgorithm({
    required this.onStepUpdate,
    required List<List<Node>>? nodesToStartWith,
  }) {
    allNodes = nodesToStartWith ?? _generateInitialEmptyNodes();
    setDiagonalPathCostTo(cost: _diagonalPathCost);
    setHorizontalAndVerticalPathCostTo(cost: _horizontalAndVerticalPathCost);
  }

  static List<List<Node>> _generateInitialEmptyNodes() {
    return List.generate(
        NodesRepository.numberOfNodesInRow,
        (x) => List.generate(
            NodesRepository.numberOfNodesInColumn, (y) => Node(x: x, y: y),
            growable: false),
        growable: false);
  }

  /// Implementation of the alorithm
  Future<void> algorithmImplementation(Node startNode);

  /// Setus up clear state for running the algorithm and calls [algorithmImplementation]
  Future<void> runAlgorithm() async {
    if (isRunning) {
      return;
    }
    clearStacks();
    isRunning = true;
    startNode.currentPathCost = 0;
    nodesStack.add(startNode);
    await algorithmImplementation(startNode);
    isRunning = false;
  }

  /// Returns `true` if the node is outside of [allNodes] array bounds
  bool isNodeParentNodeOrOutsideOfBounds(
      {required int i, required int j, required Node parentNode}) {
    final nodesLength = allNodes.length;
    final rowLength = allNodes[0].length;
    if (i < 0 || j < 0 || i >= nodesLength || j >= rowLength) {
      return true;
    }
    if (i == parentNode.x && j == parentNode.y) {
      return true;
    }
    return false;
  }

  /// Returns `true` if the node is a wall or if it is allready in the [doneNodes]
  bool isNodeWallOrDone({required Node node}) {
    if (node.isWall || doneNodes.any(((element) => element.id == node.id))) {
      return true;
    }
    return false;
  }

  /// Visualize shortest path, going from the end node back to the starting point.
  Future<void> showShortestPath(Node endNode) async {
    allNodes[endNode.x][endNode.y].isOnTraceablePathToGoal = true;
    var child = endNode.cameFromNode;
    while (child != null) {
      if (!isRunning) {
        return;
      }
      allNodes[child.x][child.y].isOnTraceablePathToGoal = true;
      child = child.cameFromNode;
      await showUpdatedNodes(overridenAnimationDelayInMilliseconds: 70000);
      log('Tracing back: ${child?.x} : ${child?.y}');
    }
  }

  void clearStacks() {
    doneNodes.clear();
    nodesStack.clear();
  }

  void setAnimationTimeDelayTo({required int microseconds}) =>
      animationTimeDelay = microseconds;

  /// Sends updated version of nodes to be shown on the screen.
  Future<void> showUpdatedNodes(
      {int? overridenAnimationDelayInMilliseconds}) async {
    onStepUpdate(allNodes);
    await Future.delayed(Duration(
        microseconds:
            overridenAnimationDelayInMilliseconds ?? animationTimeDelay));
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
    showUpdatedNodes();
  }

  void removeGoalAt(int x, int y) async {
    allNodes[x][y].isGoalNode = false;
    showUpdatedNodes();
  }

  void removeStartAt(int x, int y) async {
    allNodes[x][y].isStart = false;
    showUpdatedNodes();
  }

  void setStartAt(int x, int y) async {
    allNodes[x][y].isStart = true;
    startNode = allNodes[x][y];
    showUpdatedNodes();
  }

  void setWallAt(int x, int y) async {
    allNodes[x][y].isWall = true;
    showUpdatedNodes();
  }

  void resetAt(int x, int y) async {
    allNodes[x][y].reset();
    showUpdatedNodes();
  }

  /// Resets everything
  void resetAll() async {
    for (var nodesRow in allNodes) {
      for (var node in nodesRow) {
        node.reset();
      }
    }
    setGoalAt(20, 20);
    setStartAt(10, 20);
    isRunning = false;
    showUpdatedNodes();
  }

  /// Resets algorithm, without walls and goal nodes
  void resetAlgorithmToStart() async {
    for (var nodesRow in allNodes) {
      for (var node in nodesRow) {
        node.resetVisualAlgorithmSteps();
      }
    }
    isRunning = false;
    showUpdatedNodes();
  }
}
