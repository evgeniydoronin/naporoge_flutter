part of 'planner_builder_bloc.dart';

@immutable
abstract class PlannerBuilderEvent extends Equatable {
  const PlannerBuilderEvent();

  @override
  List<Object> get props => [];
}

class PlannerSelectDateRangeEvent extends PlannerBuilderEvent {
  final DateTime startDate;

  const PlannerSelectDateRangeEvent({required this.startDate});

  @override
  List<Object> get props => [startDate];
}
