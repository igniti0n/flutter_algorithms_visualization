import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/data/nodes_repository.dart';
import 'package:path_finding/notifiers/animation_time_state_notifier.dart';

final selectedShortestPathAlgorithmStateNotifier = StateNotifierProvider<
    SelectedShortestPathAlgorithmNotifier, PathFindingAlgorihmType>((ref) {
  return SelectedShortestPathAlgorithmNotifier(
    ref.read(nodesRepositoryProvider),
    ref,
  );
});

class SelectedShortestPathAlgorithmNotifier
    extends StateNotifier<PathFindingAlgorihmType> {
  final NodesRepository _nodesRepository;
  final Ref _ref;
  SelectedShortestPathAlgorithmNotifier(this._nodesRepository, this._ref)
      : super(PathFindingAlgorihmType.dijkstras);

  void setSelectedAlgorithm(PathFindingAlgorihmType type) {
    _nodesRepository.setCurrentlySelectedAlgotihmTo(
      pathFindingAlgorihmType: type,
      animationTimeDelay: _ref.read(animationTimeStateNotifierProvider),
    );
    state = type;
  }
}

enum PathFindingAlgorihmType { dijkstras, astar, drunk, dfs, bfs }

extension AlgorithmProperties on PathFindingAlgorihmType {
  static final _name = {
    PathFindingAlgorihmType.dijkstras: 'Dijkstras',
    PathFindingAlgorihmType.astar: 'A*',
    PathFindingAlgorihmType.dfs: 'DFS',
    PathFindingAlgorihmType.drunk: 'Drunk',
    PathFindingAlgorihmType.bfs: 'BFS',
  };

  String get title => _name[this]!;
}
