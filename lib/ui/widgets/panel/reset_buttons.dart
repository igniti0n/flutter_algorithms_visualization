import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/nodes_state_notifier.dart';
import 'package:path_finding/ui/colors.dart';
import 'package:path_finding/ui/common/playable_lottie/playable_lottie.dart';
import 'package:path_finding/ui/common/playable_lottie/playable_lottie_asset.dart';

class ResetButtons extends ConsumerWidget {
  const ResetButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Transform.translate(
            offset: const Offset(0, -10),
            child: Transform.scale(
              scale: 1.5,
              child: PlayableLottie(
                playableLottieAsset: PlayableLottieAsset.trashBin,
                gradientColors: [
                  Colors.orangeAccent.withOpacity(1),
                  Colors.blueGrey.withOpacity(1)
                ],
                onTap: () => _onDeleteAllTapped(ref),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 32,
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

  void _onDeleteAllTapped(WidgetRef ref) {
    ref
        .read(playableLottieStateNotifierProvider(PlayableLottieAsset.trashBin)
            .notifier)
        .resetAnimation();
    ref
        .read(playableLottieStateNotifierProvider(PlayableLottieAsset.trashBin)
            .notifier)
        .playForward();
    ref.read(nodesStateNotifierProvider.notifier).resetAll();
  }
}
