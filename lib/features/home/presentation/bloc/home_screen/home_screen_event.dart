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
