import 'package:flutter_bloc/flutter_bloc.dart';

part 'planner_event.dart';

part 'planner_state.dart';

class PlannerBloc extends Bloc<PlanningEvent, PlanningState> {
  PlannerBloc() : super(PlanningInitial()) {
    on<PlanningSelectRangeEvent>((event, emit) {
      emit(PlanningDateRangeState(event.startDate));
    });

    on<PlanningCaseEvent>((event, emit) {
      emit(PlanningCaseTitleState(event.caseId, event.caseTitle));
    });

    on<PlanningCaseDescriptionEvent>((event, emit) {
      emit(PlanningCaseDescriptionState(event.caseDescription));
    });
  }
}
