import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'choice_of_course_event.dart';

part 'choice_of_course_state.dart';

class ChoiceOfCourseBloc extends Bloc<ChoiceOfCourseEvent, ChoiceOfCourseState> {
  ChoiceOfCourseBloc() : super(const ChoiceOfCourseState()) {
    on<CourseItemChanged>(_onCourseItemChanged);
  }

  void _onCourseItemChanged(
    CourseItemChanged event,
    Emitter<ChoiceOfCourseState> emit,
  ) {
    emit(state.copyWith(
      text: event.text,
      selectedIndex: event.selectedIndex,
      courseId: event.courseId,
      buttonIsActive: event.buttonIsActive,
    ));
  }
}
