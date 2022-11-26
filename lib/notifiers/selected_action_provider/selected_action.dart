import 'package:freezed_annotation/freezed_annotation.dart';

part 'selected_action.freezed.dart';

@freezed
class SelectedAction with _$SelectedAction {
  const factory SelectedAction.idle() = Idle;
  const factory SelectedAction.makeWall() = MakeWall;
  const factory SelectedAction.makeGoalNode() = MakeGoalNode;
  const factory SelectedAction.doAlgorithm() = DoAlgorithm;
  const factory SelectedAction.reset() = ResetNode;
}
