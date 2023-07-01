part of 'home_screen_bloc.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

final class TopMessageChanged extends HomeScreenEvent {
  const TopMessageChanged(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class WeekDayIndexChanged extends HomeScreenEvent {
  const WeekDayIndexChanged(this.weekDayIndex);

  final int weekDayIndex;

  @override
  List<Object> get props => [weekDayIndex];
}

final class StreamProgressChanged extends HomeScreenEvent {
  const StreamProgressChanged(this.streamProgress);

  final Map streamProgress;

  @override
  List<Object> get props => [streamProgress];
}
