part of 'choice_of_course_bloc.dart';

sealed class ChoiceOfCourseEvent extends Equatable {
  const ChoiceOfCourseEvent();

  @override
  List<Object?> get props => [];
}

final class CourseItemChanged extends ChoiceOfCourseEvent {
  const CourseItemChanged({this.text, this.selectedIndex, this.courseId, this.buttonIsActive});

  final String? text;
  final int? selectedIndex;
  final String? courseId;
  final bool? buttonIsActive;

  @override
  List<Object?> get props => [text, selectedIndex, courseId, buttonIsActive];
}
