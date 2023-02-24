import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/nodes_state_notifier.dart';
import 'package:path_finding/ui/widgets/actions_panel/actions_panel.dart';
import 'package:path_finding/ui/widgets/onboarding/onboarding_dialog.dart';
import 'package:path_finding/ui/widgets/pannel/pannel.dart';
import 'package:path_finding/ui/widgets/square.dart';

class World extends ConsumerStatefulWidget {
  const World({super.key});

  @override
  ConsumerState<World> createState() => _WorldState();
}

class _WorldState extends ConsumerState<World> {
  static const minimumActionsPannelHeight = Square.size * 5;
  late double totalSquaesGridHeight;
  List<Widget> squares = [];
  int widowWidth = 0;
  int widowHeight = 0;

  @override
  initState() {
    _initGrid();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showCupertinoDialog(
          context: context, builder: (context) => const OnboardingDialog());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // // log('Window width: ${window.screen?.width}');
    // // log('inner width: ${window.innerWidth}');
    // final currentWidth = window.screen?.width;
    // final currentHeight = window.screen?.height;
    // if (widowHeight != currentWidth || widowHeight != currentHeight) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     log('Changed to $widowHeight - $widowWidth');
    //     setState(() {
    //       _initGrid();
    //       widowHeight = currentHeight ?? 0;
    //       widowWidth = currentWidth ?? 0;
    //     });
    //   });
    // }
    // return NotificationListener<SizeChangedLayoutNotification>(
    //   onNotification: (notification) {
    //     log('NOTIFIED! \n $notification');
    //     setState(() {
    //       _initGrid();
    //     });
    //     return false;
    //   },
    //   child:
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: totalSquaesGridHeight,
                width: double.infinity,
                child: RepaintBoundary(
                  child: Stack(
                    children: squares,
                  ),
                ),
              ),
              const Expanded(
                child: ActionsPanel(),
              ),
            ],
          ),
          const Pannel(),
        ],
      ),
      // ),
    );
  }

  void _initGrid() {
    squares.clear();
    final availableHeightForSquares =
        (window.screen?.height ?? 0) - minimumActionsPannelHeight;
    final numberOfSquaresThatFitHeight =
        (availableHeightForSquares / Square.size.toInt()).floor();
    totalSquaesGridHeight = numberOfSquaresThatFitHeight * Square.size;
    final availableWidthForSquares = (window.screen?.width ?? 0);
    final numberOfSquaresThatFitWidth =
        (availableWidthForSquares / Square.size.toInt()).floor();
    ref.read(nodesStateNotifierProvider.notifier).init(
        numberOfNodesInRow: numberOfSquaresThatFitWidth,
        numberOfNodesInColumn: numberOfSquaresThatFitHeight);
    ref.read(nodesStateNotifierProvider.notifier).setStartAt(4, 10);
    ref.read(nodesStateNotifierProvider.notifier).setGoalAt(10, 10);
    for (var row
        in ref.read(nodesStateNotifierProvider.notifier).getAllNodes()) {
      for (var node in row) {
        squares.add(Positioned(
          left: node.x * Square.size,
          top: node.y * Square.size,
          child: Square(
            x: node.x,
            y: node.y,
          ),
        ));
      }
    }
  }
}
