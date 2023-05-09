import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<ChangeTab>(_changeTabs);
  }

  Future<void> _changeTabs(
    ChangeTab event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.changeTab());
  }
}
