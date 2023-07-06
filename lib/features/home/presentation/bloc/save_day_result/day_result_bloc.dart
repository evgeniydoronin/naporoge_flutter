import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'day_result_event.dart';

part 'day_result_state.dart';

class DayResultBloc extends Bloc<DayResultEvent, DayResultState> {
  DayResultBloc() : super(const DayResultState()) {
    on<CompletedTimeChanged>(_onCompletedTimeChanged);
    on<ExecutionScopeChanged>(_onExecutionScopeChanged);
    on<ResultOfTheDayChanged>(_onResultOfTheDayChanged);
    on<DesiresChanged>(_onDesiresChanged);
    on<ReluctanceChanged>(_onReluctanceChanged);
    on<InterferenceChanged>(_onInterferenceChanged);
    on<RejoiceChanged>(_onRejoiceChanged);
  }

  void _onCompletedTimeChanged(
    CompletedTimeChanged event,
    Emitter<DayResultState> emit,
  ) {
    final completedAt = event.completedAt;
    emit(state.copyWith(completedAt: completedAt));
  }

  void _onExecutionScopeChanged(
    ExecutionScopeChanged event,
    Emitter<DayResultState> emit,
  ) {
    final executionScope = event.executionScope;
    emit(state.copyWith(executionScope: executionScope));
  }

  void _onResultOfTheDayChanged(
    ResultOfTheDayChanged event,
    Emitter<DayResultState> emit,
  ) {
    final result = event.result;
    emit(state.copyWith(result: result));
  }

  void _onDesiresChanged(
    DesiresChanged event,
    Emitter<DayResultState> emit,
  ) {
    final desires = event.desires;
    emit(state.copyWith(desires: desires));
  }

  void _onReluctanceChanged(
    ReluctanceChanged event,
    Emitter<DayResultState> emit,
  ) {
    final reluctance = event.reluctance;
    emit(state.copyWith(reluctance: reluctance));
  }

  void _onInterferenceChanged(
    InterferenceChanged event,
    Emitter<DayResultState> emit,
  ) {
    final interference = event.interference;
    emit(state.copyWith(interference: interference));
  }

  void _onRejoiceChanged(
    RejoiceChanged event,
    Emitter<DayResultState> emit,
  ) {
    final rejoice = event.rejoice;
    emit(state.copyWith(rejoice: rejoice));
  }
}
