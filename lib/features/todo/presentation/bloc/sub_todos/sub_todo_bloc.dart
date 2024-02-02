import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../../../domain/entities/todo_entity.dart';
import '../../../../../core/services/db_client/isar_service.dart';

part 'sub_todo_event.dart';

part 'sub_todo_state.dart';

class SubTodoBloc extends Bloc<SubTodoEvent, SubTodoState> {
  SubTodoBloc() : super(SubTodosLoading()) {
    on<SubLoadTodos>(_onSubLoadTodos);
    on<FilterSubTodos>(_onFilterSubTodos);
    on<GetSubTodosByParent>(_onGetSubTodosByParent);
    on<UpdateSubTodoOrder>(_onUpdateTodoOrder);
  }

  int _orderComparator(TodoEntity a, TodoEntity b) {
    // Элементы с null в order идут в конец списка
    if (a.order == null && b.order == null) return 0;
    if (a.order == null) return 1;
    if (b.order == null) return -1;
    return a.order!.compareTo(b.order!); // Сортировка от большего к меньшему
  }

  void _onSubLoadTodos(SubLoadTodos event, Emitter<SubTodoState> emit) async {
    // Использование данных
    final isarService = IsarService();
    final isar = await isarService.db;
    final todos = await isar.todoEntitys.where(sort: Sort.asc).findAll();
    todos.sort(_orderComparator);

    emit(SubTodosLoaded(todos: todos, subtasks: null, activeCategory: event.category));
  }

  void _onGetSubTodosByParent(GetSubTodosByParent event, Emitter<SubTodoState> emit) async {
    // Использование данных
    final isarService = IsarService();
    final isar = await isarService.db;
    final todos = await isar.todoEntitys.where().findAll();
    todos.sort(_orderComparator);

    emit(SubTodosLoaded(todos: todos, subtasks: null, activeCategory: event.parentId));
  }

  void _onFilterSubTodos(FilterSubTodos event, Emitter<SubTodoState> emit) async {
    // Использование данных
    final isarService = IsarService();
    final isar = await isarService.db;
    final filteredTodos = await isar.todoEntitys.filter().parentIdEqualTo(event.category).findAll();
    filteredTodos.sort(_orderComparator);

    emit(SubTodosLoaded(todos: filteredTodos, activeCategory: event.category));
  }

  void _onUpdateTodoOrder(UpdateSubTodoOrder event, Emitter<SubTodoState> emit) async {
    if (state is SubTodosLoaded) {
      final isarService = IsarService();
      final isar = await isarService.db;

      final currentState = state as SubTodosLoaded;
      final todos = List<TodoEntity>.from(currentState.todos.where((todo) => todo.parentId == event.parentId));
      final todo = todos.removeAt(event.oldIndex);
      todos.insert(event.newIndex, todo);
      // Обновление порядка в Isar
      await isar.writeTxn(() async {
        for (var i = 0; i < todos.length; i++) {
          todos[i].order = i;
          await isar.todoEntitys.put(todos[i]);
        }
      });
      emit(SubTodosLoaded(todos: todos, subtasks: null, activeCategory: currentState.activeCategory));
    }
  }
}
