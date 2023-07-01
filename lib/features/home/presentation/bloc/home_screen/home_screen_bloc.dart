import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_screen_event.dart';

part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(const HomeScreenState()) {
    on<TopMessageChanged>(_onTopMessageChanged);
    on<WeekDayIndexChanged>(_onWeekDayIndexChanged);
    on<StreamProgressChanged>(_onStreamProgressChanged);
  }

  void _onTopMessageChanged(
    TopMessageChanged event,
    Emitter<HomeScreenState> emit,
  ) {
    final message = event.message;
    emit(state.copyWith(message: message));
  }

  void _onWeekDayIndexChanged(
    WeekDayIndexChanged event,
    Emitter<HomeScreenState> emit,
  ) {
    final weekDayIndex = event.weekDayIndex;
    emit(state.copyWith(weekDayIndex: weekDayIndex));
  }

  void _onStreamProgressChanged(
    StreamProgressChanged event,
    Emitter<HomeScreenState> emit,
  ) {
    final streamProgress = event.streamProgress;
    emit(state.copyWith(streamProgress: streamProgress));
  }
}
