import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/slected_shortest_path_algorithm_state_notifier.dart';
import 'package:path_finding/ui/colors.dart';
import 'package:path_finding/ui/common/text/unit_rounded_text.dart';

class AlgorithmButtonPicker extends StatelessWidget {
  const AlgorithmButtonPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      runSpacing: 8,
      spacing: 8,
      children: PathFindingAlgorihmType.values
          .map((type) => _SelectAlgorithmButton(pathFindingAlgorihmType: type))
          .toList(),
    );
  }
}

class _SelectAlgorithmButton extends ConsumerWidget {
  final PathFindingAlgorihmType pathFindingAlgorihmType;
  const _SelectAlgorithmButton({required this.pathFindingAlgorihmType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentlySelectedAlgotihm =
        ref.watch(selectedShortestPathAlgorithmStateNotifier);

    final isSelected = currentlySelectedAlgotihm == pathFindingAlgorihmType;

    return GestureDetector(
      onTap: () => ref
          .read(selectedShortestPathAlgorithmStateNotifier.notifier)
          .setSelectedAlgorithm(pathFindingAlgorihmType),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: isSelected
                ? AppColors.actionSelected
                : AppColors.actionUnselected,
            border: isSelected
                ? Border.all(color: Colors.black87, width: 1.4)
                : Border.all(color: Colors.black38, width: 1.4),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: UnitRoundedText(
          pathFindingAlgorihmType.title,
          centerText: true,
          fontSize: 18,
        ),
      ),
    );
  }
}
