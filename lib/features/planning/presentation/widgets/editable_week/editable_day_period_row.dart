import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_theme.dart';
import '../../bloc/planner_bloc.dart';
import '../core.dart';

///////////////////////////
// Редактируемая неделя
///////////////////////////

List<Map> cells = [];
List<List> newCellsList = [];
List<List> deleteCellsList = [];

void deleteFromList(List deleteCellsList) {
  for (List deleteCell in deleteCellsList) {
    cells.removeWhere((cell) => eq(cell['cellId'], deleteCell));
  }
}

void addOrUpdateCellList(newCellsList, cellData) {
  // Существующие ячейки
  List existingCell = [];

  // если есть активные ячейки
  if (cells.isNotEmpty) {
    List globalCellsIDs = cells.map((e) => e['cellId']).toList();

    // print('Входящий список для обновления данными');
    // print('Входящий новый список: $newCellsList');
    for (List newCellId in newCellsList) {
      existingCell.addAll(globalCellsIDs.where((cellID) => eq(cellID, newCellId)));
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
        'cellId': newCellId,
        'startTime': cellData['startTime'],
      },
    ];

    cells.addAll(addNewMapToCell);
    // добавляем пустое воскресенье
  }

  // print('AFTER ADD or UPDATE: $cells');
}

class EditableDayPeriodRow extends StatefulWidget {
  final int periodIndex;
  final List daysData;

  const EditableDayPeriodRow({super.key, required this.periodIndex, required this.daysData});

  @override
  State<EditableDayPeriodRow> createState() => _EditableDayPeriodRowState();
}

class _EditableDayPeriodRowState extends State<EditableDayPeriodRow> {
  Map dayData = {};

  @override
  initState() {
    // сброс состояния выбранных ячеек для вывода подсказок
    cells = [];
    super.initState();
  }

  _dialogBuilder(ids) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        List<int> defaultMinutes = List.generate(12, (index) => (index * 5));
        List<Widget> defaultMinutesText = List.generate(12, (index) => Text('${index * 5}'));

