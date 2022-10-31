import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/nodes_repository.dart';

abstract class ShortestPathAlgorithm {
  Future<void> doAlgorithm(Node startNode, Node goalNode);
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