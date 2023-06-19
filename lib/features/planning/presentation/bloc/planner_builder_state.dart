part of 'planner_builder_bloc.dart';

abstract class PlannerState extends Equatable {}

class PlannerInitial extends PlannerState {
  @override
  List<Object?> get props => [];
}

@immutable
class PlannerSelectDateRangeState extends PlannerState {
  final DateTime startDate;

  PlannerSelectDateRangeState(this.startDate);

  @override
  List<Object?> get props => [startDate];
}
