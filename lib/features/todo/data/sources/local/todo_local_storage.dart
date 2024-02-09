import 'package:isar/isar.dart';

import '../../../../../core/services/db_client/isar_service.dart';
import '../../../domain/entities/todo_entity.dart';

class TodoLocal {
  final isarService = IsarService();

  /// Create
  Future<void> createTodoLocal(TodoEntity todo) async {
    final isar = await isarService.db;

    final todoLocal = TodoEntity()
      ..id = todo.id
      ..title = todo.title
      ..category = todo.category
      ..order = todo.order
      ..isChecked = todo.isChecked
      ..parentId = todo.parentId;

    isar.writeTxnSync(() async {
      isar.todoEntitys.putSync(todoLocal);
    });
  }

  /// Read
  Future<List<TodoEntity>> getTodosLocal(int catId) async {
    final isar = await isarService.db;
    List<TodoEntity>? todos = await isar.todoEntitys.filter().categoryEqualTo(catId).findAll();
    print('catId: $catId');
    print('todos: $todos');

    return todos;
  }

  /// Update
  Future updateTodoLocal(TodoEntity todo) async {
    final isar = await isarService.db;

    final _todo = await isar.todoEntitys.get(todo.id!);

    isar.writeTxnSync(() async {
      if (todo.title != null) {
        _todo!.title = todo.title;
      }
      if (todo.category != null) {
        _todo!.category = todo.category;
      }
      if (todo.isChecked != null) {
        _todo!.isChecked = todo.isChecked;
      }
      isar.todoEntitys.putSync(_todo!);
    });
  }

  /// Delete
  Future<void> deleteTodoLocal(Map todos) async {
    final isar = await isarService.db;
    final todo = await isar.todoEntitys.get(todos["todo"]["id"]);
    List rawSubTodos = todos["subTodos"];

    List<int>? subTodos = rawSubTodos.map((e) => e['id']).cast<int>().toList();

    await isar.writeTxn(() async {
      await isar.todoEntitys.delete(todo!.id!);
      if (subTodos.isNotEmpty) {
        await isar.todoEntitys.deleteAll(subTodos);
      }
    });
  }
}
