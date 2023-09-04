part of 'diary_bloc.dart';

sealed class DiaryEvent extends Equatable {
  const DiaryEvent();

  @override
  List<Object> get props => [];
}

final class DiaryLastNoteChanged extends DiaryEvent {
  const DiaryLastNoteChanged(this.lastNote);

  final Map lastNote;

  @override
  List<Object> get props => [lastNote];
}

final class DiaryDayResultsChanged extends DiaryEvent {
  const DiaryDayResultsChanged(this.dayResults);

  final Map dayResults;

  @override
  List<Object> get props => [dayResults];
}

final class DiaryMonthChanged extends DiaryEvent {
  const DiaryMonthChanged(this.currentMonth);

  final Map currentMonth;

  @override
  List<Object> get props => [currentMonth];
}
