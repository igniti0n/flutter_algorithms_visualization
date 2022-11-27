import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/common/utils.dart';
import 'package:path_finding/data/path_finding_algorithm.dart';

class AstarAlgorithm extends PathFindingAlgorithm {
  AstarAlgorithm({required super.onStepUpdate, super.nodesToStartWith});

  /// Evaluates the cost to go to the [Node], and updates it if cost is better then the already calculated one
  @override
  Future<void> visitNode(Node currentlyLookingNode, Node parentNode) async {
    // Calculate cost to go to node
    final isOnDiagonal = isNodeOnDiagonal(
        currentlyLookingNode: currentlyLookingNode, parentNode: parentNode);
    var costToGoToNode = parentNode.currentPathCost +
        (isOnDiagonal ? diagonalPathCost : horizontalAndVerticalPathCost);
    // caluclate distance to goal,  and save it in the node
    final distanceToGoalNode = calculateDistance(currentlyLookingNode.x,
        currentlyLookingNode.y, goalNode?.x ?? 0, goalNode?.y ?? 0);
    allNodes[currentlyLookingNode.x][currentlyLookingNode.y].distanceToGoal =
        distanceToGoalNode * 10;
    // only the path cost is being look for when moving to the node
    if (costToGoToNode < currentlyLookingNode.currentPathCost) {
      currentlyLookingNode.currentPathCost = costToGoToNode;
      currentlyLookingNode.cameFromNode = parentNode;
      nodesStack.add(currentlyLookingNode);
    }
  }

  @override
  void sortNodesStackAfterOneTurn(List<Node> nodesStack) {
    nodesStack.sort(
      (a, b) => (b.currentPathCost + b.distanceToGoal)
          .compareTo(a.currentPathCost + a.distanceToGoal),
    );
  }
}