import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:path_finding/notifiers/onboarding_page_state_notifier.dart';
import 'package:path_finding/ui/common/blue_text_button.dart';
import 'package:path_finding/ui/common/text/unit_rounded_text.dart';

class OnboardingWelcome extends ConsumerWidget {
  const OnboardingWelcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UnitRoundedText(
            'Welcome to the Path finding visualization with Flutter!',
            bold: true,
            fontSize: 22,
          ),
          Expanded(
            child: Lottie.asset(
              'assets/lotties/path_finding.json',
              height: 164,
            ),
          ),
          const UnitRoundedText(
            'Play arround with different ways to visualize path finding',
          ),
          const SizedBox(
            height: 20,
          ),
          BlueTextButton(
            text: 'Continue',
            onPressed: () => ref
                .read(onboardingPageStateNotifierProvider.notifier)
                .goToNextPage(),
          ),
        ],
      ),
    );
  }
}
