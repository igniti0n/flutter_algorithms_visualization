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
        _nodesRepository.nodesArrayUpdateStream.listen(_onNodesArrayUpdate);
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

  void init(
          {required int numberOfNodesInRow,
          required int numberOfNodesInColumn}) =>
      _nodesRepository.init(
          numberOfNodesInRow: numberOfNodesInRow,
          numberOfNodesInColumn: numberOfNodesInColumn);

  Future<void> startAlgorithmAt() async => _nodesRepository.startAlgorithmAt();

  Future<void> makeMaze() async => _nodesRepository.makeMaze();

  void setGoalAt(int x, int y) async => _nodesRepository.setGoalAt(x, y);

  void removeGoalAt(int x, int y) async => _nodesRepository.removeGoalAt(x, y);

  void setStartAt(int x, int y) async => _nodesRepository.setStartAt(x, y);

  void removeStartAt(int x, int y) async =>
      _nodesRepository.removeStartAt(x, y);

  void setWallAt(int x, int y) async => _nodesRepository.setWallAt(x, y);

  void resetAt(int x, int y) async => _nodesRepository.resetAt(x, y);

  void resetAll() async => _nodesRepository.resetAll();

  void resetAlgorithmToStart() async =>
      _nodesRepository.resetAlgorithmToStart();
}
