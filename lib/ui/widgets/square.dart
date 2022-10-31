import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/notifiers/nodes_state_notifier.dart';
import 'package:path_finding/notifiers/selected_action_provider/selected_action_provider.dart';
import 'package:path_finding/ui/colors.dart';

final nodeProvider =
    StateProvider.family<Node, NodeCoordinate>((ref, coordinates) {
  final nodes = ref.watch(nodesStateNotifierProvider);
  final node = nodes.elementAt(coordinates.x).elementAt(coordinates.y);
  final someNode = node.copyWith(
    x: node.x,
    y: node.y,
    isGoalNode: node.isGoalNode,
    isWall: node.isWall,
    isVisited: node.isVisited,
    isOnTracablePathToGoal: node.isOnTracablePathToGoal,
  );
  return someNode;
});

class NodeCoordinate {
  final int x;
  final int y;
  NodeCoordinate(this.x, this.y);
}

class Square extends ConsumerStatefulWidget {
  static const double size = 24;
  final int x;
  final int y;
  const Square({
    required this.x,
    required this.y,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SquareState createState() => _SquareState();
}

class _SquareState extends ConsumerState<Square> {
  Node node = Node(x: 0, y: 0);

  @override
  Widget build(BuildContext context) {
    ref.listen<Node>(nodeProvider(NodeCoordinate(widget.x, widget.y)),
        (_, updatedNode) {
      if (node.isDifferent(updatedNode)) {
        setState(() {
          node = updatedNode;
        });
      }
    });

    return MouseRegion(
      onEnter: (event) {
        if (event.down) {
          _callAction(ref, context);
        }
      },
      child: GestureDetector(
        onPanDown: (_) {
          _callAction(ref, context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            color: _determineColor(node),
            border: Border.all(color: Colors.black12),
          ),

          child: const SizedBox(
            width: Square.size,
            height: Square.size,
          ),
          //),
        ),
      ),
    );
  }

  void _callAction(WidgetRef ref, BuildContext ctx) {
    final selectedAction = ref.read(selectedActionProvider);
    final nodesNotifier = ref.read(nodesStateNotifierProvider.notifier);
    selectedAction.when(
        idle: () => _onIdleAction(ctx),
        makeWall: () => nodesNotifier.setWallAt(node.x, node.y),
        makeGoalNode: () => nodesNotifier.setGoalAt(node.x, node.y),
        doDijkstra: () => nodesNotifier.startAlgorihmAt(node.x, node.y),
        reset: () => nodesNotifier.resetAt(node.x, node.y));
  }

  void _onIdleAction(BuildContext ctx) {
    showCupertinoDialog(
      context: ctx,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Select one of the possible actions!'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close.'))
        ],
      ),
    );
  }

  Color _determineColor(Node node) {
    if (node.isOnTracablePathToGoal) {
      return AppColors.pathColor;
    } else if (node.isGoalNode) {
      return AppColors.goalColor;
    } else if (node.isWall) {
      return AppColors.wallColor;
    } else if (node.isVisited) {
      return AppColors.visitedColor;
    }
    return AppColors.idleColor;
  }
}
