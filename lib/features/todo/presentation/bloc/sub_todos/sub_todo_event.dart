part of 'sub_todo_bloc.dart';

abstract class SubTodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubLoadTodos extends SubTodoEvent {
  final int category;

  SubLoadTodos(this.category);

  @override
  List<Object> get props => [category];
}

class FilterSubTodos extends SubTodoEvent {
  final int category;

  FilterSubTodos(this.category);

  @override
  List<Object> get props => [category];
}

class GetSubTodosByParent extends SubTodoEvent {
  final int parentId;

  GetSubTodosByParent({required this.parentId});

  @override
  List<Object> get props => [parentId];
}

class UpdateSubTodoOrder extends SubTodoEvent {
  final int oldIndex;
  final int newIndex;
  final int parentId;

  UpdateSubTodoOrder(this.oldIndex, this.newIndex, this.parentId);

  @override
  List<Object> get props => [oldIndex, newIndex, parentId];
}
