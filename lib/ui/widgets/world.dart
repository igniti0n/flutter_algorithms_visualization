import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/nodes_state_notifier.dart';
import 'package:path_finding/ui/colors.dart';
import 'package:path_finding/ui/widgets/actions_panel/actions_panel.dart';
import 'package:path_finding/ui/widgets/pannel/pannel.dart';
import 'package:path_finding/ui/widgets/square.dart';

class World extends ConsumerStatefulWidget {
  const World({super.key});

  @override
  ConsumerState<World> createState() => _WorldState();
}

class _WorldState extends ConsumerState<World> {
  _WorldState();

  @override
  initState() {
    log('initi start-goal setup.');
    ref.read(nodesStateNotifierProvider.notifier).setStartAt(10, 20);
    ref.read(nodesStateNotifierProvider.notifier).setGoalAt(20, 20);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> squares = [];

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

    return Scaffold(
      backgroundColor: AppColors.idleColor.withOpacity(0),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: squares,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: Square.size * 2.5),
                child: const ActionsPanel(),
              ),
            ],
          ),
          const Pannel(),
        ],
      ),
    );
  }
}
