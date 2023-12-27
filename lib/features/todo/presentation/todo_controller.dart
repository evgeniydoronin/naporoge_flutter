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

  /// Create on local
  Future createTodoOnLocal(Todo todo) async {
    return await todoLocalRepository.createTodoRequested(todo);
  }
}
