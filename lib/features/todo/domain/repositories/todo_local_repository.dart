import '../../data/sources/local/todo_local_storage.dart';
import '../entities/todo_entity.dart';

class TodoLocalRepository {
  final TodoLocal todoLocal;

  TodoLocalRepository(this.todoLocal);

  Future createTodoRequested(TodoEntity todo) async {
    try {
      return await todoLocal.createTodoLocal(todo);
    } catch (e) {
      rethrow;
    }
  }

  Future updateTodoRequested(TodoEntity todo) async {
    try {
      return await todoLocal.updateTodoLocal(todo);
    } catch (e) {
      rethrow;
    }
  }

  Future deleteTodoRequested(Map todos) async {
    try {
      return await todoLocal.deleteTodoLocal(todos);
    } catch (e) {
      rethrow;
    }
  }

  Future getTodosRequested(int catID) async {
    try {
      return await todoLocal.getTodosLocal(catID);
    } catch (e) {
      rethrow;
    }
  }
}
