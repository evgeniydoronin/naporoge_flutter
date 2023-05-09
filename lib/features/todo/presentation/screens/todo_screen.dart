import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naporoge/features/todo/presentation/screens/todo_item_screen.dart';
import '../../../../core/routes/app_router.dart';
import '../bloc/todo_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/constants/app_theme.dart';
import '../widgets/todoItemForm.dart';

List todos = [
  {
    'id': 0,
    'title': 'Прочесть книгу',
    'subTodos': [],
    'category': 0,
    'order': 0,
    'isChecked': false,
  },
  {
    'id': 1,
    'title': 'Прочесть книги, максимальное количество знаков 51 штука.',
    'subTodos': [
      {'id': 21, 'title': 'Книга 1', 'order': 1, 'isChecked': false},
      {'id': 22, 'title': 'Книга 2', 'order': 0, 'isChecked': false},
      {'id': 23, 'title': 'Книга 3', 'order': 2, 'isChecked': true},
    ],
    'category': 0,
    'order': 1,
    'isChecked': false,
  },
  {
    'id': 2,
    'title': 'Сделать зарядку',
    'subTodos': [],
    'category': 0,
    'order': 2,
    'isChecked': false,
  },
  {
    'id': 3,
    'title': 'Прочесть вторую книгу',
    'subTodos': [],
    'category': 0,
    'order': 3,
    'isChecked': false,
  },
  {
    'id': 4,
    'title': 'Прочесть 4',
    'subTodos': [],
    'category': 0,
    'order': 4,
    'isChecked': false,
  },
  {
    'id': 5,
    'title': 'Прочесть 5',
    'subTodos': [],
    'category': 0,
    'order': 5,
    'isChecked': false,
  },
  {
    'id': 6,
    'title': 'Прочесть 6',
    'subTodos': [],
    'category': 0,
    'order': 6,
    'isChecked': false,
  },
  {
    'id': 7,
    'title': 'Прочесть 7',
    'subTodos': [],
    'category': 0,
    'order': 7,
    'isChecked': false,
  },
  {
    'id': 8,
    'title': 'Прочесть 8',
    'subTodos': [],
    'category': 0,
    'order': 8,
    'isChecked': false,
  },
  {
    'id': 9,
    'title': 'Прочесть 9',
    'subTodos': [],
    'category': 0,
    'order': 9,
    'isChecked': false,
  },
  {
    'id': 10,
    'title': 'Прочесть 10',
    'subTodos': [],
    'category': 0,
    'order': 10,
    'isChecked': false,
  },
];

@RoutePage(name: 'TodoEmptyRouter')
class TodoEmptyRouterPage extends AutoRouter {}

