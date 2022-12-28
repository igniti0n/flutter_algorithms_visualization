import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/data/nodes_repository.dart';

final animationTimeStateNotifierProvider =
    StateNotifierProvider<AnimationTimeNotifier, int>(
        (ref) => AnimationTimeNotifier(ref.read(nodesRepositoryProvider)));

class AnimationTimeNotifier extends StateNotifier<int> {
  final NodesRepository _nodesRepository;
  AnimationTimeNotifier(this._nodesRepository) : super(1350) {
    setAnimationTimeDelay(1350);
  }

  void setAnimationTimeDelay(int milliseconds) async {
    _nodesRepository.setAnimationTimeDelayTo(milliseconds: milliseconds);
    state = milliseconds;
  }
}
