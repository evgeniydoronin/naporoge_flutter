import 'package:dio/dio.dart';
import '../../../../../core/constants/endpoints.dart';
import '../../../../../core/services/http_client/dio_client.dart';
import '../../models/todo_model.dart';

class TodoApi {
  final DioClient dioClient;

  TodoApi({required this.dioClient});

  Future<Response> createTodoApi(TodoModel todo) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.createTodo,
        data: todo.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateTodoApi(TodoModel todo) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.updateTodo,
        data: todo.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteTodoApi(TodoModel todo) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.deleteTodo,
        data: todo.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
