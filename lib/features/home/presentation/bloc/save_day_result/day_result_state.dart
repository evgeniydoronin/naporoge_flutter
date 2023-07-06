part of 'day_result_bloc.dart';

final class DayResultState extends Equatable {
  const DayResultState({
    this.dayId,
    this.completedAt,
    this.executionScope,
    this.result,
    this.desires = 'small',
    this.reluctance = 'small',
    this.interference,
    this.rejoice,
  });

  final int? dayId;
  final String? completedAt;
  final int? executionScope;
  final String? result;
  final String desires;
  final String reluctance;
  final String? interference;
  final String? rejoice;

  DayResultState copyWith({
    final int? dayId,
    final String? completedAt,
    final int? executionScope,
    final String? result,
    final String? desires,
    final String? reluctance,
    final String? interference,
    final String? rejoice,
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
      ];
}