        // TODO: RangeError (index): Invalid value: Valid value range is empty: 0
        // TODO: Решить проблему
        int periodStart = periodRows[ids[0][0]].start;
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
        DateTime initialHour = DateTime(initialDate.year, initialDate.month, initialDate.day, hour, 00);

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
                              initialDate.year, initialDate.month, initialDate.day, hour, defaultMinutes[index]));

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
                context.read<PlannerBloc>().add(RemoveCell(selectedCellIDs: ids));
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
                context.read<PlannerBloc>().add(RemoveCell(selectedCellIDs: ids));

                // Добавляем пустое воскресенье
                List newIds = [
                  ...ids,
                  [0, 0, 6]
                ];

                addOrUpdateCellList(newIds, data);

                context.read<PlannerBloc>().add(FinalCellForCreateStream(finalCellIDs: cells));

                setState(() {});

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List daysData = widget.daysData;
    List newCells = [];
    context.read<PlannerBloc>().add(const PlanningConfirmBtnStream(isPlanningConfirmBtn: true));

    final int periodIndex = widget.periodIndex;

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: periodRows[periodIndex].rows,
          itemBuilder: (context, rowIndex) {
            String hourStart = (periodRows[periodIndex].start + rowIndex).toString();
            String hourFinished = '';
            if (int.parse(hourStart) < 9) {
              hourStart = '0$hourStart';
              hourFinished = '0${(periodRows[periodIndex].start + rowIndex + 1).toString()}';
            } else if (int.parse(hourStart) >= 9 && int.parse(hourStart) < 23) {
              hourFinished = (periodRows[periodIndex].start + rowIndex + 1).toString();
            } else if (int.parse(hourStart) == 23) {
              hourFinished = '00';
            } else if (int.parse(hourStart) > 23) {
              hourStart = '0${(rowIndex - 5).toString()}';
              hourFinished = '0${(rowIndex - 4).toString()}';
            }

            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: AppColor.grey1),
                ),
              ),
              height: 41,
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    width: 49,
                    child: Center(
                      child: Text(
                        '$hourStart - $hourFinished',
                        style: TextStyle(fontSize: AppFont.smaller, color: AppColor.grey3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        // print('widget.isEditable: ${widget.isEditable}');
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 0,
                          ),
                          itemCount: 7,
                          itemBuilder: (BuildContext context, gridIndex) {
                            // формируем данные ячейки
                            // TODO: неверно формируются ячеки, нет соответствия
                            for (int i = 0; i < daysData.length; i++) {
                              // print("daysData: ${daysData[i]}");
                              if (eq(daysData[i]['cellId'], [periodIndex, rowIndex, gridIndex])) {
                                // print(widget.newDaysData[i]);
                                dayData = daysData[i];
                              }
                            }

                            return GestureDetector(
                              onTapDown: null,
                              onTapUp: null,
                              onTap: () async {
                                // print(
                                //     '$periodIndex, $rowIndex, $gridIndex');
                                newCells.add([periodIndex, rowIndex, gridIndex]);

                                context.read<PlannerBloc>().add(SelectCell(selectedCellIDs: newCells));

                                _dialogBuilder(newCells);
                                setState(() {});
                              },
                              onDoubleTap: () {
                                newCells.add([periodIndex, rowIndex, gridIndex]);
                                deleteFromList(newCells);
                                setState(() {});
                              },
                              onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
                                double cellWidth = (constraints.maxWidth / 7).floorToDouble();
                                double widthWeekPeriodRow = constraints.maxWidth - 6; // 303.0, 6 - grid gap
                                double xGlobalPosition =
                                    details.globalPosition.dx - 70; // (20 : padding-right) + (50 : 04-05 hours period)

                                for (int i = 0; i < 6; i++) {
                                  double min = cellWidth * i;
                                  double max = min + cellWidth;
                                  if (xGlobalPosition > min && xGlobalPosition <= max) {
                                    // print('$periodIndex, $rowIndex, $i');

                                    // newCells
                                    //     .add([periodIndex, rowIndex, i]);

                                    context.read<PlannerBloc>().add(SelectCell(selectedCellIDs: [
                                          [periodIndex, rowIndex, i]
                                        ]));
                                  }
                                }
                              },
                              onLongPressEnd: (details) {
                                var _newCells = state.selectedCellIDs;
                                var _ids = _newCells.removeDuplicates();

                                _dialogBuilder(_ids);

                                context
                                    .read<PlannerBloc>()
                                    .add(SelectCell(selectedCellIDs: [_newCells.removeDuplicates()]));
                                setState(() {});
                              },
                              child: EditableDayPeriodCell(
                                periodIndex: periodIndex,
                                gridIndex: gridIndex,
                                rowIndex: rowIndex,
                                dayData: dayData,
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
}

class EditableDayPeriodCell extends StatefulWidget {
  final Map dayData;
  final BoxConstraints constraints;
  final int periodIndex, rowIndex, gridIndex;

  const EditableDayPeriodCell(
      {super.key,
      required this.dayData,
      required this.periodIndex,
      required this.rowIndex,
      required this.gridIndex,
      required this.constraints});

  @override
  State<EditableDayPeriodCell> createState() => _EditableDayPeriodCellState();
}

class _EditableDayPeriodCellState extends State<EditableDayPeriodCell> {
  @override
  Widget build(BuildContext context) {
    Map dayData = widget.dayData;
    int periodIndex = widget.periodIndex;
    int rowIndex = widget.rowIndex;
    int gridIndex = widget.gridIndex;

    DateTime now = DateTime.now();
    Color cellColor = gridIndex == 6 ? const Color(0xFF00A2FF).withOpacity(0.3) : Colors.white;

    Color fontColor = AppColor.blk;
    Color badgeColor = AppColor.grey1.withOpacity(0);
    String textCell = '';

    final List cellsState = context.read<PlannerBloc>().state.selectedCellIDs;

    // вывод ячеек стейта при выборе
    if (cellsState.isNotEmpty) {
      for (List cell in cellsState) {
        if (eq(cell, [periodIndex, rowIndex, gridIndex])) {
          // print('cellsState: $cellsState');
          cellColor = Colors.redAccent;
        }
      }
    }

    // print('cells 333: $cells');
    if (cells.isNotEmpty) {
      for (Map cell in cells) {
        if (eq(cell['cellId'], [periodIndex, rowIndex, gridIndex])) {
          // print('cell 22: $cell');
          badgeColor = gridIndex == 6 ? Colors.transparent : AppColor.grey1;
          textCell = gridIndex == 6 ? "" : cell['startTime'] ?? '';
        }
      }
    }
    // вывод подсказок
    else {
      // {day_id: 921, cellId: [2, 2, 0], start_at: 19:00, completed_at: }

      if (eq(dayData['cellId'], [periodIndex, rowIndex, gridIndex])) {
        // print('dayData: $dayData');
        int dayIndex = gridIndex + 1;

        // если не воскресенье
        if (dayIndex != 7) {
          badgeColor = Colors.white;
          textCell = dayData['start_at'];
          fontColor = AppColor.grey2;
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(width: 1, color: AppColor.grey1)),
        color: cellColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              textCell,
              style: TextStyle(color: fontColor, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
