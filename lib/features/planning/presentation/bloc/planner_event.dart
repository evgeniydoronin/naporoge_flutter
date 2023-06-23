part of 'planner_bloc.dart';

sealed class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object> get props => [];
}

final class StreamStartDateChanged extends PlannerEvent {
  const StreamStartDateChanged(this.startDate);

  final String startDate;

  @override
  List<Object> get props => [startDate];
}

final class StreamCourseTitleChanged extends PlannerEvent {
  const StreamCourseTitleChanged(this.courseTitle);

  final String courseTitle;

  @override
  List<Object> get props => [courseTitle];
}

final class StreamCourseDescriptionChanged extends PlannerEvent {
  const StreamCourseDescriptionChanged(this.courseDescription);

  final String courseDescription;

  @override
  List<Object> get props => [courseDescription];
}
