part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodosLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<TodoEntity> todos;
  final List<TodoEntity>? subtasks;
  final int activeCategory;

  TodosLoaded({required this.todos, this.subtasks, required this.activeCategory});

  @override
  List<Object?> get props => [todos, subtasks, activeCategory];
}
