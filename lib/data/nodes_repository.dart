import 'dart:async';

import 'package:path_finding/common/models/node.dart';
import 'package:path_finding/data/astar_algorithm.dart';
import 'package:path_finding/data/breadth_first_search.dart';
import 'package:path_finding/data/depth_first_search.dart';
import 'package:path_finding/data/dijkstras_algorithm.dart';
import 'package:path_finding/data/drunk_algorithm.dart';
import 'package:path_finding/data/visualize_algorithm.dart';
import 'package:path_finding/notifiers/selected_shortest_path_algorithm_state_notifier.dart';
import 'package:riverpod/riverpod.dart';
import 'package:rxdart/subjects.dart';

typedef NodesArray = List<List<Node>>;

final nodesRepositoryProvider = Provider<NodesRepository>((ref) => NodesRepositoryImpl());

abstract class NodesRepository {
  static const numberOfNodesInRow = 60;
  static const numberOfNodesInColumn = 35;

  NodesArray get allNodes;
  Stream<NodesArray> get nodesArrayUpdateStream;
  void init({required int numberOfNodesInRow, required int numberOfNodesInColumn});
  void startAlgorithmAt();
  void makeMaze();
  void setGoalAt(int x, int y);
  void setStartAt(int x, int y);
  void removeGoalAt(int x, int y);
  void removeStartAt(int x, int y);
  void setWallAt(int x, int y);
  void setIsDiagonalMovementEnabled({required bool toValue});
  void resetAt(int x, int y);
  void resetAll();
  void resetAlgorithmToStart();
  void setDiagonalPathCostTo({required double cost});
  void setHorizontalAndVerticalPathCostTo({required double cost});
  void setAnimationTimeDelayTo({required int milliseconds});
  void setCurrentlySelectedAlgorithmTo(
      {required PathFindingAlgorithmType pathFindingAlgorithmType, required int animationTimeDelay});
}

class NodesRepositoryImpl implements NodesRepository {
  late VisualizeAlgorithm _pathFindingAlgorithm = DijkstraAlgorithm(onStepUpdate: (e) => _onStepUpdate(e));
  final PublishSubject<NodesArray> _subject = PublishSubject<NodesArray>();

  @override
  NodesArray get allNodes => _pathFindingAlgorithm.allNodes;

  @override
  Stream<NodesArray> get nodesArrayUpdateStream => _subject.stream;

  @override
  void init({required int numberOfNodesInRow, required int numberOfNodesInColumn}) async {
    _pathFindingAlgorithm.initSetup(
      onStepUpdate: _onStepUpdate,
      numberOfNodesInRow: numberOfNodesInRow,
      numberOfNodesInColumn: numberOfNodesInColumn,
    );
  }

  @override
  void startAlgorithmAt() async {
    _pathFindingAlgorithm.runAlgorithm();
  }

  @override
  void makeMaze() async {
    _pathFindingAlgorithm.makeMaze();
  }

  @override
  void setGoalAt(int x, int y) => _pathFindingAlgorithm.setGoalAt(x, y);

  @override
  void removeGoalAt(int x, int y) => _pathFindingAlgorithm.removeGoalAt(x, y);

  @override
  void setStartAt(int x, int y) => _pathFindingAlgorithm.setStartAt(x, y);

  @override
  void removeStartAt(int x, int y) => _pathFindingAlgorithm.removeStartAt(x, y);

  @override
  void setWallAt(int x, int y) async {
    _pathFindingAlgorithm.resetAt(x, y);
    _pathFindingAlgorithm.setWallAt(x, y);
  }

  @override
  void setAnimationTimeDelayTo({required int milliseconds}) =>
      _pathFindingAlgorithm.setAnimationTimeDelayTo(microseconds: milliseconds);
  @override
  void resetAt(int x, int y) async => _pathFindingAlgorithm.resetAt(x, y);

  @override
  void resetAll() async => _pathFindingAlgorithm.resetAll();

  @override
  void resetAlgorithmToStart() async => _pathFindingAlgorithm.resetAlgorithmToStart();

  @override
  void setDiagonalPathCostTo({required double cost}) => _pathFindingAlgorithm.setDiagonalPathCostTo(cost: cost);

  @override
  void setHorizontalAndVerticalPathCostTo({required double cost}) =>
      _pathFindingAlgorithm.setHorizontalAndVerticalPathCostTo(cost: cost);

  void _onStepUpdate(NodesArray updatedArray) {
    _subject.add(updatedArray);
  }

  @override
  void setCurrentlySelectedAlgorithmTo(
      {required PathFindingAlgorithmType pathFindingAlgorithmType, required int animationTimeDelay}) {
    final goalNode = _pathFindingAlgorithm.goalNode;
    final startNode = _pathFindingAlgorithm.startNode;
    final isDiagonalMovementEnabled = _pathFindingAlgorithm.isDiagonalMovementEnabled;
    switch (pathFindingAlgorithmType) {
      case PathFindingAlgorithmType.dijkstras:
        _pathFindingAlgorithm = DijkstraAlgorithm(
          onStepUpdate: _onStepUpdate,
          nodesToStartWith: _pathFindingAlgorithm.allNodes,
        );
        break;

      case PathFindingAlgorithmType.astar:
        _pathFindingAlgorithm = AstarAlgorithm(
          onStepUpdate: _onStepUpdate,
          nodesToStartWith: _pathFindingAlgorithm.allNodes,
        );
        break;

      case PathFindingAlgorithmType.drunk:
        _pathFindingAlgorithm = DrunkAlgorithm(
          onStepUpdate: _onStepUpdate,
          nodesToStartWith: _pathFindingAlgorithm.allNodes,
        );
        break;

      case PathFindingAlgorithmType.dfs:
        _pathFindingAlgorithm = DepthFirstSearch(
          onStepUpdate: _onStepUpdate,
          nodesToStartWith: _pathFindingAlgorithm.allNodes,
        );
        break;
      case PathFindingAlgorithmType.bfs:
        _pathFindingAlgorithm = BreadthFirstSearch(
          onStepUpdate: _onStepUpdate,
          nodesToStartWith: _pathFindingAlgorithm.allNodes,
        );
        break;
    }
    _pathFindingAlgorithm.goalNode = goalNode;
    _pathFindingAlgorithm.startNode = startNode;
    _pathFindingAlgorithm.isDiagonalMovementEnabled = isDiagonalMovementEnabled;
    setAnimationTimeDelayTo(milliseconds: animationTimeDelay);
  }

  @override
  void setIsDiagonalMovementEnabled({required bool toValue}) =>
      _pathFindingAlgorithm.setIsDiagonalMovementEnabled(toValue: toValue);
}
