import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../../../auth/login/domain/user_model.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../data/models/todo_model.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../domain/entities/todo_entity.dart';
import '../bloc/sub_todos/sub_todo_bloc.dart';
import '../bloc/todos/todo_bloc.dart';
import '../todo_controller.dart';

Future todoBottomSheet(context, TodoEntity? todo, int? parentId) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
    builder: (context) {
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
                      listener: (context, state) {},
                      builder: (context, state) {
                        int categoryId = 1;
                        if (state is TodosLoaded) {
                          categoryId = parentId ?? state.activeCategory;
                        }

                        return IconButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final isarService = IsarService();
                                final isar = await isarService.db;
                                final user = await isar.users.where().findFirst();
                                final todoController = getIt<TodoController>();

                                final bool isCreateTodo = todo == null ? true : false;

                                TodoModel remoteTodo = TodoModel();
                                TodoEntity localTodo = TodoEntity();
                                // final todoLocalStorage = TodoLocal();

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

                                  // Добавление нового дела в BLoC
                                  if (context.mounted) {
                                    /// create subtask
                                    if (parentId != null) {
                                      /// обновление стейта подкатегории
                                      context.read<SubTodoBloc>().add(FilterSubTodos(categoryId));
                                      print('object555');
                                    } else {
                                      print('object666');

                                      /// обновление стейта категории
                                      context.read<TodoBloc>().add(FilterTodos(categoryId));
                                    }
                                    Navigator.pop(context);
                                  }

                                  // Очистка текстового поля
                                  todoEditingController.clear();
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

                                  /// Update on local
                                  /// Обновление дела в BLoC
                                  if (context.mounted) {
                                    print('parentId 33: $parentId');
                                    print('categoryId 33: $categoryId');
                                    print('todo.category 33: ${todo.category}');

                                    if (parentId != null) {
                                      print('object SubTodoBloc');
                                      context.read<SubTodoBloc>().add(FilterSubTodos(categoryId));
                                    } else {
                                      print('object TodoBloc');
                                      context.read<TodoBloc>().add(FilterTodos(categoryId));
                                      context.read<SubTodoBloc>().add(SubLoadTodos(categoryId));
                                    }

                                    Navigator.pop(context);
                                  }

                                  /// Очистка текстового поля
                                  todoEditingController.clear();
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
