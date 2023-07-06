import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_screen_event.dart';

part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(const HomeScreenState()) {
    on<TopMessageChanged>(_onTopMessageChanged);
  }

  void _onTopMessageChanged(
    TopMessageChanged event,
    Emitter<HomeScreenState> emit,
  ) {
    final message = event.message;
    emit(state.copyWith(message: message));
  }
}
