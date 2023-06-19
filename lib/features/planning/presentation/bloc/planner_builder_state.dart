part of 'planner_builder_bloc.dart';

abstract class PlannerState extends Equatable {}

class PlannerInitial extends PlannerState {
  @override
  List<Object?> get props => [];
}

@immutable
class PlannerDataState extends PlannerState {
  final DateTime startDate;
  final String courseId;
  final String courseTitle;
  final String? courseDescription;

  PlannerDataState(
    this.startDate,
    this.courseId,
    this.courseTitle,
    this.courseDescription,
  );

  PlannerDataState copyWith({
    DateTime? startDate,
    String? courseId,
    String? courseTitle,
    String? courseDescription,
  }) {
    return PlannerDataState(
      startDate ?? this.startDate,
      courseId ?? this.courseId,
      courseTitle ?? this.courseTitle,
      this.courseDescription,
    );
  }

  @override
  List<Object?> get props =>
      [startDate, courseId, courseTitle, courseDescription];
}
