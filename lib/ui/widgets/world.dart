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
  List<Widget> squares = [];
  _WorldState();

  @override
  initState() {
    final availableHeightForSquares =
        window.outerHeight - minimumActionsPannelHeight;
    final numberOfSquaresThatFitHeight =
        (availableHeightForSquares / Square.size.toInt()).floor();

    final availableWidthForSquares = window.outerWidth;
    final numberOfSquaresThatFitWidth =
        (availableWidthForSquares / Square.size.toInt()).floor();

    ref.read(nodesStateNotifierProvider.notifier).init(
        numberOfNodesInRow: numberOfSquaresThatFitHeight,
        numberOfNodesInColumn: numberOfSquaresThatFitWidth);

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showCupertinoDialog(
          context: context, builder: (context) => const OnboardingDialog());
    });
    super.initState();
  }

  static const minimumActionsPannelHeight = Square.size * 2.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(
                child: RepaintBoundary(
                  child: Stack(
                    children: squares,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: _getActualPannelHeight(),
                child: const ActionsPanel(),
              ),
            ],
          ),
          const Pannel(),
        ],
      ),
    );
  }

  double _getActualPannelHeight() {
    final availableHeightForSquares =
        (window.outerHeight ?? 0).toDouble() - minimumActionsPannelHeight;
    final numberOfSquaresThatFitHeight =
        (availableHeightForSquares / Square.size.toInt()).floor();
    final actualHeightAbleToBeOccupiedBySquares =
        numberOfSquaresThatFitHeight * Square.size;
    final leftoverHeightFromSquares =
        availableHeightForSquares - actualHeightAbleToBeOccupiedBySquares;
    return minimumActionsPannelHeight + leftoverHeightFromSquares;
  }
}
