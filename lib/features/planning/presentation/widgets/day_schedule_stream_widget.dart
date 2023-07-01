import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naporoge/core/constants/app_theme.dart';
import 'package:collection/collection.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';

import '../bloc/planner_bloc.dart';

Function eq = const ListEquality().equals;

// REMOVE DUPLICATE ELEMENTS
extension ListExtension<T> on List<T> {
  bool _containsElement(T e) {
    for (T element in this) {
      if (element.toString().compareTo(e.toString()) == 0) return true;
    }
    return false;
  }

  List<T> removeDuplicates() {
    List<T> tempList = [];

    for (var element in this) {
      if (!tempList._containsElement(element)) tempList.add(element);
    }

    return tempList;
  }
}

final List<DayPeriod> period = [
  DayPeriod(title: 'Утро', rows: 8, start: 4),
  DayPeriod(title: 'День', rows: 7, start: 12),
  DayPeriod(title: 'Вечер', rows: 8, start: 19),
];

List<Map> cells = [];
List<List> newCellsList = [];
List<List> deleteCellsList = [];

void deleteFromList(List deleteCellsList) {
  for (List deleteCell in deleteCellsList) {
    cells.removeWhere((cell) => eq(cell['id'], deleteCell));
  }
}

void addOrUpdateCellList(newCellsList, cellData) {
  // Существующие пункты
  List existingCell = [];

  // если есть активные ячейки
  if (cells.isNotEmpty) {
    List globalCellsIDs = cells.map((e) => e['id']).toList();

    // print('Входящий список для обновления данными');
    // print('Входящий новый список: $newCellsList');
    for (List newCellId in newCellsList) {
      existingCell
          .addAll(globalCellsIDs.where((cellID) => eq(cellID, newCellId)));
    }

    // print('existingCell: $existingCell');

    // перекрестные ячейки, на замену новой
    List prepareForDelete = [];

    for (List cellID in globalCellsIDs) {
      for (List newCellId in newCellsList) {
        if (newCellId[2] == cellID[2]) {
          prepareForDelete.addAll([cellID]);
        }
      }
    }

    for (List cellForDelete in prepareForDelete) {
      globalCellsIDs.removeWhere((cell) => eq(cell, cellForDelete));
    }

    // Удаляем старые перекрестные ячейки
    // print('prepareForDelete: $prepareForDelete');
    deleteFromList(prepareForDelete);

    // print('Глобальный страый оставляем без изменений');
    // print(
    //     'Глобальный страый список после удаления перекрестных: $globalCellsIDs');
  }

  // Создаем новые ячейки
  for (List newCellId in newCellsList) {
    List<Map> addNewMapToCell = [
      {
        'id': newCellId,
        'startTime': cellData['startTime'],
      },
    ];

    cells.addAll(addNewMapToCell);
    // добавляем пустое воскресенье
  }

  // print('AFTER ADD or UPDATE: $cells');
}

final List<String> weekDaysNameRu = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];

class DayScheduleStreamWidget extends StatelessWidget {
  final NPStream stream;

