import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'planner_event.dart';

part 'planner_state.dart';

class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  PlannerBloc() : super(const PlannerState()) {
    on<StreamStartDateChanged>(_onStreamStartDateChanged);
    on<StreamCourseTitleChanged>(_onCourseTitleChanged);
    on<StreamCourseDescriptionChanged>(_onCourseDescriptionChanged);
  }

  void _onStreamStartDateChanged(StreamStartDateChanged event,
      Emitter<PlannerState> emit,) {
    final startDate = event.startDate;
    emit(
      state.copyWith(
        startDate: startDate,
      ),
    );
  }

  void _onCourseTitleChanged(StreamCourseTitleChanged event,
      Emitter<PlannerState> emit,) {
    final courseTitle = event.courseTitle;
    emit(
      state.copyWith(
        courseTitle: courseTitle,
      ),
    );
  }

  void _onCourseDescriptionChanged(StreamCourseDescriptionChanged event,
      Emitter<PlannerState> emit,) {
    final courseDescription = event.courseDescription;
    emit(
      state.copyWith(
        courseDescription: courseDescription,
      ),
    );
  }
}
