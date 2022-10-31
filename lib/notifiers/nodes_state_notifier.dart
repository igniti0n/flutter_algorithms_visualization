import 'dart:async';

import 'package:path_finding/data/nodes_repository.dart';
import 'package:riverpod/riverpod.dart';

final nodesStateNotifierProvider =
    StateNotifierProvider<NodesNotifier, NodesArray>(
        (ref) => NodesNotifier(ref.read(nodesRepositoryProvider)));

class NodesNotifier extends StateNotifier<NodesArray> {
  final NodesRepository _nodesRepository;
  late final StreamSubscription _nodesUpdateSubscription;
  NodesNotifier(this._nodesRepository) : super([]) {
    state = _nodesRepository.allNodes;
    _nodesUpdateSubscription =
        _nodesRepository.nodesArrayUpdatestream.listen(_onNodesArrayUpdate);
    setWallAt(0, 0);
    resetAt(0, 0);
  }

  @override
  void dispose() {
    _nodesUpdateSubscription.cancel();
    super.dispose();
  }

  NodesArray getAllNodes() => _nodesRepository.allNodes;

  void _onNodesArrayUpdate(NodesArray updatedArray) {
    state = [];
    state = updatedArray;
  }

  Future<void> startAlgorihmAt(int x, int y) async =>
      _nodesRepository.startAlgorithAt(x, y);

  void setGoalAt(int x, int y) async => _nodesRepository.setGoalAt(x, y);

  void setWallAt(int x, int y) async => _nodesRepository.setWallAt(x, y);

  void resetAt(int x, int y) async => _nodesRepository.resetAt(x, y);

  void resetAll() async => _nodesRepository.resetAll();

  void resetAlgorithmToStart() async =>
      _nodesRepository.resetAlgorithmToStart();
}
