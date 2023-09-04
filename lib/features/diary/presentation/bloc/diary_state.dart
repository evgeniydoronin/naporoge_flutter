part of 'diary_bloc.dart';

final class DiaryState extends Equatable {
  const DiaryState({
    this.lastNote = const {},
    this.dayResults = const {},
    this.currentMonth = const {},
  });

  final Map lastNote;
  final Map dayResults;
  final Map currentMonth;

  DiaryState copyWith({
    Map? lastNote,
    Map? dayResults,
    Map? currentMonth,
  }) {
    return DiaryState(
      lastNote: lastNote ?? this.lastNote,
      dayResults: dayResults ?? this.dayResults,
      currentMonth: currentMonth ?? this.currentMonth,
    );
  }

  @override
  List<Object> get props => [lastNote, dayResults, currentMonth];
}
