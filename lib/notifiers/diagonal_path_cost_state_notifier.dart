import 'package:path_finding/data/nodes_repository.dart';
import 'package:riverpod/riverpod.dart';

final diagonalPathCostStateNotifierProvider =
    StateNotifierProvider<NodesNotifier, double>(
        (ref) => NodesNotifier(ref.read(nodesRepositoryProvider)));

class NodesNotifier extends StateNotifier<double> {
  final NodesRepository _nodesRepository;
  NodesNotifier(this._nodesRepository) : super(2);

  void setDiagonalCost(double cost) async {
    _nodesRepository.setDiagonalPathCostTo(cost: cost);
    state = cost;
  }
}
