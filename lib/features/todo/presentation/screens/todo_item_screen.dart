import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_theme.dart';
import '../widgets/todoItemForm.dart';

@RoutePage()
class TodoItemScreen extends StatelessWidget {
  const TodoItemScreen({super.key, @pathParam required this.todo});

  final dynamic todo;

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
          icon: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
        title: Text(
          'Дело',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  todoBottomSheet(context, todo, null);
                },
                child: Text(
                  todo['title'],
                  style: TextStyle(fontSize: AppFont.regular),
                ),
              ),
              const SizedBox(height: 10),
              TodoItems(parentTodo: todo),
              const SizedBox(height: 10),
              TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    todoBottomSheet(context, null, todo);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.add),
                      SizedBox(width: 5),
                      Text('Добавить подзадачу'),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoItems extends StatefulWidget {
  final Map parentTodo;

  const TodoItems({Key? key, required this.parentTodo}) : super(key: key);

  @override
  State<TodoItems> createState() => _TodoItemsState();
}

class _TodoItemsState extends State<TodoItems> {
  // final List _items = List.generate(50, (index) => index);
  late Map parentTodo;
  late List items;

  @override
  void initState() {
    parentTodo = widget.parentTodo;
    items = widget.parentTodo['subTodos'];

    // sort by order
    items.sort((a, b) {
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

    var slidableController = SlidableController;

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
      children: <Widget>[
        for (int index = 0; index < items.length; index += 1)
          Container(
            key: ValueKey(items[index]),
            child: Slidable(
              // Specify a key if the Slidable is dismissible.
              key: ValueKey(items[index]),

              // The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                // A pane can dismiss the Slidable.
                dismissible:
                    DismissiblePane(onDismissed: () => onDismissed(index)),
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
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        fillColor:
                            MaterialStateProperty.all<Color>(AppColor.accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        value: items[index]['isChecked'],
                        onChanged: (bool? value) {
                          setState(() {
                            items[index]['isChecked'] = value! ? true : false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        todoBottomSheet(context, items[index], null);
                      },
                      child: Text(
                        items[index]['title'],
                        style: TextStyle(fontSize: AppFont.small),
                      ),
                    ),
                  ],
                ),
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.dehaze),
                ),
              ),
              // child: ListTile(title: Text(items[index]['title'].toString())),
            ),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
    );
  }

  void itemChange(bool val, int index) {
    // setState(() {
    //   subTodos[index].isChecked = val;
    // });
  }

  onDismissed(index) {
    items.removeAt(index);
    setState(() {});
  }
}

void doNothing(BuildContext context) {}
