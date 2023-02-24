import 'dart:math';

import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/nodes_repository.dart';
import 'package:path_finding/data/recursive_division_algorithm.dart';

/// Defines what a path finding algorithm needs and tools to visualize it
abstract class VisualizableAlgorithm {
  List<Node> nodesStack = [];
  List<Node> doneNodes = [];
  Node goalNode = Node(x: 20, y: 20);
  Node startNode = Node(x: 10, y: 20);
  double _diagonalPathCost = 2;
  double _horizontalAndVerticalPathCost = 1;
  bool isDiagonalMovementEnabeld = false;
  bool isRunning = false;
  int animationTimeDelay = 100;
  void Function(NodesArray nodes) onStepUpdate;
  NodesArray allNodes = [];

  VisualizableAlgorithm(
      {NodesArray? nodesToStartWith, required this.onStepUpdate}) {
    allNodes = nodesToStartWith ?? [];
  }

  void initSetup({
    required Function(NodesArray nodes) onStepUpdate,
    required int numberOfNodesInRow,
    required int numberOfNodesInColumn,
  }) {
    this.onStepUpdate = onStepUpdate;
    allNodes = _generateInitialEmptyNodes(
        numberOfNodesInRow: numberOfNodesInRow,
        numberOfNodesInColumn: numberOfNodesInColumn);
    setDiagonalPathCostTo(cost: _diagonalPathCost);
    setHorizontalAndVerticalPathCostTo(cost: _horizontalAndVerticalPathCost);
  }

  static List<List<Node>> _generateInitialEmptyNodes({
    required int numberOfNodesInRow,
    required int numberOfNodesInColumn,
  }) {
    return List.generate(
        numberOfNodesInRow,
        (x) => List.generate(numberOfNodesInColumn + 1, (y) => Node(x: x, y: y),
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
    await showUpdatedNodes();
    clearStacks();
    isRunning = true;
    startNode = allNodes[startNode.x][startNode.y];
    startNode.currentPathCost = 0;
    nodesStack.add(startNode);
    await showUpdatedNodes();
    await algorithmImplementation(startNode);
    isRunning = false;
  }

  Future<void> makeMaze() async {
    if (isRunning) {
      return;
    }
    await resetAll();
    for (int i = 0; i < allNodes.length; i++) {
      allNodes[i][0].isWall = true;
      allNodes[i][allNodes.first.length - 2].isWall = true;
    }
    for (int y = 0; y < allNodes.first.length - 1; y++) {
      allNodes[0][y].isWall = true;
      allNodes[allNodes.length - 1][y].isWall = true;
    }
    await showUpdatedNodes();
    await recursiveDivisionMazeGenerate(
      allNodes,
      1,
      allNodes.length - 1,
      1,
      allNodes.first.length - 2,
      showUpdatedNodes,
    );
  }

  /// Returns `true` if the node is outside of [allNodes] array bounds or is the parent node
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
      if (child.isStart) {
        allNodes[child.x][child.y].isOnTraceablePathToGoal = true;
        await showUpdatedNodes(overridenAnimationDelayInMilliseconds: 70000);
        return;
      }
      allNodes[child.x][child.y].isOnTraceablePathToGoal = true;
      child = child.cameFromNode;
      await showUpdatedNodes(overridenAnimationDelayInMilliseconds: 70000);
    }
  }

  void clearStacks() {
    doneNodes.clear();
    nodesStack.clear();
  }

  void setAnimationTimeDelayTo({required int microseconds}) {
    animationTimeDelay = microseconds;
  }

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

  void setIsDiagonalMovementEnabeld({required bool toValue}) async {
    isDiagonalMovementEnabeld = toValue;
  }

  void resetAt(int x, int y) async {
    allNodes[x][y].reset();
    showUpdatedNodes();
  }

  /// Performs a change with [changeNode] on a first node that is not a wall. Attempts to start at coordinates [startX] : [startY]
  void changeOnFirstClearNode(
      int startX, startY, void Function() Function(Node node) changeNode) {
    int x = startX;
    int y = startY;
    while (allNodes[x][y].isWall) {
      startX += Random().nextBool() ? 1 : 0;
      startY += Random().nextBool() ? 1 : 0;
    }
    changeNode(allNodes[x][y]);
  }

  /// Resets everything, including walls, start, and goal node
  Future<void> resetAll({bool shouldSetGoalAndEndNodes = true}) async {
    for (var nodesRow in allNodes) {
      for (var node in nodesRow) {
        node.reset();
      }
    }
    if (shouldSetGoalAndEndNodes) {
      setGoalAt(4, 10);
      setStartAt(10, 10);
    }
    isRunning = false;
    await showUpdatedNodes();
  }

  /// Resets everything, *whitout* walls, start, and goal node
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
