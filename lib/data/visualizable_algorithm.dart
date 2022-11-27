import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/nodes_repository.dart';

/// Defines what a path finding algorithm needs and tools to visualize it
abstract class VisualizableAlgorithm {
  List<Node> nodesStack = [];
  List<Node> doneNodes = [];
  Node? goalNode;
  double _diagonalPathCost = 30;
  double _horizontalAndVerticalPathCost = 15;
  bool isRunning = false;
  final void Function(NodesArray nodes) onStepUpdate;
  late final NodesArray allNodes;

  VisualizableAlgorithm({
    required this.onStepUpdate,
    required List<List<Node>>? nodesToStartWith,
  }) {
    allNodes = nodesToStartWith ?? _generateInitialEmptyNodes();
  }

  static List<List<Node>> _generateInitialEmptyNodes() {
    return List.generate(
        NodesRepository.numberOfNodesInRow,
        (x) => List.generate(
            NodesRepository.numberOfNodesInColumn, (y) => Node(x: x, y: y),
            growable: false),
        growable: false);
  }

  /// Assembles core steps of a path finding algorithm, based on the starting point
  Future<void> doAlgorithm(Node startNode);

  bool isNodeOutsideOfBounds(
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
      allNodes[child.x][child.y].isOnTraceablePathToGoal = true;
      child = child.cameFromNode;
    }
    await showUpdatedNodes();
  }

  void clearStacks() {
    doneNodes.clear();
    nodesStack.clear();
  }

  /// Sends updated version of nodes to be shown on the screen.
  Future<void> showUpdatedNodes() async {
    onStepUpdate(allNodes);
    await Future.delayed(const Duration(milliseconds: 1));
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
