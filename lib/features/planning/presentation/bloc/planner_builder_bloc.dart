import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'planner_builder_event.dart';

part 'planner_builder_state.dart';

class PlannerBuilderBloc
    extends Bloc<PlannerBuilderEvent, PlannerSelectDateRangeState> {
  PlannerBuilderBloc()
      : super(PlannerSelectDateRangeState(startDate: DateTime.now())) {
    on<PlannerSelectDateRangeEvent>(_onStreamTitleChanged);
  }

  void _onStreamTitleChanged(PlannerSelectDateRangeEvent event,
      Emitter<PlannerSelectDateRangeState> emit) {
    emit(
      state.copyWith(
        startDate: event.startDate,
      ),
    );
  }
}
