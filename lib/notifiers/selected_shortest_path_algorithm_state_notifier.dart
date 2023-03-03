import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/data/nodes_repository.dart';
import 'package:path_finding/notifiers/animation_time_state_notifier.dart';

final selectedShortestPathAlgorithmStateNotifier =
    StateNotifierProvider<SelectedShortestPathAlgorithmNotifier, PathFindingAlgorithmType>((ref) {
  return SelectedShortestPathAlgorithmNotifier(
    ref.read(nodesRepositoryProvider),
    ref,
  );
});

class SelectedShortestPathAlgorithmNotifier extends StateNotifier<PathFindingAlgorithmType> {
  final NodesRepository _nodesRepository;
  final Ref _ref;
  SelectedShortestPathAlgorithmNotifier(this._nodesRepository, this._ref) : super(PathFindingAlgorithmType.dijkstras);

  void setSelectedAlgorithm(PathFindingAlgorithmType type) {
    _nodesRepository.setCurrentlySelectedAlgorithmTo(
      pathFindingAlgorithmType: type,
      animationTimeDelay: _ref.read(animationTimeStateNotifierProvider),
    );
    state = type;
  }
}

enum PathFindingAlgorithmType { dijkstras, astar, drunk, dfs, bfs }

extension AlgorithmProperties on PathFindingAlgorithmType {
  static final _name = {
    PathFindingAlgorithmType.dijkstras: 'Dijkstras',
    PathFindingAlgorithmType.astar: 'A*',
    PathFindingAlgorithmType.dfs: 'DFS',
    PathFindingAlgorithmType.drunk: 'Drunk',
    PathFindingAlgorithmType.bfs: 'BFS',
  };

  String get title => _name[this]!;
}
