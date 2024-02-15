import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../data/models/todo_model.dart';
import '../../domain/entities/todo_entity.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../bloc/sub_todos/sub_todo_bloc.dart';
import '../bloc/todos/todo_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/constants/app_theme.dart';
import '../todo_controller.dart';
import '../widgets/todo_item_form.dart';

@RoutePage(name: 'TodoEmptyRouter')
class TodoEmptyRouterPage extends AutoRouter {}

@RoutePage()
class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        backgroundColor: AppColor.lightBG,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.router.pop();
          },
          icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
        title: Text(
          'Перечень важных дел',
          style: AppFont.scaffoldTitleDark,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            color: AppColor.accent,
            onPressed: () {
              context.router.push(const TodoInfoScreenRoute());
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodosLoaded) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<TodoBloc>().add(FilterTodos(1));
                          },
                          style: state.activeCategory == 1
                              ? AppLayout.accentBTNStyle
                              : ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColor.deep,
                                  side: BorderSide(width: 1, color: AppColor.deep),
                                  shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius)),
                          child: Text(
                            'Самое важное',
                            style: AppFont.regularSemibold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<TodoBloc>().add(FilterTodos(2));
                          },
                          style: state.activeCategory == 2
                              ? AppLayout.accentBTNStyle
                              : ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColor.deep,
                                  side: BorderSide(width: 1, color: AppColor.deep),
                                  shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius)),
                          child: Text(
                            'Тоже нужно',
                            style: AppFont.regularSemibold,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          const SizedBox(height: 15),
          const Expanded(child: TodosBox()),
          const SizedBox(height: 15),
          const TodoItemForm(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class TodosBox extends StatefulWidget {
  const TodosBox({super.key});

  @override
  State<TodosBox> createState() => _TodosBoxState();
}

class _TodosBoxState extends State<TodosBox> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.secondary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.secondary.withOpacity(0.15);
    final Color draggableItemColor = colorScheme.secondary;

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

    return BlocConsumer<TodoBloc, TodoState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TodosLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodosLoaded) {
          int catId = int.parse(context.read<TodoBloc>().state.props.last.toString());

          return ReorderableListView(
            proxyDecorator: proxyDecorator,
            // shrinkWrap: true,
            // buildDefaultDragHandles: false,
            onReorder: (int oldIndex, int newIndex) {
              // Немедленное обновление состояния списка для отображения изменений в UI
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = state.todos.removeAt(oldIndex);
                state.todos.insert(newIndex, item);
              });

              context.read<TodoBloc>().add(UpdateTodoOrder(oldIndex, newIndex));
            },
            children: List.generate(state.todos.length, (index) {
              final todo = state.todos[index];

              /// Фильтрация подзадач по parentId
              List<TodoEntity>? subtasks = [];
              if (state.subtasks != null) {
                subtasks = state.subtasks!.where((subtask) => subtask.parentId == todo.id).toList();
              }

              double? completedPercent;
              if (subtasks.isNotEmpty) {
                List completedSubTodo = subtasks.where((todo) => todo.isChecked == true).toList();
                completedPercent = (completedSubTodo.length * 100 / subtasks.length).floorToDouble();
              }

              // return todoItem(todo, subtasks, context);
              return Container(
                key: ValueKey(todo.id),
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: AppLayout.boxDecorationShadowBG,
                clipBehavior: Clip.hardEdge,
                child: Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: ValueKey(todo.id),

                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    extentRatio: 0.2,

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      CustomSlidableAction(
                        onPressed: (context) async {
                          final isarService = IsarService();
                          final isar = await isarService.db;
                          final todoController = getIt<TodoController>();

                          TodoModel remoteTodo = TodoModel();
                          TodoEntity localTodo = TodoEntity();

                          remoteTodo.id = todo.id;
                          remoteTodo.category = todo.category == 1 ? 2 : 1;
                          remoteTodo.isChecked = todo.isChecked!;

                          /// Update on server
                          TodoModel updatedTodoModel = await todoController.updateTodoOnServer(remoteTodo);

                          /// Update on local
                          localTodo.id = updatedTodoModel.id;
                          localTodo.category = updatedTodoModel.category;

                          await todoController.updateTodoOnLocal(localTodo);

                          //delete action for this button
                          state.todos.removeAt(index); //go through the loop and match content to delete from list
                          setState(() {
                            //refresh UI after deleting element from list
                          });
                        },
                        backgroundColor: AppColor.deep,
                        foregroundColor: Colors.white,
                        child: SvgPicture.asset('assets/icons/transferTodo.svg'),
                      ),
                    ],
                  ),

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
                        },
                        backgroundColor: AppColor.accentBOW,
                        foregroundColor: Colors.white,
                        child: SvgPicture.asset('assets/icons/trash.svg'),
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subtasks.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.only(right: 10),
                                width: 50,
                                child: CircularPercentIndicator(
                                  radius: 25,
                                  percent: completedPercent! / 100,
                                  center: Text(
                                    '${completedPercent.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                        color: AppColor.accentBOW,
                                        fontSize: AppFont.smaller,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  progressColor: AppColor.accentBOW,
                                  backgroundColor: AppColor.grey1,
                                ),
                              )
                            : const SizedBox(),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: BlocBuilder<SubTodoBloc, SubTodoState>(
                            builder: (context, state) {
                              return GestureDetector(
                                  onTap: () {
                                    context.read<SubTodoBloc>().add(GetSubTodosByParent(parentId: todo.id!));
                                    AutoRouter.of(context).push(TodoItemScreenRoute(todo: todo));
                                  },
                                  onLongPress: () {
                                    print('edit todo');
                                    modalTodoForm(context, todo, null);
                                  },
                                  child: Container(
                                    height: 40,
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.only(right: 15, left: 10),
                                    child: Row(
                                      children: [
                                        Text(todo.title!, textAlign: TextAlign.start),
                                      ],
                                    ),
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

class TodoItemForm extends StatefulWidget {
  const TodoItemForm({Key? key}) : super(key: key);

  @override
  State<TodoItemForm> createState() => _TodoItemFormState();
}

class _TodoItemFormState extends State<TodoItemForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await modalTodoForm(context, null, null);
              },
              style: AppLayout.accentBTNStyle,
              child: Text(
                'Добавить дело',
                style: AppFont.regularSemibold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void doNothing(BuildContext context) {}
