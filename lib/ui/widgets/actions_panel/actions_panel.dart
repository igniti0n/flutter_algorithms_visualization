import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_finding/notifiers/is_learning_mode_on_state_provider.dart';
import 'package:path_finding/notifiers/nodes_state_notifier.dart';
import 'package:path_finding/notifiers/slected_shortest_path_algorithm_state_notifier.dart';
import 'package:path_finding/ui/common/playable_lottie/playable_lottie.dart';
import 'package:path_finding/ui/common/playable_lottie/playable_lottie_asset.dart';
import 'package:path_finding/ui/common/text/unit_rounded_text.dart';
import 'package:path_finding/ui/widgets/pannel/reset_buttons.dart';
import 'package:path_finding/ui/widgets/pannel/sliders.dart';
import 'package:url_launcher/url_launcher.dart';

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
          const Spacer(),
          const SizedBox(
            width: 20,
          ),

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
          const AnimationTimeDelaySlider(),
          const Spacer(),
          IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            onPressed: () => launchUrl(
              Uri.parse(
                'https://github.com/igniti0n/flutter_algorithms_visualization',
              ),
            ),
            icon: SvgPicture.asset(
              'assets/svg/github_logo.svg',
              height: 48,
              width: 48,
            ),
          ),
          const SizedBox(
            width: 40,
          ),
        ],
      ),
    );
  }
}

class _CurrentlySelectedAlgorithm extends ConsumerWidget {
  const _CurrentlySelectedAlgorithm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAlgorithm =
        ref.watch(selectedShortestPathAlgorithmStateNotifier);

    return SizedBox(
      width: 80,
      child: UnitRoundedText(
        centerText: false,
        selectedAlgorithm.title,
        color: Colors.white,
      ),
    );

    // PopupMenuButton<int>(
    //     // onSelected: (selectedAlgo) => ref
    //     //     .read(selectedShortestPathAlgorithmStateNotifier.notifier)
    //     //     .setSelectedAlgorithm(selectedAlgo),
    //     // initialValue: PathFindingAlgorihmType.dijkstras,
    //     itemBuilder: (ctx) => [
    //           PopupMenuItem<int>(
    //             value: 1,
    //             child: UnitRoundedText(
    //               selectedAlgorithm.title,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ]

    //     // PathFindingAlgorihmType.values
    //     //     .map(
    //     //       (e) => PopupMenuItem<PathFindingAlgorihmType>(
    //     //         value: e,
    //     //         child: UnitRoundedText(
    //     //           selectedAlgorithm.title,
    //     //           color: Colors.white,
    //     //         ),
    //     //       ),
    //     //     )
    //     //     .toList(),
    //     );
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
        const _CurrentlySelectedAlgorithm(),
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
        const SizedBox(
          width: 60,
        ),
        PlayableLottie(
          playableLottieAsset: PlayableLottieAsset.maze,
          duration: const Duration(seconds: 6),
          isInitialValueAnimationEnd: true,
          gradientColors: const [Colors.orangeAccent, Colors.red],
          onTap: () {
            ref
                .read(playableLottieStateNotifierProvider(
                        PlayableLottieAsset.maze)
                    .notifier)
                .resetAnimation();
            ref
                .read(playableLottieStateNotifierProvider(
                        PlayableLottieAsset.maze)
                    .notifier)
                .playForward();
            ref.read(nodesStateNotifierProvider.notifier).makeMaze();
          },
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
