import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import 'package:collection/collection.dart';
import '../../../../core/utils/get_week_number.dart';
import '../../domain/entities/stream_entity.dart';

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

List<int> periodHeight = [220];

final List<String> weekDaysNameRu = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];

class DayScheduleStreamWidget extends StatelessWidget {
  final NPStream stream;

  const DayScheduleStreamWidget({Key? key, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int streamWeeks = stream.weeks!;

    String startDateInfo = DateFormat('dd.MM.y').format(stream.startAt!);
    DateTime now = DateTime.now();
    String weekTitle = '';
    String weekPeriod = '';
    // текущая неделя
    int weekNumber = getWeekNumber(DateTime.now());
    int daysBefore = stream.startAt!.difference(now).inDays;

    DateTime startStream = stream.startAt!;
    DateTime endStream = stream.startAt!.add(Duration(
        days: (stream.weeks! * 7) - 1, hours: 23, minutes: 59, seconds: 59));

    bool isBeforeStartStream = startStream.isAfter(now);
    bool isAfterEndStream = endStream.isBefore(now);

    // все созданные недели курса
    List createdWeeksInStream = stream.weekBacklink.toList();
    int currentWeekIndex = 0;
    int isNextWeek = 0;
    bool _isEditable = false;
    bool _previousWeekArrow = false;
    bool _nextWeekArrow = false;

    // До старта курса
    if (isBeforeStartStream) {
      print('До старта курса: isBeforeStartStream');
      DateTime nextWeek = stream.startAt!
          .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
      weekTitle = 'Неделя 1/${stream.weeks}';
      weekPeriod = '$startDateInfo - ${DateFormat('dd.MM.y').format(nextWeek)}';
    }
    // После завершения курса
    else if (isAfterEndStream) {
      print('После завершения курса: isAfterEndStream');
    }
    // Во время прохождения курса
    else if (!isBeforeStartStream && !isAfterEndStream) {
      // текущая неделя
      for (int i = 0; i < createdWeeksInStream.length; i++) {
        var instanceWeek =
            stream.weekBacklink.indexed.where((element) => element.$1 == i);
        // print(instanceWeek);
        Week week = instanceWeek.first.$2;
        // текущая неделя
        if (week.weekNumber == weekNumber) {
          currentWeekIndex = instanceWeek.first.$1;
        }
      }
      // добавляем следующую неделю на добавление,
      // если нет последней недели в курсе
      if (createdWeeksInStream.length < streamWeeks) {
        isNextWeek = 1;
      }
      // weekPeriod = startDateInfo;

      print('Во время прохождения курса: isStream');
      // print('weekNumber: $weekNumber');
      // print('currentWeekIndex: $currentWeekIndex');
      // print('streamWeeks: $streamWeeks');
      // print('created weeks: ${createdWeeksInStream.length}');
      // print('isNextWeek: ${createdWeeksInStream.length + isNextWeek}');
    }

    PageController pageController =
        PageController(initialPage: currentWeekIndex);

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (previous, current) {},
      builder: (context, state) {
        // print('wrapWeekBoxHeight: ${state.wrapWeekBoxHeight}');
        return AnimatedContainer(
          duration: const Duration(milliseconds: 10),
          height:
              state.wrapWeekBoxHeight == 0.0 ? 220 : state.wrapWeekBoxHeight,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            // текущая неделя открыта по умолчанию
            controller: pageController,
            onPageChanged: (index) {
              print('pageIndex: $index');
            },
            itemCount: createdWeeksInStream.length + isNextWeek,
            itemBuilder: (context, pageIndex) {
              weekTitle = 'Неделя ${pageIndex + 1}/$streamWeeks';
              // Формируем список заполненных дней текущей или выполненной недели
              List newDaysData = [];
              // первая неделя
              if (pageIndex == 0) {
                print('первая неделя');
                _isEditable = false;
                _nextWeekArrow = true;
                Week _week = createdWeeksInStream[pageIndex];
                List _cells = jsonDecode(_week.cells!);

                for (int i = 0; i < _cells.length; i++) {
                  // print(_cells[i]);
                  int cellIndex = _cells[i]['id'][2];

                  var _day = _week.dayBacklink.indexed
                      .where((element) => element.$1 == cellIndex);
                  Day day = _day.first.$2;
                  // START AT
                  DateTime startAtDate = DateTime.parse(
                      DateFormat('y-MM-dd').format(day.startAt!));

                  String startAtCellTimeString = DateFormat('HH:mm').format(
                      DateTime(
                          startAtDate.year,
                          startAtDate.month,
                          startAtDate.day,
                          int.parse((_cells[i]['startTime']).split(':')[0]),
                          int.parse((_cells[i]['startTime']).split(':')[1])));

                  // COMPLETED AT
                  String completedAtCellTimeString = '';
                  if (day.completedAt != null) {
                    completedAtCellTimeString =
                        DateFormat('HH:mm').format(day.completedAt!);
                    // print(
                    //     'dayCompleted: ${DateFormat('HH:mm').format(day.completedAt!)}');
                  }

                  newDaysData.addAll([
                    {
                      'day_id': day.id,
                      'cellId': _cells[i]['id'],
                      'start_at': startAtCellTimeString,
                      'completed_at': completedAtCellTimeString,
                    }
                  ]);
                }
              }
              // последняя неделя
              else if (streamWeeks == pageIndex + 1) {
                print('последняя неделя');
                _previousWeekArrow = true;
              }
              // не первая и не последняя
              else {
                print('не первая и не последняя');
                if (createdWeeksInStream.length == pageIndex) {
                  print('неделя не создана');
                  _isEditable = true;
                  _nextWeekArrow = false;
                  _previousWeekArrow = true;
                } else {
                  print('неделя создана');
                  _isEditable = false;
                }
              }

              // первый день недели
              // последний день недели
              // print('newDaysData: $newDaysData');

              // print('isEditable: $_isEditable');
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          weekTitle,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            pageIndex != 0
                                ? GestureDetector(
                                    onTap: _previousWeekArrow
                                        ? () {
                                            pageController.previousPage(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: Curves.easeIn);
                                          }
                                        : null,
                                    child: const Icon(Icons.arrow_back_ios_new),
                                  )
                                : const Icon(Icons.arrow_back_ios_new),
                            Text(weekPeriod),
                            GestureDetector(
                              onTap: () {
                                _nextWeekArrow
                                    ? pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeIn)
                                    : null;
                              },
                              child: const RotatedBox(
                                  quarterTurns: 2,
                                  child: Icon(Icons.arrow_back_ios_new)),
                            ),
                          ],
                        ),
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 1,
                          ),
                          itemCount: weekDaysNameRu.length,
                          itemBuilder: (BuildContext context, dayIndex) {
                            return Center(
                              child: Text(
                                weekDaysNameRu[dayIndex]
                                    .toString()
                                    .toUpperCase(),
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
                    isEditable: _isEditable,
                    newDaysData: newDaysData,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class ExpandDayPeriod extends StatefulWidget {
  final bool isEditable;
  final List newDaysData;

  const ExpandDayPeriod(
      {Key? key, required this.isEditable, required this.newDaysData})
      : super(key: key);

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

  onCollapseToggle(val) async {
    for (int i = 0; i < period.length; i++) {
      if (i == val && period[val].isExpanded) {
        setState(() {
          period[val].isExpanded = false;
        });

        periodHeight.remove((period[val].rows * 43).toInt());
        if (context.mounted) {
          context.read<PlannerBloc>().add(WrapWeekBoxHeightStream(
              wrapWeekBoxHeight: periodHeight.fold(0, (a, b) => a + b)));
        }
      } else if (i == val && !period[val].isExpanded) {
        setState(() {
          period[val].isExpanded = true;
        });
        periodHeight.addAll([(period[val].rows * 43).toInt()]);
        if (context.mounted) {
          context.read<PlannerBloc>().add(WrapWeekBoxHeightStream(
              wrapWeekBoxHeight: periodHeight.fold(0, (a, b) => a + b)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: period.length,
      itemBuilder: (BuildContext context, periodIndex) {
        return Column(
          children: [
            GestureDetector(
              onTap: () async {
                await onCollapseToggle(periodIndex);
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
              duration: const Duration(milliseconds: 200),
              height: period[periodIndex].isExpanded
                  ? (period[periodIndex].rows * 43)
                  : 0,
              child: DayPeriodRow(
                  periodIndex: periodIndex,
                  isEditable: widget.isEditable,
                  newDaysData: widget.newDaysData),
            )
          ],
        );
      },
    );
  }
}

class DayPeriodRow extends StatefulWidget {
  final int periodIndex;
  final bool isEditable;
  final List newDaysData;

  const DayPeriodRow(
      {Key? key,
      required this.periodIndex,
      required this.isEditable,
      required this.newDaysData})
      : super(key: key);

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
                        // print('widget.isEditable: ${widget.isEditable}');
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
                            // print('newDaysData: ${widget.newDaysData}');
                            Map dayData = {};
                            if (!widget.isEditable) {
                              for (int i = 0;
                                  i < widget.newDaysData.length;
                                  i++) {
                                // {day_id: 725, cellId: [0, 0, 0], start_at: 04:10, completed_at: 02:50}
                                // находим нужные ячейки для заполнения
                                if (eq(widget.newDaysData[i]['cellId'],
                                    [periodIndex, rowIndex, gridIndex])) {
                                  // print(widget.newDaysData[i]);
                                  dayData = widget.newDaysData[i];
                                }
                                // print(
                                //     [periodIndex, rowIndex, gridIndex] is List);
                              }
                            }
                            // проверки:
                            // выполнение дня, пропуск и тп
                            return !widget.isEditable
                                ? DayPeriodExistedCell(
                                    periodIndex: periodIndex,
                                    gridIndex: gridIndex,
                                    rowIndex: rowIndex,
                                    constraints: constraints,
                                    dayData: dayData,
                                  )
                                : GestureDetector(
                                    onTapDown: null,
                                    onTapUp: null,
                                    onTap: () async {
                                      print(
                                          '$periodIndex, $rowIndex, $gridIndex');
                                      newCells.add(
                                          [periodIndex, rowIndex, gridIndex]);

                                      context.read<PlannerBloc>().add(
                                          SelectCell(
                                              selectedCellIDs: newCells));

                                      _dialogBuilder(newCells);
                                      setState(() {});
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
                                          // print('$periodIndex, $rowIndex, $i');

                                          // newCells
                                          //     .add([periodIndex, rowIndex, i]);

                                          context
                                              .read<PlannerBloc>()
                                              .add(SelectCell(selectedCellIDs: [
                                                [periodIndex, rowIndex, i]
                                              ]));
                                        }
                                      }
                                    },
                                    onLongPressEnd: (details) {
                                      var _newCells = state.selectedCellIDs;
                                      var _ids = _newCells.removeDuplicates();

                                      _dialogBuilder(_ids);

                                      context.read<PlannerBloc>().add(
                                              SelectCell(selectedCellIDs: [
                                            _newCells.removeDuplicates()
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

                context
                    .read<PlannerBloc>()
                    .add(FinalCellForCreateStream(finalCellIDs: cells));

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

class DayPeriodExistedCell extends StatefulWidget {
  final int periodIndex, rowIndex, gridIndex;
  final BoxConstraints constraints;
  final Map dayData;

  const DayPeriodExistedCell(
      {super.key,
      required this.periodIndex,
      required this.rowIndex,
      required this.gridIndex,
      required this.constraints,
      required this.dayData});

  @override
  State<DayPeriodExistedCell> createState() => _DayPeriodExistedCellState();
}

class _DayPeriodExistedCellState extends State<DayPeriodExistedCell> {
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
    Color fontColor = AppColor.grey3;
    Color fontColorCompleted = Colors.black;
    Color bgColorCompleted = AppColor.grey3;

    String textCell = '';

    Map dayData = widget.dayData;
    // print('dayData: $dayData');

    String startAt = '';
    String completedAt = '';
    //{day_id: 730, cellId: [2, 1, 5], start_at: 20:15, completed_at: }
    if (dayData.isNotEmpty) {
      if (gridIndex != 6) {
        startAt = dayData['start_at'];
        completedAt = dayData['completed_at'];
        bgColorCompleted = AppColor.accent.withOpacity(0.4);
        if (dayData['start_at'] == dayData['completed_at']) {
          // выполнено вовремя
          // print('вовремя: $dayData');
          bgColorCompleted = AppColor.accent;
        }
      } else {
        completedAt = dayData['completed_at'];
      }
    }

    return Container(
      color: cellColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          completedAt.isEmpty
              ? Text(
                  startAt,
                  style: TextStyle(color: fontColor, fontSize: 12),
                )
              : const SizedBox(),
          completedAt.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: bgColorCompleted,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    completedAt,
                    style: TextStyle(color: fontColorCompleted, fontSize: 12),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
