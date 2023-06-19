part of 'planner_builder_bloc.dart';

@immutable
abstract class PlannerBuilderEvent extends Equatable {
  const PlannerBuilderEvent();

  @override
  List<Object> get props => [];
}

class PlannerDataEvent extends PlannerBuilderEvent {
  final DateTime? startDate;
  final String? courseId;
  final String? courseTitle;
  final String? courseDescription;

  const PlannerDataEvent(
      {this.startDate,
      this.courseId,
      this.courseTitle,
      this.courseDescription});

  @override
  List<Object> get props => [];
}
