import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'planner_builder_event.dart';

part 'planner_builder_state.dart';

class PlannerBuilderBloc extends Bloc<PlannerBuilderEvent, PlannerState> {
  PlannerBuilderBloc() : super(PlannerInitial()) {
    on<PlannerSelectDateRangeEvent>((event, emit) {
      emit(PlannerSelectDateRangeState(event.startDate));
    });
  }
}
