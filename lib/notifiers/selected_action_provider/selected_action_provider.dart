import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/selected_action_provider/selected_action.dart';

final selectedActionProvider =
    StateProvider<SelectedAction>((ref) => const SelectedAction.idle());
