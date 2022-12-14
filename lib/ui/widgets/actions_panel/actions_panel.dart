import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_finding/notifiers/is_learning_mode_on_state_provider.dart';
import 'package:path_finding/notifiers/nodes_state_notifier.dart';
import 'package:path_finding/ui/common/text/unit_rounded_text.dart';
import 'package:path_finding/ui/widgets/pannel/reset_buttons.dart';

class ActionsPanel extends StatelessWidget {
  static const double actionsSize = 24;
  final selectedColor = Colors.orangeAccent;
  final unselectedColor = Colors.blueGrey;

  const ActionsPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 20,
          ),
          const ResetButtons(),
          const Spacer(),
          _MainActions(
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            actionsSize: actionsSize,
          ),
          const SizedBox(
            width: 100,
          ),
          const Spacer(),
          // TODO: - Too laggy for the web release when learning mode
          // const _LearningModeSwitch(),
          // const Spacer(),
        ],
      ),
    );
  }
}

class _MainActions extends ConsumerWidget {
  const _MainActions({
    Key? key,
    required this.selectedColor,
    required this.unselectedColor,
    required this.actionsSize,
  }) : super(key: key);

  final MaterialAccentColor selectedColor;
  final MaterialColor unselectedColor;
  final double actionsSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            ref
                .read(nodesStateNotifierProvider.notifier)
                .resetAlgorithmToStart();
            ref.read(nodesStateNotifierProvider.notifier).startAlgorithmAt();
          },
          child: SvgPicture.asset(
            'assets/svg/play_button.svg',
            color: selectedColor,
            height: actionsSize * 2.6,
            width: actionsSize * 2.6,
          ),
        ),
        // const AnimationTimeDelaySlider(),
      ],
    );
  }
}

class _LearningModeSwitch extends ConsumerWidget {
  const _LearningModeSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLearningModeOn = ref.watch(isLearningModeOnStateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UnitRoundedText(
          'Learning mode',
          color: Colors.white.withOpacity(0.85),
        ),
        Switch.adaptive(
          value: isLearningModeOn,
          onChanged: (newValue) =>
              ref.read(isLearningModeOnStateProvider.notifier).state = newValue,
        ),
      ],
    );
  }
}
