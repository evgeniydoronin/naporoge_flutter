part of 'planner_bloc.dart';

final class PlannerState extends Equatable {
  const PlannerState({
    this.startDate = '',
    this.courseTitle = '',
    this.courseDescription = '',
  });

  final String startDate;
  final String courseTitle;
  final String courseDescription;

  PlannerState copyWith({
    String? startDate,
    String? courseTitle,
    String? courseDescription,
  }) {
    return PlannerState(
      startDate: startDate ?? this.startDate,
      courseTitle: courseTitle ?? this.courseTitle,
      courseDescription: courseDescription ?? this.courseDescription,
    );
  }

  @override
  List<Object> get props => [startDate, courseTitle, courseDescription];
}
