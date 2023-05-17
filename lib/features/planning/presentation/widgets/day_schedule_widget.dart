import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naporoge/core/constants/app_theme.dart';

Map<String, dynamic> globalSelectedCells = {};
Map<String, dynamic> tempSelectedCells = {};

final List<DayPeriod> period = [
  DayPeriod(title: 'Утро', rows: 8, start: 4),
  DayPeriod(title: 'День', rows: 7, start: 12),
  DayPeriod(title: 'Вечер', rows: 8, start: 19),
];

final List<String> weekDaysNameRu = [
  'пн',
  'вт',
  'ср',
  'чт',
  'пт',
  'сб',
  'вс',
];

class DayScheduleWidget extends StatelessWidget {
  const DayScheduleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset('assets/icons/arrow.svg')),
              Column(
                children: [
                  Text(
                    'Недля 1/3',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text('1 декабря - 13 декабря'),
                ],
              ),
              SvgPicture.asset('assets/icons/arrow.svg'),
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
        const ExpandDayPeriod(),
      ],
    );
  }
}

class ExpandDayPeriod extends StatefulWidget {
  const ExpandDayPeriod({Key? key}) : super(key: key);

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
                  ? (period[periodIndex].rows * 45)
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
    int periodIndex = widget.periodIndex;
    Planner planner = Planner(globalSelectedCells: globalSelectedCells);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: period[periodIndex].rows,
      itemBuilder: (BuildContext context, int rowIndex) {
        String hourStart = (period[periodIndex].start + rowIndex).toString();
        String hourFinished = '';
        if (int.parse(hourStart) < 9) {
          hourStart = '0$hourStart';
          hourFinished =
              '0${(period[periodIndex].start + rowIndex + 1).toString()}';
        } else if (int.parse(hourStart) >= 9 && int.parse(hourStart) < 23) {
          hourFinished = (period[periodIndex].start + rowIndex + 1).toString();
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
                child: LayoutBuilder(builder:
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
                              onTap: () {
                                setState(() {
                                  tempSelectedCells[
                                      '$periodIndex.$rowIndex.$gridIndex'] = '';
                                });
                                print(
                                    "globalSelectedCells: $globalSelectedCells");
                                print("tempSelectedCells: $tempSelectedCells");
                                _dialogBuilder(context, period[periodIndex],
                                    tempSelectedCells);
                              },
                              onDoubleTap: () {
                                // setState(() {
                                //   tempSelectedCells.remove(['$periodIndex.$rowIndex.$gridIndex']);
                                // });
                              },
                              onLongPressMoveUpdate:
                                  (LongPressMoveUpdateDetails details) {
                                double cellWidth =
                                    (constraints.maxWidth / 7).floorToDouble();
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
                                    setState(() {
                                      tempSelectedCells[
                                          '$periodIndex.$rowIndex.$i'] = '';
                                    });
                                    print(
                                        'GridIndex: $i; Min: ${min.floorToDouble()}; Max: ${max.floorToDouble()}');
                                    print(
                                        "tempSelectedCells: $tempSelectedCells");
                                  }
                                }
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
                }),
              ),
            ],
          ),
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
  late int gridIndex;

  @override
  void initState() {
    gridIndex = widget.gridIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int periodIndex = widget.periodIndex;
    int rowIndex = widget.rowIndex;

    return Container(
      color: getColorCell(periodIndex, rowIndex, gridIndex, context),
      child: Center(child: Text('$periodIndex.$rowIndex.$gridIndex')),
    );
  }
}

Color getColorCell(periodIndex, rowIndex, gridIndex, context) {
  // print(tempSelectedCells);
  // print(globalSelectedCells);
  Color _color = Colors.white;
  if (gridIndex == 6) {
    _color = AppColor.accent.withOpacity(0.3);
  } else if (tempSelectedCells.isNotEmpty) {
    if (tempSelectedCells.keys.contains('$periodIndex.$rowIndex.$gridIndex') ||
        globalSelectedCells.keys
            .contains('$periodIndex.$rowIndex.$gridIndex')) {
      _color = AppColor.accent;
    }
  }
  return _color;
}

Column getCellData(periodIndex, rowIndex, gridIndex, context) {
  String time = '';
  if (globalSelectedCells.keys.contains('$periodIndex.$rowIndex.$gridIndex')) {
    DateTime date = globalSelectedCells['$periodIndex.$rowIndex.$gridIndex'];
    time = DateFormat('Hm').format(date);
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(time),
    ],
  );
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

