import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'planner_event.dart';

part 'planner_state.dart';

class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  PlannerBloc() : super(const PlannerState()) {
    on<StreamStartDateChanged>(_onStreamStartDateChanged);
    on<StreamCourseIdChanged>(_onCourseIdChanged);
    on<StreamCourseTitleChanged>(_onCourseTitleChanged);
    on<StreamCourseDescriptionChanged>(_onCourseDescriptionChanged);
    on<StreamCourseWeeksChanged>(_onCourseWeeksChanged);
    on<SelectCell>(_onAddOrUpdateCell);
    on<RemoveCell>(_onRemoveCell);
    on<FinalCellForCreateStream>(_onFinalCell);
    on<WrapWeekBoxHeightStream>(_onWrapWeekBoxHeight);
    on<NextStreamWeeksStreamChanged>(_onNextStreamWeeks);
    on<PlanningConfirmBtnStream>(_onPlanningConfirmBtnStream);
    on<EditableWeekStream>(_onEditableWeekStream);
  }

  void _onStreamStartDateChanged(StreamStartDateChanged event,
      Emitter<PlannerState> emit,) {
    final startDate = event.startDate;
    emit(state.copyWith(startDate: startDate));
  }

  void _onCourseIdChanged(StreamCourseIdChanged event,
      Emitter<PlannerState> emit,) {
    final courseId = event.courseId;
    emit(state.copyWith(courseId: courseId));
  }

  void _onCourseTitleChanged(StreamCourseTitleChanged event,
      Emitter<PlannerState> emit,) {
    final courseTitle = event.courseTitle;
    emit(state.copyWith(courseTitle: courseTitle));
  }

  void _onCourseWeeksChanged(StreamCourseWeeksChanged event,
      Emitter<PlannerState> emit,) {
    final courseWeeks = event.courseWeeks;
    emit(state.copyWith(courseWeeks: courseWeeks));
  }

  void _onWrapWeekBoxHeight(WrapWeekBoxHeightStream event,
      Emitter<PlannerState> emit,) {
    final wrapWeekBoxHeight = event.wrapWeekBoxHeight;
    emit(state.copyWith(wrapWeekBoxHeight: wrapWeekBoxHeight));
  }

  void _onNextStreamWeeks(NextStreamWeeksStreamChanged event,
      Emitter<PlannerState> emit,) {
    final nextStreamWeeks = event.nextStreamWeeks;
    emit(state.copyWith(nextStreamWeeks: nextStreamWeeks));
  }

  void _onCourseDescriptionChanged(StreamCourseDescriptionChanged event,
      Emitter<PlannerState> emit,) {
    final courseDescription = event.courseDescription;
    emit(state.copyWith(courseDescription: courseDescription));
  }

  void _onAddOrUpdateCell(SelectCell event, Emitter<PlannerState> emit) {
    // print('SelectCell');
    List newCellsList = event.selectedCellIDs;
    // print('event.selectedCellIDs: $newCellsList');

    if (state.selectedCellIDs.isNotEmpty) {
      // print(state.selectedCellIDs);

      newCellsList.addAll(state.selectedCellIDs);
      // print('event.selectedCellIDs');
      // print(event.selectedCellIDs);
      // print('event.selectedCellIDs');
    }
    // print('SelectCell');
    emit(state.copyWith(selectedCellIDs: newCellsList));
  }

  void _onFinalCell(FinalCellForCreateStream event, Emitter<PlannerState> emit) {
    emit(state.copyWith(finalCellIDs: event.finalCellIDs));
  }

  void _onRemoveCell(RemoveCell event, Emitter<PlannerState> emit) {
    // List newCellsList = event.selectedCellIDs;
    // print('RemoveCell');
    // print(state.selectedCellIDs);
    emit(state.copyWith(selectedCellIDs: []));
  }

  void _onPlanningConfirmBtnStream(PlanningConfirmBtnStream event, Emitter<PlannerState> emit) {
    final isPlanningConfirmBtn = event.isPlanningConfirmBtn;
    emit(state.copyWith(isPlanningConfirmBtn: isPlanningConfirmBtn));
  }

  void _onEditableWeekStream(EditableWeekStream event, Emitter<PlannerState> emit) {
    final editableWeekData = event.editableWeekData;
    emit(state.copyWith(editableWeekData: editableWeekData));
  }
}
