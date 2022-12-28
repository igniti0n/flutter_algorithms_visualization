import 'package:freezed_annotation/freezed_annotation.dart';

part 'playable_lottie_state.freezed.dart';

@freezed
abstract class PlayableLottieState with _$PlayableLottieState {
  factory PlayableLottieState.initial() = _PlayableLottieInitial;
  factory PlayableLottieState.playForward() = _PlayableLottiePlay;
  factory PlayableLottieState.playBackwards() = _PlayableLottieRewind;
  factory PlayableLottieState.reset() = _PlayableLottieReset;
}
