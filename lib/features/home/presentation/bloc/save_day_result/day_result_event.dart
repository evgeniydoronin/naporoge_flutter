part of 'day_result_bloc.dart';

sealed class DayResultEvent extends Equatable {
  const DayResultEvent();

  @override
  List<Object> get props => [];
}

final class CompletedTimeChanged extends DayResultEvent {
  const CompletedTimeChanged(this.completedAt);

  final String completedAt;

  @override
  List<Object> get props => [completedAt];
}

final class ExecutionScopeChanged extends DayResultEvent {
  const ExecutionScopeChanged(this.executionScope);

  final int executionScope;

  @override
  List<Object> get props => [executionScope];
}

final class ResultOfTheDayChanged extends DayResultEvent {
  const ResultOfTheDayChanged(this.result);

  final String result;

  @override
  List<Object> get props => [result];
}

final class DesiresChanged extends DayResultEvent {
  const DesiresChanged(this.desires);

  final String desires;

  @override
  List<Object> get props => [desires];
}

final class ReluctanceChanged extends DayResultEvent {
  const ReluctanceChanged(this.reluctance);

  final String reluctance;

  @override
  List<Object> get props => [reluctance];
}

final class InterferenceChanged extends DayResultEvent {
  const InterferenceChanged(this.interference);

  final String interference;

  @override
  List<Object> get props => [interference];
}

final class RejoiceChanged extends DayResultEvent {
  const RejoiceChanged(this.rejoice);

  final String rejoice;

  @override
  List<Object> get props => [rejoice];
}

final class UntilMinuteCanChanged extends DayResultEvent {
  const UntilMinuteCanChanged(this.untilMinuteCan);

  final List<String> untilMinuteCan;

  @override
  List<Object> get props => [untilMinuteCan];
}
