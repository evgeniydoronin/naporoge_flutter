part of 'planner_builder_bloc.dart';

@immutable
class PlannerSelectDateRangeState extends Equatable {
  final DateTime startDate;

  const PlannerSelectDateRangeState({required this.startDate});

  PlannerSelectDateRangeState copyWith({
    DateTime? startDate,
  }) {
    return PlannerSelectDateRangeState(
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  List<Object?> get props => [startDate];
}
