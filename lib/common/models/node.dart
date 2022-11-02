import 'package:uuid/uuid.dart';

class NodeCoordinate {
  final int x;
  final int y;
  NodeCoordinate(this.x, this.y);
}

class Node {
  final String id = const Uuid().v4();
  final int x;
  final int y;
  bool isGoalNode;
  bool isOnTraceablePathToGoal;
  bool isWall;
  bool isVisited;
  double currentCost;
  Node? cameFromNode;

  Node({
    this.isGoalNode = false,
    required this.x,
    required this.y,
    this.isVisited = false,
    this.isWall = false,
    this.currentCost = double.infinity,
    this.isOnTraceablePathToGoal = false,
  });

  void updateCostIfNecessary(double calculatedCost) {
    if (currentCost > calculatedCost) {
      currentCost = calculatedCost;
    }
  }

  Node copyWith({
    bool? isGoalNode = false,
    int? x,
    int? y,
    bool? isVisited,
    bool? isOnTraceablePathToGoal,
    bool? isWall,
    double? currentCost,
    Node? cameFromNode,
  }) =>
      Node(
        x: x ?? this.x,
        y: y ?? this.y,
        isGoalNode: isGoalNode ?? this.isGoalNode,
        isVisited: isVisited ?? this.isVisited,
        isWall: isWall ?? this.isWall,
        currentCost: currentCost ?? this.currentCost,
        isOnTraceablePathToGoal:
            isOnTraceablePathToGoal ?? this.isOnTraceablePathToGoal,
      );

  bool isDifferent(Node node) =>
      node.isWall != isWall ||
      node.x != x ||
      node.y != y ||
      node.isVisited != isVisited ||
      node.isOnTraceablePathToGoal != isOnTraceablePathToGoal ||
      node.isGoalNode != isGoalNode;

  void reset() {
    isGoalNode = false;
    isVisited = false;
    isWall = false;
    currentCost = double.infinity;
    isOnTraceablePathToGoal = false;
  }

  void resetVisualAlgorithmSteps() {
    isVisited = false;
    currentCost = double.infinity;
    isOnTraceablePathToGoal = false;
  }
}
