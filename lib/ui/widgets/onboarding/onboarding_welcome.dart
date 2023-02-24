import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:path_finding/notifiers/onboarding_page_state_notifier.dart';
import 'package:path_finding/ui/common/blue_text_button.dart';
import 'package:path_finding/ui/common/text/fonts.dart';
import 'package:path_finding/ui/common/text/unit_rounded_text.dart';
import 'package:url_launcher/url_launcher.dart';

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
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: UnitRoundedText(
              'Play arround with different ways to visualize path finding, I hope you enjoy it as much as I did making it :D',
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: UnitRoundedText(
              'Learn some info by clicking through this modal, or press the \'X\' to close at any time you wish.',
            ),
          ),
          RichText(
            text: TextSpan(
              style: unitRoundedTextStyle,
              text: 'If you want to see the code, take a look at my ',
              children: [
                TextSpan(
                  text: 'github.',
                  style: unitRoundedTextStyle.copyWith(
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrl(
                          Uri.parse(
                            'https://github.com/igniti0n/flutter_algorithms_visualization',
                          ),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Lottie.asset(
                'assets/lotties/path_finding.json',
                height: 164,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
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
