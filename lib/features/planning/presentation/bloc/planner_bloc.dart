import 'package:flutter_bloc/flutter_bloc.dart';

part 'planner_event.dart';

part 'planner_state.dart';

class PlannerBloc extends Bloc<PlaningEvent, PlaningState> {
  PlannerBloc() : super(PlaningInitial()) {
    on<PlaningSelectRangeEvent>((event, emit) {
      emit(PlaningGetDateRange(event.startDate));
    });
  }
}