  const DayScheduleStreamWidget({Key? key, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String startDateInfo = '';
    // До старта курса
    // - можно редактировать первую неделю
    //
    // Во время курса
    // - Если текущая неделя не последняя на курсе:
    // -- Текущая неделя только на просмотр
    // -- Предыдущая неделя только на просмотр
    // -- Следующая неделя активна для редактирования
    // - Иначе
    // -- только на просмотр текущей недели и предыдущих
    //
    // После завершения курса
    // - посмотреть все недели курса

    List cells = jsonDecode(stream.weekBacklink.first.cells!);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Text(
                'Неделя 1/3',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(DateFormat('dd.MM.y').format(stream.startAt!)),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 7),
              alignment: Alignment.centerLeft,
              width: 50,
              child: SvgPicture.asset('assets/icons/time.svg'),
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 1,
                ),
                itemCount: weekDaysNameRu.length,
                itemBuilder: (BuildContext context, dayIndex) {
                  return Center(
                    child: Text(
                      weekDaysNameRu[dayIndex].toString().toUpperCase(),
                      style: TextStyle(
                          fontSize: AppFont.smaller,
                          color: weekDaysNameRu[dayIndex] == 'вс'
                              ? AppColor.grey2
                              : AppColor.accent),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ExpandDayPeriod(
          cells: cells,
        ),
      ],
    );

    // return BlocConsumer<PlannerBloc, PlannerState>(
    //   listener: (context, state) {},
    //   builder: (context, state) {
    //     // TODO: доработать входящие данные по количеству недель курса
    //     int weeks = 3;
    //     String startDateString = state.startDate;
    //     DateTime startDate = DateTime.parse(startDateString);
    //
    //     DateTime endDate = startDate.add(Duration(days: (weeks * 7) - 1));
    //     startDateInfo =
    //         '${DateFormat('dd.MM.y').format(startDate)} - ${DateFormat('dd.MM.y').format(endDate)}';
    //
    //     return Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //           child: Column(
    //             children: [
    //               const Text(
    //                 'Неделя 1/3',
    //                 style: TextStyle(fontWeight: FontWeight.w500),
    //               ),
    //               Text(startDateInfo),
    //             ],
    //           ),
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Container(
    //               padding: const EdgeInsets.only(left: 7),
    //               alignment: Alignment.centerLeft,
    //               width: 50,
    //               child: SvgPicture.asset('assets/icons/time.svg'),
    //             ),
    //             Expanded(
    //               child: GridView.builder(
    //                 shrinkWrap: true,
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 gridDelegate:
    //                     const SliverGridDelegateWithFixedCrossAxisCount(
    //                   crossAxisCount: 7,
    //                   crossAxisSpacing: 1,
    //                 ),
    //                 itemCount: weekDaysNameRu.length,
    //                 itemBuilder: (BuildContext context, dayIndex) {
    //                   return Center(
    //                     child: Text(
    //                       weekDaysNameRu[dayIndex].toString().toUpperCase(),
    //                       style: TextStyle(
    //                           fontSize: AppFont.smaller,
    //                           color: weekDaysNameRu[dayIndex] == 'вс'
    //                               ? AppColor.grey2
    //                               : AppColor.accent),
    //                     ),
    //                   );
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //         const ExpandDayPeriod(),
    //       ],
    //     );
    //   },
    // );
  }
}

class ExpandDayPeriod extends StatefulWidget {
  final List cells;

  const ExpandDayPeriod({Key? key, required this.cells}) : super(key: key);

  @override
  State<ExpandDayPeriod> createState() => _ExpandDayPeriodState();
}

class _ExpandDayPeriodState extends State<ExpandDayPeriod> {
  late bool isExpanded;

  @override
  void initState() {
    isExpanded = false;
    super.initState();
  }

  void onCollapseToggle(val) {
    for (int i = 0; i < period.length; i++) {
      if (i == val && period[val].isExpanded) {
        setState(() {
          period[val].isExpanded = false;
        });
      } else if (i == val && !period[val].isExpanded) {
        setState(() {
          period[val].isExpanded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List cells = widget.cells;
    print(cells);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: period.length,
      itemBuilder: (BuildContext context, periodIndex) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                onCollapseToggle(periodIndex);
              },
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(bottom: 2),
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 6, right: 10),
                decoration: BoxDecoration(
                    color: AppColor.grey1,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(period[periodIndex].title),
                    RotatedBox(
                        quarterTurns: period[periodIndex].isExpanded ? 3 : 1,
                        child: SvgPicture.asset('assets/icons/arrow.svg')),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: period[periodIndex].isExpanded
                  ? (period[periodIndex].rows * 43)
                  : 0,
              child: DayPeriodRow(periodIndex: periodIndex),
            )
          ],
        );
      },
    );
  }
}

class DayPeriodRow extends StatefulWidget {
  final int periodIndex;

  const DayPeriodRow({Key? key, required this.periodIndex}) : super(key: key);

