import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/selected_shortest_path_algorithm_state_notifier.dart';
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
      children: PathFindingAlgorithmType.values
          .map((type) => _SelectAlgorithmButton(pathFindingAlgorithmType: type))
          .toList(),
    );
  }
}

class _SelectAlgorithmButton extends ConsumerWidget {
  final PathFindingAlgorithmType pathFindingAlgorithmType;
  const _SelectAlgorithmButton({required this.pathFindingAlgorithmType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentlySelectedAlgorithm = ref.watch(selectedShortestPathAlgorithmStateNotifier);

    final isSelected = currentlySelectedAlgorithm == pathFindingAlgorithmType;

    return GestureDetector(
      onTap: () =>
          ref.read(selectedShortestPathAlgorithmStateNotifier.notifier).setSelectedAlgorithm(pathFindingAlgorithmType),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.actionSelected : AppColors.actionUnselected,
            border: isSelected
                ? Border.all(color: Colors.black87, width: 1.4)
                : Border.all(color: Colors.black38, width: 1.4),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: UnitRoundedText(
          pathFindingAlgorithmType.title,
          centerText: true,
          fontSize: 18,
        ),
      ),
    );
  }
}
