import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/auth/login/domain/user_model.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../data/models/todo_model.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../data/sources/local/todo_local_storage.dart';
import '../../domain/entities/todo_entity.dart';
import '../todo_controller.dart';

Future todoBottomSheet(context, Map? item, int? parentId) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
    builder: (context) {
      TextEditingController todoEditingController =
          item != null ? TextEditingController(text: item['title']) : TextEditingController();
      todoEditingController.selection =
          TextSelection.fromPosition(TextPosition(offset: todoEditingController.text.length));

      return Wrap(
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
                    child: TextField(
                      controller: todoEditingController,
                      autofocus: true,
                      maxLines: null,
                      maxLength: 51,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        final isarService = IsarService();
                        final isar = await isarService.db;
                        final user = await isar.users.where().findFirst();
                        final todoController = getIt<TodoController>();

                        final bool isCreateTodo = item == null ? true : false;
                        TodoModel remoteTodo = TodoModel();
                        Todo localTodo = Todo();
                        // final todoLocalStorage = TodoLocal();

                        /// Create todo
                        if (isCreateTodo) {
                          remoteTodo.userId = user!.id;
                          remoteTodo.title = todoEditingController.text;
                          remoteTodo.isChecked = false;

                          /// create on server
                          TodoModel createdTodoModel = await todoController.createTodoOnServer(remoteTodo);

                          /// create on local
                          localTodo.id = createdTodoModel.id;
                          localTodo.userId = createdTodoModel.userId;
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
                        }

                        // create new subTodo by parent id
                        // or
                        // update subTodo
                        print('parentID $parentId');
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      );
    },
  );
}