  @override
  State<DayPeriodRow> createState() => _DayPeriodRowState();
}

class _DayPeriodRowState extends State<DayPeriodRow> {
  @override
  Widget build(BuildContext context) {
    List newCells = [];
    int periodIndex = widget.periodIndex;

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: period[periodIndex].rows,
          itemBuilder: (BuildContext context, int rowIndex) {
            String hourStart =
                (period[periodIndex].start + rowIndex).toString();
            String hourFinished = '';
            if (int.parse(hourStart) < 9) {
              hourStart = '0$hourStart';
              hourFinished =
                  '0${(period[periodIndex].start + rowIndex + 1).toString()}';
            } else if (int.parse(hourStart) >= 9 && int.parse(hourStart) < 23) {
              hourFinished =
                  (period[periodIndex].start + rowIndex + 1).toString();
            } else if (int.parse(hourStart) == 23) {
              hourFinished = '00';
            } else if (int.parse(hourStart) > 23) {
              hourStart = '0${(rowIndex - 5).toString()}';
              hourFinished = '0${(rowIndex - 4).toString()}';
            }

            return Container(
              padding: const EdgeInsets.only(bottom: 1),
              color: AppColor.grey1,
              child: Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 49,
                    height: 42,
                    margin: const EdgeInsets.only(right: 1),
                    child: Center(
                      child: Text(
                        '$hourStart - $hourFinished',
                        style: TextStyle(
                            fontSize: AppFont.smaller, color: AppColor.grey3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: 7,
                          itemBuilder: (BuildContext context, gridIndex) {
                            return gridIndex == 6
                                ? DayPeriodCell(
                                    periodIndex: periodIndex,
                                    gridIndex: gridIndex,
                                    rowIndex: rowIndex,
                                    constraints: constraints,
                                  )
                                : GestureDetector(
                                    onTapDown: null,
                                    onTapUp: null,
                                    onTap: () async {
                                      // print('SelectCell');

                                      newCells.add(
                                          [periodIndex, rowIndex, gridIndex]);

                                      context.read<PlannerBloc>().add(
                                          SelectCell(
                                              selectedCellIDs: newCells));

                                      _dialogBuilder(newCells);

                                      // dialogBuilder.open();
                                    },
                                    onDoubleTap: () {
                                      newCells.add(
                                          [periodIndex, rowIndex, gridIndex]);
                                      deleteFromList(newCells);
                                      setState(() {});
                                    },
                                    onLongPressMoveUpdate:
                                        (LongPressMoveUpdateDetails details) {
                                      double cellWidth =
                                          (constraints.maxWidth / 7)
                                              .floorToDouble();
                                      double widthWeekPeriodRow =
                                          constraints.maxWidth -
                                              6; // 303.0, 6 - grid gap
                                      double xGlobalPosition = details
                                              .globalPosition.dx -
                                          70; // (20 : padding-right) + (50 : 04-05 hours period)

                                      for (int i = 0; i < 6; i++) {
                                        double min = cellWidth * i;
                                        double max = min + cellWidth;
                                        if (xGlobalPosition > min &&
                                            xGlobalPosition <= max) {
                                          newCells
                                              .add([periodIndex, rowIndex, i]);

                                          context
                                              .read<PlannerBloc>()
                                              .add(SelectCell(selectedCellIDs: [
                                                [periodIndex, rowIndex, i]
                                              ]));
                                        }
                                      }
                                    },
                                    onLongPressEnd: (details) {
                                      var _ids = newCells.removeDuplicates();

                                      _dialogBuilder(_ids);

                                      context.read<PlannerBloc>().add(
                                              SelectCell(selectedCellIDs: [
                                            newCells.removeDuplicates()
                                          ]));
                                      setState(() {});
                                    },
                                    child: DayPeriodCell(
                                      periodIndex: periodIndex,
                                      gridIndex: gridIndex,
                                      rowIndex: rowIndex,
                                      constraints: constraints,
                                    ),
                                  );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _dialogBuilder(ids) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        List<int> defaultMinutes = List.generate(12, (index) => (index * 5));
        List<Widget> defaultMinutesText =
            List.generate(12, (index) => Text('${index * 5}'));

        int periodStart = period[ids[0][0]].start;
        int rowIndex = ids[0][1];
        int hour = (periodStart + rowIndex).toInt();

        switch (hour) {
          case 24:
            hour = 0;
            break;
          case 25:
            hour = 1;
            break;
          case 26:
            hour = 2;
            break;
        }

        String newCellTimeString = '$hour:00';
        DateTime initialDate = DateTime.now();
        DateTime initialHour = DateTime(
            initialDate.year, initialDate.month, initialDate.day, hour, 00);

        DateTime newDate = initialHour;

        return AlertDialog(
          title: const Text('Выбрать время'),
          content: SizedBox(
            height: 150,
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(fontSize: 26),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$hour',
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 100,
                    child: CupertinoPicker(
                        itemExtent: 26,
                        onSelectedItemChanged: (index) {
                          // print(index);
                          newCellTimeString = DateFormat('Hm').format(DateTime(
                              initialDate.year,
                              initialDate.month,
                              initialDate.day,
                              hour,
                              defaultMinutes[index]));

                          // print(newCellTimeString);
                        },
                        children: defaultMinutesText),
                  ),
                ],
              ),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Отменить'),
              onPressed: () async {
                // Удаляем из стейта перекрестные значения
                context
                    .read<PlannerBloc>()
                    .add(RemoveCell(selectedCellIDs: ids));
                setState(() {});

                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Выбрать'),
              onPressed: () {
                Map data = {'startTime': newCellTimeString};

                // Удаляем из стейта перекрестные значения
                context
                    .read<PlannerBloc>()
                    .add(RemoveCell(selectedCellIDs: ids));

                // Добавляем пустое воскресенье
                List newIds = [
                  ...ids,
                  [0, 0, 6]
                ];

                addOrUpdateCellList(newIds, data);

                setState(() {});

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class DayPeriodCell extends StatefulWidget {
  final int periodIndex, rowIndex, gridIndex;
  final BoxConstraints constraints;

  const DayPeriodCell(
      {Key? key,
      required this.periodIndex,
      required this.rowIndex,
      required this.gridIndex,
      required this.constraints})
      : super(key: key);

  @override
  State<DayPeriodCell> createState() => _DayPeriodCellState();
}

class _DayPeriodCellState extends State<DayPeriodCell> {
  late int periodIndex;
  late int rowIndex;
  late int gridIndex;

  @override
  void initState() {
    periodIndex = widget.periodIndex;
    rowIndex = widget.rowIndex;
    gridIndex = widget.gridIndex;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color cellColor = gridIndex == 6
        ? const Color(0xFF00A2FF).withOpacity(0.3)
        : Colors.white;
    Color bgColor = Colors.transparent;
    Color fontColor = Colors.black;

    String textCell = '';

    final List cellsState = context.read<PlannerBloc>().state.selectedCellIDs;

    if (cellsState.isNotEmpty) {
      for (List cell in cellsState) {
        if (eq(cell, [periodIndex, rowIndex, gridIndex])) {
          cellColor = Colors.redAccent;
        }
      }
    }

    if (cells.isNotEmpty) {
      for (Map cell in cells) {
        // print('cell: $cell');
        if (eq(cell['id'], [periodIndex, rowIndex, gridIndex])) {
          cellColor = gridIndex == 6
              ? const Color(0xFF00A2FF).withOpacity(0.3)
              : const Color.fromARGB(255, 82, 194, 255);
          textCell = gridIndex == 6 ? "" : cell['startTime'] ?? '';
        }
      }
    }

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          color: cellColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textCell.isNotEmpty ? textCell : "",
                style: TextStyle(color: fontColor, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DayPeriod {
  DayPeriod({
    required this.title,
    required this.rows,
    required this.start,
    this.isExpanded = false,
  });

  String title;
  int rows;
  int start;
  bool isExpanded;
}
