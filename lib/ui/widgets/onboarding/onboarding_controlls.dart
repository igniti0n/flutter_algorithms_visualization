import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/onboarding_page_state_notifier.dart';
import 'package:path_finding/ui/common/blue_text_button.dart';
import 'package:path_finding/ui/common/text/unit_rounded_text.dart';

class OnboardingControlls extends ConsumerWidget {
  const OnboardingControlls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Column(
        children: [
          const UnitRoundedText(
            'Controlls',
            bold: true,
            fontSize: 22,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _TextWithImage(
                  text: 'Choose what algorithm you wanna use :)',
                  imagePath: 'assets/images/algorithm_choosing.png',
                ),
                _TextWithImage(
                  text:
                      'Control costs of horizontal & diagonal movement, turn on/off diagonal movement.',
                  imagePath: 'assets/images/cost_controlls.png',
                ),
                _TextWithImage(
                  text: 'Slow down time to see the algorithm work better 🪄',
                  imagePath: 'assets/images/time_controll.png',
                ),
                _TextWithImage(
                  text:
                      'Delete all with the trash can, or reset the algorithm to start.',
                  imagePath: 'assets/images/delete_reset.png',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlueTextButton(
                text: 'Previous',
                onPressed: () => ref
                    .read(onboardingPageStateNotifierProvider.notifier)
                    .goToPreviousPage(),
              ),
              const SizedBox(
                width: 60,
              ),
              BlueTextButton(
                text: 'How algorithms work?',
                onPressed: () => ref
                    .read(onboardingPageStateNotifierProvider.notifier)
                    .goToNextPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TextWithImage extends StatelessWidget {
  final String text;
  final String imagePath;
  const _TextWithImage({
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: UnitRoundedText(
            text,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Image.asset(
          imagePath,
          height: 64,
        ),
        const SizedBox(
          width: 12,
        ),
      ],
    );
  }
}
