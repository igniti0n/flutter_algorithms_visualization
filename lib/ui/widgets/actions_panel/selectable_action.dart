import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/selected_action_provider/selected_action.dart';
import 'package:path_finding/notifiers/selected_action_provider/selected_action_provider.dart';
import 'package:path_finding/notifiers/slected_shortest_path_algorithm_state_notifier.dart';
import 'package:path_finding/ui/colors.dart';

class SelectableAction extends ConsumerWidget {
  final SelectedAction action;
  const SelectableAction({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAction = ref.watch(selectedActionProvider);
    final selectedAlgorithm =
        ref.watch(selectedShortestPathAlgorithmStateNotifier);
    final isCurrentActionSelected = selectedAction == action;

    return GestureDetector(
      onTap: () => ref.read(selectedActionProvider.notifier).state = action,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrentActionSelected
              ? AppColors.actionSelected
              : AppColors.actionUnselected,
          border: Border.all(
            color: Colors.black87,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  color: _resolveColorFor(action),
                  border: Border.all(
                    color: Colors.black87,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: const SizedBox(
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              _resolveTextFor(action, selectedAlgorithm.title),
            ),
            const SizedBox(
              width: 4,
            ),
          ],
        ),
      ),
    );
  }

  String _resolveTextFor(
          SelectedAction action, String selectedAlgorithmTitle) =>
      action.when(
        idle: () => '',
        makeWall: () => 'Wall',
        makeGoalNode: () => 'Goal',
        doAlgorithm: () => 'Start $selectedAlgorithmTitle',
        reset: () => 'Delete',
      );

  Color _resolveColorFor(SelectedAction action) => action.when(
        idle: () => AppColors.idleColor,
        makeWall: () => AppColors.wallColor,
        makeGoalNode: () => AppColors.goalColor,
        doAlgorithm: () => AppColors.pathColor,
        reset: () => AppColors.idleColor,
      );
}
