import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/notifiers/dragged_states_provider.dart';
import 'package:path_finding/notifiers/is_learning_mode_on_state_provider.dart';
import 'package:path_finding/notifiers/node_provider.dart';
import 'package:path_finding/notifiers/nodes_state_notifier.dart';
import 'package:path_finding/ui/colors.dart';
import 'package:path_finding/ui/common/playable_lottie/playable_lottie.dart';
import 'package:path_finding/ui/common/playable_lottie/playable_lottie_asset.dart';

class Square extends ConsumerStatefulWidget {
  static const double size = 30;
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
    final isLearningModeOn = ref.watch(isLearningModeOnStateProvider);

    ref.listen<Node>(nodeProvider(NodeCoordinate(widget.x, widget.y)),
        (_, updatedNode) {
      if (node.isDifferent(updatedNode)) {
        setState(() {
          node = updatedNode;
        });
        if (node.isGoalNodeAndFound) {
          ref
              .read(playableLottieStateNotifierProvider(
                      PlayableLottieAsset.goalFlag)
                  .notifier)
              .resetAnimation();
          ref
              .read(playableLottieStateNotifierProvider(
                      PlayableLottieAsset.goalFlag)
                  .notifier)
              .playForward();
        }
      }
    });

    log('Rebuilding a square.');

    return MouseRegion(
      onEnter: (event) => _onEnter(event, context),
      onExit: (event) => _onExit(event),
      child: GestureDetector(
        onPanDown: (_) => _onPanDown(context),
        onPanEnd: (details) => _onPanEnd(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: Square.size,
              height: Square.size,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.sliderColor, width: 0.2),
              ),
              alignment: Alignment.center,
              child: (node.isGoalNode || node.isStart)
                  ? Container(
                      color: _determineColor(node, isLearningModeOn)
                          .withOpacity(0.7),
                      padding: const EdgeInsets.all(1.5),
                      child: Stack(children: [
                        if (node.isGoalNode)
                          const PlayableLottie(
                            isInitialValueAnimationEnd: true,
                            playableLottieAsset: PlayableLottieAsset.goalFlag,
                            gradientColors: [
                              Colors.blue,
                              Colors.blue,
                            ],
                          ),
                        if (node.isStart)
                          SvgPicture.asset(
                            'assets/svg/play_button.svg',
                            color: Colors.deepOrangeAccent,
                          ),
                      ]),
                    )
                  : AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: node.isIdle ? 0 : 1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: Square.size,
                        height: Square.size,
                        curve: Curves.easeOut,
                        color: node.isWall
                            ? null
                            : _determineColor(node, isLearningModeOn),
                        decoration: !node.isWall
                            ? null
                            : BoxDecoration(
                                color: _determineColor(node, isLearningModeOn)
                                    .withOpacity(0.45),
                                shape: BoxShape.circle,
                              ),
                        child: node.isWall
                            ? SvgPicture.asset(
                                'assets/svg/brick.svg',
                                color: Colors.blueGrey.withOpacity(0.7),
                              )
                            : null,
                      ),
                    ),
            ),
            if (isLearningModeOn && !node.isWall)
              Align(
                alignment: Alignment.center,
                child: Text(
                  "${node.currentPathCost}",
                  style: const TextStyle(fontSize: 7, color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _onEnter(PointerEnterEvent event, BuildContext context) {
    if (event.down) {
      final isGoalDragged = ref.read(isGoalDraggedStateProvider);
      final isStartDragged = ref.read(isStartDraggedStateProvider);
      if (isGoalDragged) {
        ref.read(nodesStateNotifierProvider.notifier).setGoalAt(node.x, node.y);
      } else if (isStartDragged) {
        ref
            .read(nodesStateNotifierProvider.notifier)
            .setStartAt(node.x, node.y);
      } else {
        _toggleWall(ref, context);
      }
    }
  }

  void _onExit(PointerExitEvent event) {
    final isGoalDragged = ref.read(isGoalDraggedStateProvider);
    final isStartDragged = ref.read(isStartDraggedStateProvider);

    if (isGoalDragged && event.down) {
      ref
          .read(nodesStateNotifierProvider.notifier)
          .removeGoalAt(node.x, node.y);
    } else if (isStartDragged && event.down) {
      ref
          .read(nodesStateNotifierProvider.notifier)
          .removeStartAt(node.x, node.y);
    }
  }

  void _onPanEnd() {
    ref.read(isStartDraggedStateProvider.notifier).state = false;
    ref.read(isGoalDraggedStateProvider.notifier).state = false;
  }

  void _onPanDown(BuildContext context) {
    if (node.isGoalNode) {
      ref.read(isGoalDraggedStateProvider.notifier).state = true;
    } else if (node.isStart) {
      ref.read(isStartDraggedStateProvider.notifier).state = true;
    } else {
      _toggleWall(ref, context);
    }
  }

  void _toggleWall(WidgetRef ref, BuildContext ctx) {
    final nodesNotifier = ref.read(nodesStateNotifierProvider.notifier);
    if (node.isGoalNode || node.isStart) {
      return;
    }
    if (!node.isWall) {
      nodesNotifier.resetAt(node.x, node.y);
      nodesNotifier.setWallAt(node.x, node.y);
    } else {
      nodesNotifier.resetAt(node.x, node.y);
    }
  }

  Color _determineColor(Node node, bool isLearningModeOn) {
    if (node.isWall) {
      return Colors.transparent;
    }
    if (node.isOnTraceablePathToGoal && !node.isGoalNode) {
      return Colors.purple[800]!;
    }
    if (node.isVisited) {
      return Colors.blue[800]!;
    }
    if (isLearningModeOn) {
      if (node.isTopPriority) {
        return Colors.green[800]!;
      }
      if (node.isInStack) {
        return Colors.orange;
      }
    }

    return Colors.transparent;
  }
}
