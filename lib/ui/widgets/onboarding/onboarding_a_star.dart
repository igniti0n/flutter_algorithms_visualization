import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/onboarding_page_state_notifier.dart';
import 'package:path_finding/ui/common/blue_text_button.dart';
import 'package:path_finding/ui/common/text/texts.dart';
import 'package:path_finding/ui/common/text/unit_rounded_text.dart';
import 'package:path_finding/ui/widgets/url_launcable_title.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingAstar extends ConsumerWidget {
  const OnboardingAstar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UrlLaunchableTitle(
            text: 'A* algorithm',
            onPressed: () => launchUrl(
                Uri.parse('https://www.youtube.com/watch?v=ySN5Wnu88nE')),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Image.asset(
              "assets/a_star.gif",
            ),
          ),
          const UnitRoundedText(
            Texts.aStarExplenation,
          ),
          const SizedBox(
            height: 20,
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
                text: 'BFS & DFS?',
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
