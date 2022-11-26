import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/nodes_state_notifier.dart';
import 'package:path_finding/ui/colors.dart';

class ResetButtons extends ConsumerWidget {
  const ResetButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () =>
                ref.read(nodesStateNotifierProvider.notifier).resetAll(),
            child: const Icon(
              Icons.replay_outlined,
              size: 48,
              color: AppColors.sliderColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => ref
                .read(nodesStateNotifierProvider.notifier)
                .resetAlgorithmToStart(),
            child: const Icon(
              Icons.reply_rounded,
              size: 48,
              color: AppColors.sliderColor,
            ),
          ),
        ),
      ],
    );
  }
}
