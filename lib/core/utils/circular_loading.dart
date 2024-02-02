import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/todo/data/models/todo_model.dart';
import '../../features/todo/domain/entities/todo_entity.dart';
import '../../features/todo/presentation/bloc/sub_todos/sub_todo_bloc.dart';
import '../../features/todo/presentation/bloc/todos/todo_bloc.dart';
import '../../features/todo/presentation/todo_controller.dart';
import '../constants/app_theme.dart';
import '../services/controllers/service_locator.dart';

class CircularLoading {
  late BuildContext context;

  CircularLoading(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          // can change this to your prefered color
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  Future<void> stopAutoRouterLoading() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) {
      context.router.pop();
    }
  }

  Future<void> showError(Object? error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.red,
        content: Text('handleError(error)'),
      ),
    );
  }

  Future<void> saveSuccess() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColor.deep,
        content: const Text('Успешно сохранено'),
      ),
    );
  }

  Future deleteTodo(todo, subtasks, index, catId) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Удалить?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Нет')),
                TextButton(
                    onPressed: () async {
                      final todoController = getIt<TodoController>();

                      TodoModel remoteTodo = TodoModel();
                      TodoEntity localTodo = TodoEntity();

                      remoteTodo.id = todo.id;

                      /// Delete on server
                      Map deleteTodoModelMap = await todoController.deleteTodoOnServer(remoteTodo);

                      /// Update on local
                      await todoController.deleteTodoOnLocal(deleteTodoModelMap);

                      //delete action for this button
                      subtasks.removeAt(index); //go through the loop and match content to delete from list

                      if (context.mounted) {
                        context.read<TodoBloc>().add(FilterTodos(catId));
                        context.read<SubTodoBloc>().add(SubLoadTodos(catId));
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('Да')),
              ],
            ));
  }
}
