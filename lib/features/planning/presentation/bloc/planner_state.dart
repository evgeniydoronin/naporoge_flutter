part of 'planner_bloc.dart';

final class PlannerState extends Equatable {
  const PlannerState({
    this.startDate = '',
    this.courseTitle = '',
    this.courseDescription = '',
    this.selectedCellIDs = const [],
  });

  final String startDate;
  final String courseTitle;
  final String courseDescription;
  final List<List> selectedCellIDs;

  PlannerState copyWith({
    String? startDate,
    String? courseTitle,
    String? courseDescription,
    List<List>? selectedCellIDs,
  }) {
    return PlannerState(
      startDate: startDate ?? this.startDate,
      courseTitle: courseTitle ?? this.courseTitle,
      courseDescription: courseDescription ?? this.courseDescription,
      selectedCellIDs: selectedCellIDs ?? this.selectedCellIDs,
    );
  }

  @override
  List<Object> get props =>
      [startDate, courseTitle, courseDescription, selectedCellIDs];
}
