import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/common/utils.dart';
import 'package:path_finding/data/dijkstras_algorithm.dart';

class AstarAlgorithm extends DijkstraAlgorithm {
  AstarAlgorithm({required super.onStepUpdate, super.nodesToStartWith});

  @override
  Future<void> visitNode(Node currentlyLookingNode, Node parentNode) async {
    // Calculate cost to go to node
    final isOnDiagonal = isNodeOnDiagonal(
        currentlyLookingNode: currentlyLookingNode, parentNode: parentNode);
    var costToGoToNode = parentNode.currentPathCost +
        (isOnDiagonal ? diagonalPathCost : horizontalAndVerticalPathCost);
    // caluclate distance to goal,  and save it in the node
    final distanceToGoalNode = calculateDistance(
        currentlyLookingNode.x, currentlyLookingNode.y, goalNode.x, goalNode.y);
    allNodes[currentlyLookingNode.x][currentlyLookingNode.y].distanceToGoal =
        distanceToGoalNode * 10;
    // only the path cost is being looked for when moving to the node
    if (costToGoToNode < currentlyLookingNode.currentPathCost) {
      currentlyLookingNode.currentPathCost = costToGoToNode;
      currentlyLookingNode.cameFromNode = parentNode;
      nodesStack.add(currentlyLookingNode);
    }
  }

  // distance to goal is taken into account when prioritizing what node to look at next
  @override
  void sortNodesStackAfterOneTurn(List<Node> nodesStack) {
    nodesStack.sort(
      (a, b) => (b.currentPathCost + b.distanceToGoal)
          .compareTo(a.currentPathCost + a.distanceToGoal),
    );
  }
}
