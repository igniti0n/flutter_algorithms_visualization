import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/onboarding_page_state_notifier.dart';
import 'package:path_finding/ui/common/blue_text_button.dart';
import 'package:path_finding/ui/common/text/texts.dart';
import 'package:path_finding/ui/common/text/unit_rounded_text.dart';
import 'package:path_finding/ui/widgets/url_launcable_title.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingDepthFirstSearch extends ConsumerWidget {
  const OnboardingDepthFirstSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UrlLaunchableTitle(
            text: 'Depth-first search',
            onPressed: () => launchUrl(
                Uri.parse('https://en.wikipedia.org/wiki/Depth-first_search')),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Image.asset(
              "assets/dfs.gif",
            ),
          ),
          const UnitRoundedText(
            Texts.depthFirstExplenation,
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
                text: 'Got it!',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
