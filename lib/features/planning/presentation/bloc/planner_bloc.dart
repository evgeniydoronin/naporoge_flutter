import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'planner_event.dart';

part 'planner_state.dart';

class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  PlannerBloc() : super(const PlannerState()) {
    on<StreamStartDateChanged>(_onStreamStartDateChanged);
    on<StreamCourseIdChanged>(_onCourseIdChanged);
    on<StreamCourseTitleChanged>(_onCourseTitleChanged);
    on<StreamCourseDescriptionChanged>(_onCourseDescriptionChanged);
    on<SelectCell>(_onAddOrUpdateCell);
    on<RemoveCell>(_onRemoveCell);
    on<FinalCellForCreateStream>(_onFinalCell);
  }

  void _onStreamStartDateChanged(
    StreamStartDateChanged event,
    Emitter<PlannerState> emit,
  ) {
    final startDate = event.startDate;
    emit(state.copyWith(startDate: startDate));
  }

  void _onCourseIdChanged(
    StreamCourseIdChanged event,
    Emitter<PlannerState> emit,
  ) {
    final courseId = event.courseId;
    emit(state.copyWith(courseId: courseId));
  }

  void _onCourseTitleChanged(
    StreamCourseTitleChanged event,
    Emitter<PlannerState> emit,
  ) {
    final courseTitle = event.courseTitle;
    emit(state.copyWith(courseTitle: courseTitle));
  }

  void _onCourseDescriptionChanged(
    StreamCourseDescriptionChanged event,
    Emitter<PlannerState> emit,
  ) {
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

  void _onFinalCell(
      FinalCellForCreateStream event, Emitter<PlannerState> emit) {
    emit(state.copyWith(finalCellIDs: event.finalCellIDs));
  }

  void _onRemoveCell(RemoveCell event, Emitter<PlannerState> emit) {
    // List newCellsList = event.selectedCellIDs;
    // print('RemoveCell');
    // print(state.selectedCellIDs);
    emit(state.copyWith(selectedCellIDs: []));
  }
}
