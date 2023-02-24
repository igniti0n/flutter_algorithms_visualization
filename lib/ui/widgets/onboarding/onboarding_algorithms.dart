// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:path_finding/notifiers/onboarding_page_state_notifier.dart';
// import 'package:path_finding/ui/common/blue_text_button.dart';
// import 'package:path_finding/ui/common/text/texts.dart';
// import 'package:path_finding/ui/common/text/unit_rounded_text.dart';

// class OnboardingAlgorithms extends ConsumerWidget {
//   const OnboardingAlgorithms({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return IntrinsicHeight(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: Column(
//               children: const [
//                 UnitRoundedText(
//                   'Algorithms',
//                   bold: true,
//                   fontSize: 22,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 UnitRoundedText(
//                   Texts.algorithms,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               BlueTextButton(
//                 text: 'Previous',
//                 onPressed: () => ref
//                     .read(onboardingPageStateNotifierProvider.notifier)
//                     .goToPreviousPage(),
//               ),
//               const SizedBox(
//                 width: 60,
//               ),
//               BlueTextButton(
//                 text: 'What\'s Dijkstra?',
//                 onPressed: () => ref
//                     .read(onboardingPageStateNotifierProvider.notifier)
//                     .goToNextPage(),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
