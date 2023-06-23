import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naporoge/core/constants/app_theme.dart';

import '../bloc/planner_bloc.dart';

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
    String startDateInfo = '';

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        print(state);
        String startDateString = state.startDate;
        DateTime startDate = DateTime.parse(startDateString);
        DateTime endDate = startDate.add(const Duration(days: 20));
        startDateInfo =
            '${DateFormat('dd.MM.y').format(startDate)} - ${DateFormat('dd.MM.y').format(endDate)}';

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
                  Text(startDateInfo),
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
      },
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
                      DialogBuilder dialogBuilder = DialogBuilder(
                          context: context,
                          period: period[periodIndex],
                          periodIndex: periodIndex,
                          rowIndex: rowIndex,
                          gridIndex: gridIndex);

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
                              onTap: () {
                                // setState(() {
                                //   tempSelectedCells[
                                //       '$periodIndex.$rowIndex.$gridIndex'] = '';
                                // });
                                dialogBuilder.open();
                              },
                              onDoubleTap: () {
                                // print('globalSelectedCells: $globalSelectedCells');
                                // context.read<CellProvider>().removeGlobalSelectedCell(
                                //     '${item.panelIndex}.$rowIndex.$gridIndex');
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
                                    // setState(() {
                                    //   tempSelectedCells[
                                    //   '$periodIndex.$rowIndex.$i'] = '';
                                    // });
                                  }
                                }
                              },
                              onLongPressEnd: (details) {
                                dialogBuilder.open();
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

    // TODO: добавить стейты
    return Container(
      color: getColorCell(periodIndex, rowIndex, gridIndex, context),
      child: getCellData(periodIndex, rowIndex, gridIndex, context),
    );
  }
}

Color getColorCell(periodIndex, rowIndex, gridIndex, context) {
  // print(tempSelectedCells);
  // print(globalSelectedCells);
  Color _color = Colors.white;
  if (gridIndex == 6) {
    _color = AppColor.accent.withOpacity(0.3);
  } else {
    _color = AppColor.accent;
  }
  return _color;
}

Column getCellData(periodIndex, rowIndex, gridIndex, context) {
  String time = '14:55';

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

class DialogBuilder {
  BuildContext context;
  DayPeriod period;
  int periodIndex;
  int rowIndex;
  int gridIndex;

  DialogBuilder({
    required this.period,
    required this.periodIndex,
    required this.rowIndex,
    required this.gridIndex,
    required this.context,
  });

  List<int> defaultMinutes = List.generate(12, (index) => (index * 5));
  List<Widget> defaultMinutesText =
      List.generate(12, (index) => Text('${index * 5}'));

  Future<void> open() async {
    int hour = (period.start + rowIndex).toInt();

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

    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
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
                          print(index);
                          newCellTimeString = DateFormat('Hm').format(DateTime(
                              initialDate.year,
                              initialDate.month,
                              initialDate.day,
                              hour,
                              defaultMinutes[index]));

                          print(newCellTimeString);
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
                // await planner.clearTempSelectedIndexes();
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
                print('newCellTimeString: $newCellTimeString');
                print('newDate: $newDate');

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
