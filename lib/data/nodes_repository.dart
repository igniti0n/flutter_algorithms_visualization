import 'dart:async';

import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/dijkstra_algorithm.dart';
import 'package:path_finding/data/path_finding_algorithm.dart';
import 'package:riverpod/riverpod.dart';
import 'package:rxdart/subjects.dart';

typedef NodesArray = List<List<Node>>;

final nodesRepositoryProvider =
    Provider<NodesRepository>((ref) => NodesRepositoryImpl());

abstract class NodesRepository {
  static const numberOfNodesInRow = 60;
  NodesArray get allNodes;
  Stream<NodesArray> get nodesArrayUpdateStream;
  void startAlgorithmAt(int x, int y);
  void setGoalAt(int x, int y);
  void setWallAt(int x, int y);
  void resetAt(int x, int y);
  void resetAll();
  void resetAlgorithmToStart();
  void setDiagonalPathCostTo({required double cost});
  void setHorizontalAndVerticalPathCostTo({required double cost});
}

class NodesRepositoryImpl implements NodesRepository {
  late final PathFindingAlgorithm _pathFindingAlgorithm =
      DijkstraAlgorithm(onStepUpdate: (e) => _onStepUpdate(e));
  final PublishSubject<NodesArray> _subject = PublishSubject<NodesArray>();

  @override
  NodesArray get allNodes => _pathFindingAlgorithm.allNodes;
  @override
  Stream<NodesArray> get nodesArrayUpdateStream => _subject.stream;

  @override
  void startAlgorithmAt(int x, int y) async {
    _pathFindingAlgorithm.doAlgorithm(Node(x: x, y: y));
  }

  @override
  void setGoalAt(int x, int y) async {
    _pathFindingAlgorithm.resetAt(x, y);
    _pathFindingAlgorithm.setGoalAt(x, y);
  }

  @override
  void setWallAt(int x, int y) async {
    _pathFindingAlgorithm.resetAt(x, y);
    _pathFindingAlgorithm.setWallAt(x, y);
  }

  @override
  void resetAt(int x, int y) async => _pathFindingAlgorithm.resetAt(x, y);

  @override
  void resetAll() async => _pathFindingAlgorithm.resetAll();

  @override
  void resetAlgorithmToStart() async =>
      _pathFindingAlgorithm.resetAlgorithmToStart();

  @override
  void setDiagonalPathCostTo({required double cost}) =>
      _pathFindingAlgorithm.setDiagonalPathCostTo(cost: cost);

  @override
  void setHorizontalAndVerticalPathCostTo({required double cost}) =>
      _pathFindingAlgorithm.setHorizontalAndVerticalPathCostTo(cost: cost);

  void _onStepUpdate(NodesArray updatedArray) {
    _subject.add(updatedArray);
  }
}
