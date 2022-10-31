import 'package:uuid/uuid.dart';

class Node {
  final String id = const Uuid().v4();
  final int x;
  final int y;
  bool isGoalNode;
  bool isOnTracablePathToGoal;
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
    this.isOnTracablePathToGoal = false,
  });

  void updateCostIfNecessary(double calculatedCost) {
    if (currentCost > calculatedCost) {
      currentCost = calculatedCost;
    }
  }

  Node copyWith(
          {bool? isGoalNode = false,
          int? x,
          int? y,
          bool? isVisited,
          bool? isOnTracablePathToGoal,
          bool? isWall,
          double? currentCost,
          Node? cameFromNode,
          required}) =>
      Node(
        x: x ?? this.x,
        y: y ?? this.y,
        isGoalNode: isGoalNode ?? this.isGoalNode,
        isVisited: isVisited ?? this.isVisited,
        isWall: isWall ?? this.isWall,
        currentCost: currentCost ?? this.currentCost,
        isOnTracablePathToGoal:
            isOnTracablePathToGoal ?? this.isOnTracablePathToGoal,
      );

  bool isDifferent(Node node) =>
      node.isWall != isWall ||
      node.x != x ||
      node.y != y ||
      node.isVisited != isVisited ||
      node.isOnTracablePathToGoal != isOnTracablePathToGoal ||
      node.isGoalNode != isGoalNode;

  void reset() {
    isGoalNode = false;
    isVisited = false;
    isWall = false;
    currentCost = double.infinity;
    isOnTracablePathToGoal = false;
  }

  void resetVisualAlgorithmSteps() {
    isVisited = false;
    currentCost = double.infinity;
    isOnTracablePathToGoal = false;
  }
}
