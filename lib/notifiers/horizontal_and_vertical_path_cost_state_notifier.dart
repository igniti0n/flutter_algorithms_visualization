import 'package:path_finding/data/nodes_repository.dart';
import 'package:riverpod/riverpod.dart';

final horizontalAndVerticalPathCostStateNotifierProvider =
    StateNotifierProvider<NodesNotifier, double>(
        (ref) => NodesNotifier(ref.read(nodesRepositoryProvider)));

class NodesNotifier extends StateNotifier<double> {
  final NodesRepository _nodesRepository;
  NodesNotifier(this._nodesRepository) : super(1);

  void setHorizontalPathCost(double cost) async {
    _nodesRepository.setHorizontalAndVerticalPathCostTo(cost: cost);
    state = cost;
  }
}
