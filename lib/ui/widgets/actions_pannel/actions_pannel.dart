import 'package:flutter/material.dart';
import 'package:path_finding/notifiers/selected_action_provider/selected_action.dart';
import 'package:path_finding/ui/widgets/actions_pannel/selectable_action.dart';

class ActionsPannel extends StatelessWidget {
  const ActionsPannel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SelectableAction(
            action: SelectedAction.makeWall(),
          ),
          SizedBox(
            width: 40,
          ),
          SelectableAction(
            action: SelectedAction.makeGoalNode(),
          ),
          SizedBox(
            width: 40,
          ),
          SelectableAction(
            action: SelectedAction.doDijkstra(),
          ),
          SizedBox(
            width: 40,
          ),
          SelectableAction(
            action: SelectedAction.reset(),
          )
        ],
      ),
    );
  }
}
