import '../../data/sources/local/todo_local_storage.dart';
import '../entities/todo_entity.dart';

class TodoLocalRepository {
  final TodoLocal todoLocal;

  TodoLocalRepository(this.todoLocal);

  Future createTodoRequested(Todo todo) async {
    try {
      return await todoLocal.createTodoLocal(todo);
    } catch (e) {
      rethrow;
    }
  }
}
