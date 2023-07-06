part of 'home_screen_bloc.dart';

final class HomeScreenState extends Equatable {
  const HomeScreenState({
    this.message,
  });

  final String? message;

  HomeScreenState copyWith({
    final String? message,
  }) {
    return HomeScreenState(
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        message ?? '',
      ];
}
