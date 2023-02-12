import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    return MouseRegion(
      onEnter: (event) => _onEnter(event, context),
      onExit: (event) => _onExit(event),
      child: GestureDetector(
        onPanDown: (_) => _onPanDown(context),
        onPanEnd: (details) => _onPanEnd(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _Body(
              node: node,
              color: _determineColor(node, isLearningModeOn),
            ),
            if (isLearningModeOn && !node.isWall)
              Align(
                alignment: Alignment.center,
                child: Text(
                  "${node.currentPathCost}",
                  style: const TextStyle(fontSize: 7, color: Colors.white),
                ),
              ),
            if (isLearningModeOn &&
                !node.isWall &&
                node.isCurrentlyBeingVisited)
              Container(
                width: Square.size,
                height: Square.size,
                decoration: BoxDecoration(
                    color: AppColors.idleColor.withOpacity(0.6),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.red.withOpacity(0.6), width: 2)),
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
    if (node.isGoalNode) {
      return Colors.transparent;
    }
    if (node.isWall) {
      return Colors.transparent;
    }
    if (node.isOnTraceablePathToGoal && !node.isGoalNode) {
      return const Color.fromARGB(243, 133, 49, 185);
    }
    if (node.isVisited) {
      return const Color.fromARGB(219, 64, 156, 255);
    }
    // Leagning mode disabeld currently
    if (isLearningModeOn) {
      if (node.isTopPriority) {
        return Colors.blue[800]!;
      }
      if (node.isInStack) {
        return Colors.orange;
      }
    }
    // if (node.isInStack) {
    //   return Colors.blue[800]!;
    // }

    return Colors.transparent;
  }
}

class _Body extends HookWidget {
  final Color color;
  const _Body({
    Key? key,
    required this.node,
    required this.color,
  }) : super(key: key);

  final Node node;

  @override
  Widget build(BuildContext context) {
    // final colorTween = ColorTween(begin: Colors.black, end: color);
    // final controler = useAnim
    // final animation = colorTween.animate

    return Container(
      width: Square.size,
      height: Square.size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColors.sliderColor, width: 0.2),
      ),
      alignment: Alignment.center,
      child: (node.isGoalNode || node.isStart)
          ? Container(
              color: color.withOpacity(0.7),
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
                duration: const Duration(milliseconds: 200),
                width: Square.size,
                height: Square.size,
                curve: Curves.easeOut,
                color: node.isWall ? null : color,
                decoration: !node.isWall
                    ? null
                    : BoxDecoration(
                        color: color.withOpacity(0.45),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                      ),
                child: (!node.isVisited)
                    ? null
                    : TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                            begin: Colors.deepPurpleAccent, end: color),
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 400),
                        builder: (_, value, __) => DecoratedBox(
                          decoration: BoxDecoration(color: value),
                        ),
                      ),
              ),
            ),
    );
  }
}
