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

final class StreamCourseIdChanged extends PlannerEvent {
  const StreamCourseIdChanged(this.courseId);

  final String courseId;

  @override
  List<Object> get props => [courseId];
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

final class SelectCell extends PlannerEvent {
  final List selectedCellIDs;

  const SelectCell({required this.selectedCellIDs});

  @override
  List<Object> get props => [selectedCellIDs];
}

final class FinalCellForCreateStream extends PlannerEvent {
  final List finalCellIDs;

  const FinalCellForCreateStream({required this.finalCellIDs});

  @override
  List<Object> get props => [finalCellIDs];
}

final class RemoveCell extends PlannerEvent {
  final List selectedCellIDs;

  const RemoveCell({required this.selectedCellIDs});

  @override
  List<Object> get props => [selectedCellIDs];
}

final class WrapWeekBoxHeightStream extends PlannerEvent {
  final int wrapWeekBoxHeight;

  const WrapWeekBoxHeightStream({required this.wrapWeekBoxHeight});

  @override
  List<Object> get props => [wrapWeekBoxHeight];
}

final class PlanningConfirmBtnStream extends PlannerEvent {
  final bool isPlanningConfirmBtn;

  const PlanningConfirmBtnStream({required this.isPlanningConfirmBtn});

  @override
  List<Object> get props => [isPlanningConfirmBtn];
}
