part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {
  final int category;

  LoadTodos(this.category);

  @override
  List<Object> get props => [category];
}

class FilterTodos extends TodoEvent {
  final int category;

  FilterTodos(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateTodoOrder extends TodoEvent {
  final int oldIndex;
  final int newIndex;

  UpdateTodoOrder(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}
