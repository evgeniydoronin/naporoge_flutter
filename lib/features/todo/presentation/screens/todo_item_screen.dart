import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../data/models/todo_model.dart';
import '../../domain/entities/todo_entity.dart';

import '../../../../core/constants/app_theme.dart';
import '../bloc/sub_todos/sub_todo_bloc.dart';
import '../bloc/todos/todo_bloc.dart';
import '../todo_controller.dart';
import '../widgets/todo_item_form.dart';

@RoutePage()
class TodoItemScreen extends StatelessWidget {
  const TodoItemScreen({super.key, required this.todo});

  final TodoEntity todo;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        int parentId = 0;
        String? _title;
        if (state is TodosLoaded) {
          parentId = state.activeCategory;
          _title = state.todos.where((el) => el.id == todo.id).first.title;
        }
        return Scaffold(
          backgroundColor: AppColor.lightBG,
          appBar: AppBar(
            backgroundColor: AppColor.lightBG,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                /// обновление стейта категории
                context.read<TodoBloc>().add(FilterTodos(parentId));
                context.router.pop();
              },
              icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
            ),
            title: Text(
              'Дело',
              style: AppFont.scaffoldTitleDark,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    modalTodoForm(context, todo, null);
                  },
                  child: Text(
                    _title!,
                    style: TextStyle(fontSize: AppFont.regular),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(child: TodoItems(parentTodo: todo)),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      modalTodoForm(context, null, todo.id);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 5),
                        Text('Добавить подзадачу'),
                      ],
                    )),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TodoItems extends StatefulWidget {
  final TodoEntity parentTodo;

  const TodoItems({Key? key, required this.parentTodo}) : super(key: key);

  @override
  State<TodoItems> createState() => _TodoItemsState();
}

class _TodoItemsState extends State<TodoItems> {
  @override
  Widget build(BuildContext context) {
    int catId = int.parse(context.read<TodoBloc>().state.props.last.toString());

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.secondary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.secondary.withOpacity(0.15);
    final Color draggableItemColor = colorScheme.secondary;

    var slidableController = SlidableController;

    Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            // elevation: elevation,
            color: Colors.transparent,
            // shadowColor: draggableItemColor,
            child: child,
          );
        },
        child: child,
      );
    }

    return BlocBuilder<SubTodoBloc, SubTodoState>(
      builder: (context, state) {
        if (state is SubTodosLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SubTodosLoaded) {
          // Фильтрация подзадач по parentId
          return ReorderableListView(
            proxyDecorator: proxyDecorator,
            // shrinkWrap: true,
            // buildDefaultDragHandles: false,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }

                final todo = state.todos.removeAt(oldIndex);
                state.todos.insert(newIndex, todo);
              });
              context.read<SubTodoBloc>().add(UpdateSubTodoOrder(oldIndex, newIndex, widget.parentTodo.id!));
            },
            children: List.generate(state.todos.length, (index) {
              final todo = state.todos[index];

              return Container(
                key: ValueKey(todo.id),
                margin: const EdgeInsets.only(left: 0, right: 0, bottom: 5),
                child: Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: ValueKey(todo.id),

                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.2,
                    // A pane can dismiss the Slidable.
                    // dismissible: DismissiblePane(onDismissed: () => onDismissed(index)),
                    children: [
                      CustomSlidableAction(
                        onPressed: (context) async {
                          CircularLoading(context).deleteTodo(todo, state.todos, index, catId);

                          // /// обновление стейта подкатегории
                          // setState(() {
                          //   //refresh UI after deleting element from list
                          // });
                        },
                        backgroundColor: AppColor.accentBOW,
                        foregroundColor: Colors.white,
                        child: SvgPicture.asset('assets/icons/trash.svg'),
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: todo.isChecked,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                            onChanged: (bool? value) async {
                              final isarService = IsarService();
                              final isar = await isarService.db;
                              final todoController = getIt<TodoController>();

                              TodoModel remoteTodo = TodoModel();
                              TodoEntity localTodo = TodoEntity();

                              remoteTodo.id = todo.id;
                              remoteTodo.isChecked = value!;

                              print('Checkbox remoteTodo.id: ${todo.id}');
                              print('Checkbox remoteTodo.isChecked: $value');

                              /// Update on server
                              TodoModel updatedTodoModel = await todoController.updateTodoOnServer(remoteTodo);

                              /// Update on local
                              localTodo.id = updatedTodoModel.id;
                              localTodo.isChecked = updatedTodoModel.isChecked!;

                              await todoController.updateTodoOnLocal(localTodo);

                              if (context.mounted) {
                                context.read<SubTodoBloc>().add(SubLoadTodos(todo.parentId!));
                              }
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: BlocBuilder<SubTodoBloc, SubTodoState>(
                            builder: (context, state) {
                              return GestureDetector(
                                  onTap: () {
                                    // context.read<SubTodoBloc>().add(GetSubTodosByParent(parentId: todo.id!));
                                  },
                                  onLongPress: () {
                                    modalTodoForm(context, todo, null);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15, left: 10),
                                    child: Text(todo.title!, textAlign: TextAlign.start),
                                  ));
                            },
                          ),
                        ),
                        const Icon(Icons.drag_handle),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }
        return Container(); // Пустой контейнер для остальных состояний
      },
    );
  }
}

void doNothing(BuildContext context) {}
