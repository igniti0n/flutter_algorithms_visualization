import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/path_finding_algorithm.dart';

class DijkstraAlgorithm extends PathFindingAlgorithm
    implements ShortestPathAlgorithm {
  DijkstraAlgorithm({required super.onStepUpdate});

  /// Evaluates the cost to go to the [Node], and updates it if cost is better then the already calculated one
  @override
  Future<void> visitNode(Node currentlyLookingNode, Node parentNode) async {
    currentlyLookingNode.isVisited = true;
    final isOnDiagonal = (parentNode.x != currentlyLookingNode.x &&
        parentNode.y != currentlyLookingNode.y);
    var costToGoToNode = parentNode.currentCost +
        (isOnDiagonal ? diagonalPathCost : horizontalAndVerticalPathCost);
    if (costToGoToNode < currentlyLookingNode.currentCost) {
      currentlyLookingNode.currentCost = costToGoToNode;
      currentlyLookingNode.cameFromNode = parentNode;
      nodesStack.add(currentlyLookingNode);
    }
  }
}
