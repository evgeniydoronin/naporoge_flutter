part of 'planner_bloc.dart';

final class PlannerState extends Equatable {
  const PlannerState({
    this.startDate = '',
    this.courseId = '',
    this.courseTitle = '',
    this.courseDescription = '',
    this.selectedCellIDs = const [],
    this.finalCellIDs = const [],
    this.wrapWeekBoxHeight = 0,
  });

  final String startDate;
  final String courseId;
  final String courseTitle;
  final String courseDescription;
  final List selectedCellIDs;
  final List finalCellIDs;
  final double wrapWeekBoxHeight;

  PlannerState copyWith({
    String? startDate,
    String? courseId,
    String? courseTitle,
    String? courseDescription,
    List? selectedCellIDs,
    List? finalCellIDs,
    double? wrapWeekBoxHeight,
  }) {
    return PlannerState(
      startDate: startDate ?? this.startDate,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      courseDescription: courseDescription ?? this.courseDescription,
      selectedCellIDs: selectedCellIDs ?? this.selectedCellIDs,
      finalCellIDs: finalCellIDs ?? this.finalCellIDs,
      wrapWeekBoxHeight: wrapWeekBoxHeight ?? this.wrapWeekBoxHeight,
    );
  }

  @override
  List<Object> get props => [
        startDate,
        courseId,
        courseTitle,
        courseDescription,
        selectedCellIDs,
        finalCellIDs,
        wrapWeekBoxHeight
      ];
}
