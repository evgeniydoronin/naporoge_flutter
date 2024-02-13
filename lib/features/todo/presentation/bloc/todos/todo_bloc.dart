import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../../../domain/entities/todo_entity.dart';
import '../../../../../core/services/db_client/isar_service.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<FilterTodos>(_onFilterTodos);
    on<UpdateTodoOrder>(_onUpdateTodoOrder);
  }

  int _orderComparator(TodoEntity a, TodoEntity b) {
    // Элементы с null в order идут в конец списка
    if (a.order == null && b.order == null) return 0;
    if (a.order == null) return 1;
    if (b.order == null) return -1;
    return a.order!.compareTo(b.order!); // Сортировка от большего к меньшему
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    // Использование данных
    final isarService = IsarService();
    final isar = await isarService.db;
    final todos = await isar.todoEntitys.where().findAll();
    todos.sort(_orderComparator);

    emit(TodosLoaded(todos: todos, subtasks: null, activeCategory: event.category)); // По умолчанию, категория 1
  }

  void _onFilterTodos(FilterTodos event, Emitter<TodoState> emit) async {
    // Использование данных
    final isarService = IsarService();
    final isar = await isarService.db;
    final filteredTodos = await isar.todoEntitys.filter().categoryEqualTo(event.category).parentIdIsNull().findAll();
    filteredTodos.sort(_orderComparator);
    final subtasks = await isar.todoEntitys.filter().parentIdIsNotNull().findAll();
    emit(TodosLoaded(todos: filteredTodos, subtasks: subtasks, activeCategory: event.category));
  }

  void _onUpdateTodoOrder(UpdateTodoOrder event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      final isarService = IsarService();
      final isar = await isarService.db;

      final currentState = state as TodosLoaded;
      final todos = List<TodoEntity>.from(currentState.todos);
      // final todo = todos.removeAt(event.oldIndex);
      // todos.insert(event.newIndex, todo);
      // Обновление порядка в Isar
      await isar.writeTxn(() async {
        for (var i = 0; i < todos.length; i++) {
          todos[i].order = i;
          await isar.todoEntitys.put(todos[i]);
        }
      });
      // final subtasks = await isar.todoEntitys.filter().parentIdIsNotNull().findAll();

      // emit(TodosLoaded(todos: todos, subtasks: subtasks, activeCategory: currentState.activeCategory));
    }
  }
}
