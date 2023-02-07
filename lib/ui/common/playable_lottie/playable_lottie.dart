import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:path_finding/ui/common/playable_lottie/playable_lottie_asset.dart';
import 'package:path_finding/ui/common/playable_lottie/playable_lottie_state.dart';

final playableLottieStateNotifierProvider = StateNotifierProvider.family<
    PlayableLottieNotifier, PlayableLottieState, PlayableLottieAsset>(
  (ref, playableLottieAsset) => PlayableLottieNotifier(playableLottieAsset),
);

class PlayableLottieNotifier extends StateNotifier<PlayableLottieState> {
  final PlayableLottieAsset playableAsset;
  PlayableLottieNotifier(this.playableAsset)
      : super(PlayableLottieState.initial());

  void playForward() => state = PlayableLottieState.playForward();

  void playBackwards() => state = PlayableLottieState.playBackwards();

  void resetAnimation() => state = PlayableLottieState.reset();
}

class PlayableLottie extends HookConsumerWidget {
  final PlayableLottieAsset playableLottieAsset;
  final Function()? onTap;
  final List<Color> gradientColors;
  final bool isInitialValueAnimationEnd;
  final Duration? duration;
  const PlayableLottie({
    super.key,
    required this.playableLottieAsset,
    this.onTap,
    this.isInitialValueAnimationEnd = false,
    this.gradientColors = const [],
    this.duration,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AnimationController animationController = useAnimationController(
      initialValue: isInitialValueAnimationEnd ? 1.0 : 0,
      duration: duration ??
          const Duration(
            milliseconds: 1200,
          ),
    );
    final animation = useListenable(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    ref.listen<PlayableLottieState>(
        playableLottieStateNotifierProvider(playableLottieAsset),
        (previous, next) {
      next.whenOrNull(
        playForward: () => animationController.forward(),
        playBackwards: () => animationController.reverse(),
        reset: () => animationController.reset(),
      );
    });

    return GestureDetector(
      onTap: onTap,
      child: gradientColors.isEmpty
          ? Lottie.asset(
              playableLottieAsset.pathToAsset,
              width: 48,
              height: 48,
              controller: animation,
            )
          : ShaderMask(
              shaderCallback: (bounds) => ui.Gradient.linear(
                bounds.topLeft,
                bounds.bottomRight,
                gradientColors,
              ),
              child: Lottie.asset(
                playableLottieAsset.pathToAsset,
                width: 48,
                height: 48,
                controller: animation,
              ),
            ),
    );
  }
}
