import '../domain/repositories/todo_local_repository.dart';
import '../data/models/todo_model.dart';
import '../../../core/services/controllers/service_locator.dart';
import '../data/repositories/todo_remote_repository.dart';
import '../domain/entities/todo_entity.dart';

class TodoController {
  // --------------- Repository -------------
  final todoRemoteRepository = getIt.get<TodoRemoteRepository>();

  final todoLocalRepository = getIt.get<TodoLocalRepository>();

  // -------------- Methods ---------------
  /// Create on server
  Future createTodoOnServer(TodoModel todo) async {
    return await todoRemoteRepository.createTodoRequested(todo);
  }

  /// Update on server
  Future updateTodoOnServer(TodoModel todo) async {
    TodoModel response = await todoRemoteRepository.updateTodoRequested(todo);
    return response;
  }

  /// Delete on server
  Future deleteTodoOnServer(TodoModel todo) async {
    Map response = await todoRemoteRepository.deleteTodoRequested(todo);
    return response;
  }

  /// Create on local
  Future createTodoOnLocal(TodoEntity todo) async {
    return await todoLocalRepository.createTodoRequested(todo);
  }

  /// Update on local
  Future updateTodoOnLocal(TodoEntity todo) async {
    return await todoLocalRepository.updateTodoRequested(todo);
  }

  /// Delete on local
  Future deleteTodoOnLocal(Map todos) async {
    return await todoLocalRepository.deleteTodoRequested(todos);
  }

  /// Get todos by catID
  Future getTodosFromLocal(int catId) async {
    return await todoLocalRepository.getTodosRequested(catId);
  }
}
