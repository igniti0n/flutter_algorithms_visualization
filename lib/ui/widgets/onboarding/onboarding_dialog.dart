import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_finding/notifiers/onboarding_page_state_notifier.dart';
import 'package:path_finding/ui/widgets/onboarding/onboarding_a_star.dart';
import 'package:path_finding/ui/widgets/onboarding/onboarding_breadth_first_search.dart';
import 'package:path_finding/ui/widgets/onboarding/onboarding_controlls.dart';
import 'package:path_finding/ui/widgets/onboarding/onboarding_depth_first_search.dart';
import 'package:path_finding/ui/widgets/onboarding/onboarding_dijkstra.dart';
import 'package:path_finding/ui/widgets/onboarding/onboarding_welcome.dart';

class OnboardingDialog extends HookConsumerWidget {
  const OnboardingDialog({super.key});

  final pages = const [
    OnboardingWelcome(),
    OnboardingControlls(),
    OnboardingDijkstra(),
    OnboardingAstar(),
    OnboardingBreadthFirstSearch(),
    OnboardingDepthFirstSearch(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();

    ref.listen<int>(onboardingPageStateNotifierProvider, (_, nextPageIndex) {
      log('Changed to $nextPageIndex');
      pageController.animateToPage(nextPageIndex,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });

    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 600),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                itemBuilder: (context, index) => pages[index],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Transform.translate(
                offset: const Offset(6, -6),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 243, 243, 243),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    hoverColor: Colors.transparent,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
