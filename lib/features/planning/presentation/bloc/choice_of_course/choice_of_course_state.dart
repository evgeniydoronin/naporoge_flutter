part of 'choice_of_course_bloc.dart';

final class ChoiceOfCourseState extends Equatable {
  final String text;
  final int selectedIndex;
  final String courseId;
  final bool buttonIsActive;

  const ChoiceOfCourseState({
    this.text = '',
    this.selectedIndex = -1,
    this.courseId = '',
    this.buttonIsActive = false,
  });

  ChoiceOfCourseState copyWith({
    String? text,
    int? selectedIndex,
    String? courseId,
    bool? buttonIsActive,
  }) {
    return ChoiceOfCourseState(
      text: text ?? this.text,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      courseId: courseId ?? this.courseId,
      buttonIsActive: buttonIsActive ?? this.buttonIsActive,
    );
  }

  @override
  List<Object?> get props => [text, selectedIndex, courseId, buttonIsActive];
}