@RoutePage()
class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: Scaffold(
        backgroundColor: AppColor.lightBG,
        appBar: AppBar(
          backgroundColor: AppColor.lightBG,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              context.router.pop();
            },
            icon: RotatedBox(
                quarterTurns: 2,
                child: SvgPicture.asset('assets/icons/arrow.svg')),
          ),
          title: Text(
            'Перечень важных дел',
            style: AppFont.scaffoldTitleDark,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
              return _todoTabs(context);
            }),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         flex: 1,
            //         child: ElevatedButton(
            //           onPressed: () {},
            //           style: AppLayout.accentBTNStyle,
            //           child: Text(
            //             'Самое важное',
            //             style: AppFont.regularSemibold,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 15),
            //       Expanded(
            //         flex: 1,
            //         child: ElevatedButton(
            //           onPressed: () {},
            //           style: ElevatedButton.styleFrom(
            //               elevation: 0,
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 20, vertical: 15),
            //               backgroundColor: Colors.transparent,
            //               foregroundColor: AppColor.deep,
            //               side: BorderSide(width: 1, color: AppColor.deep),
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: AppLayout.primaryRadius)),
            //           child: Text(
            //             'Тоже нужно',
            //             style: AppFont.regularSemibold,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 15),
            Expanded(child: TodoMainItems(todos: todos)),
            const SizedBox(height: 15),
            TodoItemForm(),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _todoTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<TodoBloc>(context).add(ChangeTab());
              },
              style: BlocProvider.of<TodoBloc>(context).state.tabStatus
                  ? AppLayout.accentBTNStyle
                  : ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      backgroundColor: Colors.white,
                      foregroundColor: AppColor.deep,
                      side: BorderSide(width: 1, color: AppColor.deep),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppLayout.primaryRadius)),
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
                BlocProvider.of<TodoBloc>(context).add(ChangeTab());
              },
              style: BlocProvider.of<TodoBloc>(context).state.tabStatus == false
                  ? AppLayout.accentBTNStyle
                  : ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      backgroundColor: Colors.white,
                      foregroundColor: AppColor.deep,
                      side: BorderSide(width: 1, color: AppColor.deep),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppLayout.primaryRadius)),
              child: Text(
                'Тоже нужно',
                style: AppFont.regularSemibold,
              ),
            ),
          ),
        ],
      ),
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
              onPressed: () {
                todoBottomSheet(context, null, null);
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

class TodoMainItems extends StatefulWidget {
  final List todos;

  const TodoMainItems({Key? key, required this.todos}) : super(key: key);

  @override
  State<TodoMainItems> createState() => _TodoMainItemsState();
}

class _TodoMainItemsState extends State<TodoMainItems> {
  // final List _items = List.generate(50, (index) => index);
  late List _items;

  @override
  void initState() {
    _items = widget.todos;

    // sort by order
    _items.sort((a, b) {
      int indexA = (a['order'] ?? 0);
      int indexB = (b['order'] ?? 0);

      return (indexA > indexB) ? 1 : 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.secondary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.secondary.withOpacity(0.15);
    final Color draggableItemColor = colorScheme.secondary;

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
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

    return ReorderableListView(
      proxyDecorator: proxyDecorator,
      shrinkWrap: true,
      buildDefaultDragHandles: false,
      // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      // physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        for (int index = 0; index < _items.length; index += 1)
          _items[index]['subTodos'].isNotEmpty
              ? todoItem(index, true)
              : todoItem(index, false),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
    );
  }

  Widget todoItem(int index, bool isSubTodos) {
    return Container(
      key: ValueKey(_items[index]),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: AppLayout.boxDecorationShadowBG,
      clipBehavior: Clip.hardEdge,
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: ValueKey(_items[index]),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            CustomSlidableAction(
              onPressed: doNothing,
              backgroundColor: AppColor.deep,
              foregroundColor: Colors.white,
              child: SvgPicture.asset('assets/icons/transferTodo.svg'),
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () => onDismissed(index)),
          children: [
            CustomSlidableAction(
              onPressed: (context) => onDismissed(index),
              backgroundColor: AppColor.accentBOW,
              foregroundColor: Colors.white,
              child: SvgPicture.asset('assets/icons/trash.svg'),
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: GestureDetector(
          onTap: () {
            AutoRouter.of(context)
                .push(TodoItemScreenRoute(todo: _items[index]));
            print(_items[index]);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: isSubTodos
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          child: CircularPercentIndicator(
                            radius: 25,
                            percent: 0.35,
                            center: Text(
                              '35%',
                              style: TextStyle(
                                  color: AppColor.accentBOW,
                                  fontSize: AppFont.smaller,
                                  fontWeight: FontWeight.w800),
                            ),
                            progressColor: AppColor.accentBOW,
                            backgroundColor: AppColor.grey1,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                            child: Text(_items[index]['title'].toString())),
                      ],
                    )
                  : Text(_items[index]['title'].toString()),
              trailing: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.dehaze),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDismissed(index) {
    _items.removeAt(index);
    setState(() {});
    print(index);
    print(_items);
  }

  void itemChange(bool val, int index) {
    // setState(() {
    //   todos[index].isCheck = val;
    // });
  }
}

void doNothing(BuildContext context) {}
