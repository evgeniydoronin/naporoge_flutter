import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'diary_event.dart';

part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  DiaryBloc() : super(const DiaryState()) {
    on<DiaryLastNoteChanged>(_onDiaryLastNoteChanged);
    on<DiaryDayResultsChanged>(_onDiaryDayResultsChanged);
    on<DiaryMonthChanged>(_onDiaryMonthChanged);
  }

  void _onDiaryLastNoteChanged(
    DiaryLastNoteChanged event,
    Emitter<DiaryState> emit,
  ) {
    final lastNote = event.lastNote;
    emit(state.copyWith(lastNote: lastNote));
  }

  void _onDiaryDayResultsChanged(
    DiaryDayResultsChanged event,
    Emitter<DiaryState> emit,
  ) {
    final dayResults = event.dayResults;
    emit(state.copyWith(dayResults: dayResults));
  }

  void _onDiaryMonthChanged(
    DiaryMonthChanged event,
    Emitter<DiaryState> emit,
  ) {
    final currentMonth = event.currentMonth;
    emit(state.copyWith(currentMonth: currentMonth));
  }
}
