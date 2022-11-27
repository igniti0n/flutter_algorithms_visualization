import 'dart:math';

import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/dijkstras_algorithm.dart';

class DrunkAlgorithm extends DijkstraAlgorithm {
  DrunkAlgorithm({required super.onStepUpdate, super.nodesToStartWith});

  /// Evaluates the cost to go to the [Node], and updates it if cost is better then the already calculated one
  @override
  Future<void> visitNode(Node currentlyLookingNode, Node parentNode) async {
    var costToGoToNode = Random().nextDouble() * 10;
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
      (a, b) => (b.currentPathCost).compareTo(a.currentPathCost),
    );
  }
}
