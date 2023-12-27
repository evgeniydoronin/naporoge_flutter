import '../models/todo_model.dart';
import '../sources/remote/todo_api.dart';

class TodoRemoteRepository {
  final TodoApi todoApi;

  TodoRemoteRepository(this.todoApi);

  Future createTodoRequested(TodoModel todo) async {
    try {
      final response = await todoApi.createTodoApi(todo);
      return TodoModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
