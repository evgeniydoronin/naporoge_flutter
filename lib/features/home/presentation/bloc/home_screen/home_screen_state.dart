part of 'home_screen_bloc.dart';

final class HomeScreenState extends Equatable {
  const HomeScreenState({
    this.message,
    this.weekDayIndex,
    this.streamProgress,
  });

  final String? message;
  final int? weekDayIndex;
  final Map? streamProgress;

  HomeScreenState copyWith({
    final String? message,
    final int? weekDayIndex,
    final Map? streamProgress,
  }) {
    return HomeScreenState(
      message: message ?? this.message,
      weekDayIndex: weekDayIndex ?? this.weekDayIndex,
      streamProgress: streamProgress ?? this.streamProgress,
    );
  }

  @override
  List<Object> get props => [
        message ?? '',
        weekDayIndex ?? 100,
        streamProgress ?? {},
      ];
}
