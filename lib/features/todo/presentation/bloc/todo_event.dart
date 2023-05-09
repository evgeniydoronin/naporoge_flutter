part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTab extends TodoEvent {
  const ChangeTab();

  @override
  List<Object?> get props => [];
}
