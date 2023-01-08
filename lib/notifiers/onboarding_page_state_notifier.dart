import 'package:riverpod/riverpod.dart';

final onboardingPageStateNotifierProvider =
    StateNotifierProvider<OnboardingPageNotifier, int>(
        (ref) => OnboardingPageNotifier());

class OnboardingPageNotifier extends StateNotifier<int> {
  OnboardingPageNotifier() : super(0);

  void goToNextPage() => state = state + 1;

  void goToPreviousPage() => state = state - 1;
}
