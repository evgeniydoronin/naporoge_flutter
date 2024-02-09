import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../../auth/login/domain/user_model.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../data/models/todo_model.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../data/sources/local/todo_local_storage.dart';
import '../../domain/entities/todo_entity.dart';
import '../bloc/sub_todos/sub_todo_bloc.dart';
import '../bloc/todos/todo_bloc.dart';
import '../todo_controller.dart';

Future modalTodoForm(context, TodoEntity? todo, int? parentId) async {
  /// Сохраняем контекст первого BottomSheet
  BuildContext? modalTodoFormContext;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
    builder: (context) {
      // Сохраняем контекст для последующего закрытия первого BottomSheet
      modalTodoFormContext = context;

      final _formKey = GlobalKey<FormState>();

      TextEditingController todoEditingController =
          todo != null ? TextEditingController(text: todo.title) : TextEditingController();
      todoEditingController.selection =
          TextSelection.fromPosition(TextPosition(offset: todoEditingController.text.length));

      return Form(
        key: _formKey,
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: todoEditingController,
                        autofocus: true,
                        maxLines: null,
                        maxLength: 51,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Заполните обязательное поле!';
                          }
                          return null;
                        },
                      ),
                    ),
                    BlocConsumer<TodoBloc, TodoState>(
                      listener: (ctx, state) {},
                      builder: (ctx, state) {
                        int categoryId = 1;
                        if (state is TodosLoaded) {
                          categoryId = parentId ?? state.activeCategory;
                        }

                        return IconButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pop();

                                /// start loading
                                BuildContext? startLoadingContext = await startLoading(modalTodoFormContext!);

                                if (startLoadingContext != null && startLoadingContext.mounted) {
                                  final bool isCreateTodo = todo == null ? true : false;

                                  /// save or update todo
                                  await updateTodo(todo, todoEditingController, categoryId, parentId, context);

                                  /// stop loading
                                  if (startLoadingContext.mounted && Navigator.canPop(startLoadingContext)) {
                                    /// Create todo
                                    if (isCreateTodo) {
                                      /// Обновление BLoC Subtask
                                      if (categoryId != 1 && categoryId != 2) {
                                        print('Обновление BLoC Subtask');
                                        startLoadingContext.read<SubTodoBloc>().add(FilterSubTodos(categoryId));
                                      }

                                      /// Обновление BLoC Task
                                      else {
                                        print('Обновление BLoC Task');
                                        startLoadingContext.read<TodoBloc>().add(FilterTodos(categoryId));
                                      }
                                    }

                                    /// Update todo
                                    else {
                                      // print('title: ${todoEditingController.text}');
                                      // print('isChecked: false');
                                      // print('category: $categoryId');
                                      // print('parentId: ${todo.parentId}');

                                      /// Обновление BLoC Subtask
                                      if (categoryId != 1 && categoryId != 2) {
                                        // print('Обновление BLoC Subtask 2');
                                      }

                                      /// Обновление BLoC Task
                                      else {
                                        print('Обновление BLoC Task 2');
                                        startLoadingContext.read<TodoBloc>().add(FilterTodos(parentId ?? categoryId));
                                        startLoadingContext
                                            .read<SubTodoBloc>()
                                            .add(SubLoadTodos(parentId ?? categoryId));
                                      }
                                    }

                                    // Очистка текстового поля
                                    todoEditingController.clear();

                                    /// stop loading
                                    stopLoading(startLoadingContext);
                                  }
                                }
                              }
                            },
                            icon: const Icon(Icons.send));
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

Future<BuildContext?> startLoading(BuildContext context) async {
  // Сохраняем контекст первого BottomSheet
  BuildContext? startLoadingContext;

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      startLoadingContext = context;

      return const SimpleDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        // can change this to your preferred color
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    },
  );

  await Future.delayed(const Duration(seconds: 1));
  return startLoadingContext;
}

Future<void> stopLoading(context) async {
  Navigator.of(context).pop();
}

Future updateTodo(todo, todoEditingController, categoryId, parentId, context) async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final user = await isar.users.where().findFirst();
  final todoController = getIt<TodoController>();

  final bool isCreateTodo = todo == null ? true : false;

  TodoModel remoteTodo = TodoModel();
  TodoEntity localTodo = TodoEntity();
  final todoLocalStorage = TodoLocal();

  /// Create todo
  if (isCreateTodo) {
    remoteTodo.userId = user!.id;
    remoteTodo.title = todoEditingController.text;
    remoteTodo.isChecked = false;
    remoteTodo.category = categoryId;
    remoteTodo.parentId = parentId;

    /// create on server
    TodoModel createdTodoModel = await todoController.createTodoOnServer(remoteTodo);

    /// create on local
    localTodo.id = createdTodoModel.id;
    localTodo.parentId = createdTodoModel.parentId;
    localTodo.title = createdTodoModel.title;
    localTodo.category = createdTodoModel.category;
    localTodo.order = createdTodoModel.order;
    localTodo.isChecked = createdTodoModel.isChecked;

    await todoController.createTodoOnLocal(localTodo);
  }

  /// Update todo
  else {
    print('Update todo');
    remoteTodo.id = todo.id;
    remoteTodo.userId = user!.id;
    remoteTodo.title = todoEditingController.text;
    remoteTodo.isChecked = todo.isChecked;
    remoteTodo.category = todo.category;

    /// Update on server
    TodoModel updatedTodoModel = await todoController.updateTodoOnServer(remoteTodo);

    /// Update on local
    localTodo.id = updatedTodoModel.id;
    localTodo.parentId = updatedTodoModel.parentId;
    localTodo.title = updatedTodoModel.title;
    localTodo.category = updatedTodoModel.category;
    localTodo.order = updatedTodoModel.order;
    localTodo.isChecked = updatedTodoModel.isChecked;

    await todoController.updateTodoOnLocal(localTodo);
  }
}