class Planner {
  final Map<String, dynamic>? tempSelectedCells;
  final Map<String, dynamic>? globalSelectedCells;

  Planner({
    this.tempSelectedCells,
    this.globalSelectedCells,
  });

  void removeCell(key) {
    globalSelectedCells!.remove(key);
  }

  void clearTempSelectedIndexes() {
    tempSelectedCells!.clear();
  }

  Map<String, dynamic> setCellData(bool isFirstSelect, DateTime newDate) {
    Map<String, dynamic> newGlobalSelectedCells = {};

    if (isFirstSelect) {
      tempSelectedCells!.updateAll((key, value) => value = newDate);
      newGlobalSelectedCells = Map<String, dynamic>.from(tempSelectedCells!);
    } else {
      // Ячейки для удаления
      Set<String> prepareDeleteSelectedCells = {};

      final tempSelectedKeys = Set<String>.from(tempSelectedCells!.keys);
      final globalSelectedKeys = Set<String>.from(globalSelectedCells!.keys);

      // 1. Подготовка ячеек для удаления
      for (var oldCell in globalSelectedKeys) {
        for (var newCell in tempSelectedKeys) {
          if (oldCell.split('.')[2] == newCell.split('.')[2]) {
            prepareDeleteSelectedCells.add(oldCell);
          }
        }
      }

      // 2. Удаляем из globalSelectedCells пересечение
      globalSelectedCells!.removeWhere(
          (key, value) => prepareDeleteSelectedCells.contains(key));

      // 3. Обновляем инфу в новых ячейках
      tempSelectedCells!.updateAll((key, value) => value = newDate);

      // 4. Объединяем старые и новые ячейки
      newGlobalSelectedCells = {...globalSelectedCells!, ...tempSelectedCells!};
    }

    return newGlobalSelectedCells;
  }
}

void _dialogBuilder(
    BuildContext context, DayPeriod period, tempSelectedCells) async {
  print(period.rows);
  print(period.start);

  DateTime initialDate = DateTime.now();
  int min = (2).toInt();

  DateTime minHour =
      DateTime(initialDate.year, initialDate.month, initialDate.day, min, 00);
  DateTime maxHour =
      DateTime(initialDate.year, initialDate.month, initialDate.day, min, 55);
  DateTime newDate = minHour;

  Planner planner = Planner(
      tempSelectedCells: tempSelectedCells,
      globalSelectedCells: globalSelectedCells);

  List<Widget> defaultMinutes =
      List.generate(12, (index) => Text('${index * 5}'));

  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text('Row index 333 $min'),
        content: SizedBox(
          height: 200,
          child: CupertinoTheme(
            data: const CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(fontSize: 26),
              ),
            ),
            //Text('Cell indexes ${selectedIds.toString()}')
            // child: CupertinoDatePicker(
            //   // initialDateTime: DateTime.now().add(
            //   //   Duration(hours: min, minutes: 5 - DateTime.now().minute % 5),
            //   // ),
            //   initialDateTime: minHour,
            //   mode: CupertinoDatePickerMode.time,
            //   use24hFormat: true,
            //   minuteInterval: 5,
            //   minimumDate: minHour,
            //   maximumDate: maxHour,
            //   onDateTimeChanged: (DateTime _newDate) {
            //     newDate = _newDate;
            //     // print('newDate: $newDate');
            //   },
            // ),
            child: Row(
              children: [
                Text(period.start.toString()),
                SizedBox(
                  width: 200,
                  child: CupertinoPicker(
                      itemExtent: 20,
                      onSelectedItemChanged: (index) {},
                      children: defaultMinutes),
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
            onPressed: () {
              planner.clearTempSelectedIndexes();
              // context.read<CellProvider>().changeCellEnabled(true);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Выбрать'),
            onPressed: () {
              // context.read<CellProvider>().changeCellData(newDate);
              // context.read<CellProvider>().changeCellEnabled(true);

              // если глобальных данных нет
              if (globalSelectedCells.isEmpty) {
                globalSelectedCells = planner.setCellData(true, newDate);
              } else {
                globalSelectedCells = planner.setCellData(false, newDate);
              }
              planner.clearTempSelectedIndexes();

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
