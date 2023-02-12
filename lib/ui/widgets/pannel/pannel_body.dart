import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/is_diagonal_movement_enabeld_state_provider.dart';
import 'package:path_finding/ui/colors.dart';
import 'package:path_finding/ui/widgets/pannel/algorithm_button_picker.dart';
import 'package:path_finding/ui/widgets/pannel/sliders.dart';

class PannelBody extends ConsumerWidget {
  static const double height = 180;
  const PannelBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.panelBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            SizedBox(width: 120),
            AlgorithmButtonPicker(),
            SizedBox(width: 24),
            _DiagonalCosts(),
            SizedBox(
              width: 10,
            ),
            HorizontalAndVerticalPathCostSlider(),
            SizedBox(
              width: 10,
            ),
            // AnimationTimeDelaySlider(),
          ],
        ),
      ),
    );
  }
}

class _DiagonalCosts extends ConsumerWidget {
  const _DiagonalCosts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDiagonalMovementEnabeld =
        ref.watch(isDiagonalMovementEnabelsStateProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          blendMode:
              isDiagonalMovementEnabeld ? BlendMode.dst : BlendMode.modulate,
          shaderCallback: (bounds) => ui.Gradient.linear(
            bounds.topRight,
            bounds.bottomRight,
            isDiagonalMovementEnabeld
                ? [Colors.transparent, Colors.transparent]
                : [Colors.grey[900]!, Colors.grey[900]!],
          ),
          child: const DiagonalPathCostSlider(),
        ),
        const SizedBox(
          height: 10,
        ),
        Checkbox(
          value: isDiagonalMovementEnabeld,
          onChanged: (newValue) => ref
              .read(isDiagonalMovementEnabelsStateProvider.notifier)
              .state = newValue ?? false,
        )
      ],
    );
  }
}
