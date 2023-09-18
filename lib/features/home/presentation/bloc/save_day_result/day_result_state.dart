part of 'day_result_bloc.dart';

final class DayResultState extends Equatable {
  const DayResultState({
    this.dayId,
    this.completedAt,
    this.executionScope = 0,
    this.result,
    this.desires,
    this.reluctance,
    this.interference,
    this.rejoice,
    this.untilMinuteCan,
  });

  final int? dayId;
  final String? completedAt;
  final int? executionScope;
  final String? result;
  final String? desires;
  final String? reluctance;
  final String? interference;
  final String? rejoice;
  final List<String>? untilMinuteCan;

  DayResultState copyWith({
    final int? dayId,
    final String? completedAt,
    final int? executionScope,
    final String? result,
    final String? desires,
    final String? reluctance,
    final String? interference,
    final String? rejoice,
    final List<String>? untilMinuteCan,
  }) {
    return DayResultState(
      dayId: dayId ?? this.dayId,
      completedAt: completedAt ?? this.completedAt,
      executionScope: executionScope ?? this.executionScope,
      desires: desires ?? this.desires,
      reluctance: reluctance ?? this.reluctance,
      result: result ?? this.result,
      interference: interference ?? this.interference,
      rejoice: rejoice ?? this.rejoice,
      untilMinuteCan: untilMinuteCan ?? this.untilMinuteCan,
    );
  }

  @override
  List<Object> get props => [
        dayId ?? 0,
        completedAt ?? '',
        executionScope ?? '',
        desires ?? '',
        reluctance ?? '',
        result ?? '',
        interference ?? '',
        rejoice ?? '',
        untilMinuteCan ?? '',
      ];
}
