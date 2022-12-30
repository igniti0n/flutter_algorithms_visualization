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
  bool isStart;
  bool isOnTraceablePathToGoal;
  bool isWall;
  bool isVisited;
  double currentPathCost;
  double distanceToGoal = 0;
  Node? cameFromNode;

  Node({
    this.isGoalNode = false,
    required this.x,
    required this.y,
    this.isVisited = false,
    this.isStart = false,
    this.isWall = false,
    this.currentPathCost = double.infinity,
    this.isOnTraceablePathToGoal = false,
    this.cameFromNode,
  });

  void updateCostIfNecessary(double calculatedCost) {
    if (currentPathCost > calculatedCost) {
      currentPathCost = calculatedCost;
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
    bool? isStart,
  }) =>
      Node(
        x: x ?? this.x,
        y: y ?? this.y,
        isGoalNode: isGoalNode ?? this.isGoalNode,
        isVisited: isVisited ?? this.isVisited,
        isWall: isWall ?? this.isWall,
        currentPathCost: currentCost ?? currentPathCost,
        isStart: isStart ?? this.isStart,
        isOnTraceablePathToGoal:
            isOnTraceablePathToGoal ?? this.isOnTraceablePathToGoal,
      );

  bool isDifferent(Node node) =>
      node.isWall != isWall ||
      node.x != x ||
      node.y != y ||
      node.isStart != isStart ||
      node.isVisited != isVisited ||
      node.isOnTraceablePathToGoal != isOnTraceablePathToGoal ||
      node.isGoalNode != isGoalNode;

  bool get isGoalNodeAndFound => isGoalNode && isOnTraceablePathToGoal;

  bool get isIdle =>
      !isGoalNode && !isVisited && !isWall && !isOnTraceablePathToGoal;

  void reset() {
    isGoalNode = false;
    isVisited = false;
    isWall = false;
    isStart = false;
    currentPathCost = double.infinity;
    isOnTraceablePathToGoal = false;
    cameFromNode = null;
  }

  void resetVisualAlgorithmSteps() {
    isVisited = false;
    currentPathCost = double.infinity;
    isOnTraceablePathToGoal = false;
    cameFromNode = null;
  }
}
