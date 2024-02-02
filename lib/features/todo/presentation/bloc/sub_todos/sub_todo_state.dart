part of 'sub_todo_bloc.dart';

abstract class SubTodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubTodosLoading extends SubTodoState {}

class SubTodosLoaded extends SubTodoState {
  final List<TodoEntity> todos;
  final List<TodoEntity>? subtasks;
  final int activeCategory;

  SubTodosLoaded({required this.todos, this.subtasks, required this.activeCategory});

  @override
  List<Object?> get props => [todos, subtasks, activeCategory];
}
