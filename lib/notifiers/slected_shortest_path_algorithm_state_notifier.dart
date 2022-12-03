import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/data/nodes_repository.dart';

final selectedShortestPathAlgorithmStateNotifier = StateNotifierProvider<
    SelectedShortestPathAlgorithmNotifier, PathFindingAlgorihmType>((ref) {
  return SelectedShortestPathAlgorithmNotifier(
      ref.read(nodesRepositoryProvider));
});

class SelectedShortestPathAlgorithmNotifier
    extends StateNotifier<PathFindingAlgorihmType> {
  final NodesRepository _nodesRepository;
  SelectedShortestPathAlgorithmNotifier(this._nodesRepository)
      : super(PathFindingAlgorihmType.dijkstras);

  void setSelectedAlgorithm(PathFindingAlgorihmType type) {
    _nodesRepository.setCurrentlySelectedAlgotihmTo(
        pathFindingAlgorihmType: type);
    state = type;
  }
}

enum PathFindingAlgorihmType { dijkstras, astar, dfs, drunk }

extension AlgorithmProperties on PathFindingAlgorihmType {
  static final _name = {
    PathFindingAlgorihmType.dijkstras: 'Dijkstras',
    PathFindingAlgorihmType.astar: 'A*',
    PathFindingAlgorihmType.dfs: 'DFS',
    PathFindingAlgorihmType.drunk: 'Drunk',
  };

  String get title => _name[this]!;
}
