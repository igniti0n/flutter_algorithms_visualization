import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/nodes_state_notifier.dart';
import 'package:path_finding/ui/widgets/actions_pannel/actions_pannel.dart';
import 'package:path_finding/ui/widgets/side_pannel/side_pannel.dart';
import 'package:path_finding/ui/widgets/square.dart';

class World extends ConsumerWidget {
  const World({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: squares,
          ),
          const ActionsPannel(),
          Positioned(
            top: 40,
            right: 40,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: const SidePannel(),
            ),
          ),
        ],
      ),
    );
  }
}
