import 'package:flutter/material.dart';

import '../../../../../core/constants/app_theme.dart';
import '../core.dart';

///////////////////////////
// Редактируемая неделя
///////////////////////////

class EditableDayPeriodRow extends StatefulWidget {
  final int periodIndex;
  final List daysData;

  const EditableDayPeriodRow(
      {super.key, required this.periodIndex, required this.daysData});

  @override
  State<EditableDayPeriodRow> createState() => _EditableDayPeriodRowState();
}

class _EditableDayPeriodRowState extends State<EditableDayPeriodRow> {
  Map dayData = {};

  @override
  Widget build(BuildContext context) {
    List daysData = widget.daysData;
    final periodIndex = widget.periodIndex;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: periodRows[periodIndex].rows,
      itemBuilder: (context, rowIndex) {
        String hourStart =
            (periodRows[periodIndex].start + rowIndex).toString();
        String hourFinished = '';
        if (int.parse(hourStart) < 9) {
          hourStart = '0$hourStart';
          hourFinished =
              '0${(periodRows[periodIndex].start + rowIndex + 1).toString()}';
        } else if (int.parse(hourStart) >= 9 && int.parse(hourStart) < 23) {
          hourFinished =
              (periodRows[periodIndex].start + rowIndex + 1).toString();
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
                  builder: (BuildContext context, BoxConstraints constraints) {
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
                        // формируем данные ячейки
                        for (int i = 0; i < daysData.length; i++) {
                          if (eq(daysData[i]['cellId'],
                              [periodIndex, rowIndex, gridIndex])) {
                            // print(widget.newDaysData[i]);
                            dayData = daysData[i];
                          }
                        }

                        return EditableDayPeriodCell(
                          periodIndex: periodIndex,
                          gridIndex: gridIndex,
                          rowIndex: rowIndex,
                          dayData: dayData,
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
  }
}

class EditableDayPeriodCell extends StatefulWidget {
  final Map dayData;
  final int periodIndex, rowIndex, gridIndex;

  const EditableDayPeriodCell(
      {super.key,
      required this.dayData,
      required this.periodIndex,
      required this.rowIndex,
      required this.gridIndex});

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
    Color cellColor = gridIndex == 6
        ? const Color(0xFF00A2FF).withOpacity(0.3)
        : Colors.white;

    Color fontColor = AppColor.blk;
    Color badgeColor = AppColor.grey1.withOpacity(0);
    String textCell = '';

    // print('dayData: $dayData');

    if (dayData.isNotEmpty) {
      // {day_id: 825, cellId: [0, 2, 2], start_at: 06:10, completed_at: 16:00}

      if (eq(dayData['cellId'], [periodIndex, rowIndex, gridIndex])) {
        // print(dayData);
        int dayIndex = gridIndex + 1;

        // print('dayData: $dayData');

        // проверка на статусы выполнения
        // текущий день
        if (now.weekday == dayIndex) {
          // если не воскресенье
          if (dayIndex != 7) {
            // не выполнен
            if (dayData['completed_at'].isEmpty) {
              badgeColor = AppColor.grey1;
              textCell = dayData['start_at'];
            }
            // выполнен
            else {
              if (dayData['newCellId'] != null) {
                badgeColor = AppColor.accent.withOpacity(0.5);
                textCell = dayData['completed_at'];
              } else if (dayData['oldCellId'] != null) {
                badgeColor = AppColor.accent.withOpacity(0);
                textCell = dayData['start_at'];
              } else if (dayData['day_matches'] != null) {
                badgeColor = AppColor.accent;
                textCell = dayData['completed_at'];
              }
            }
          }
          // если воскресенье
          else {
            // не выполнен
            if (dayData['completed_at'].isEmpty) {
              textCell = ''; // скрываем время ячейки
            }
            // выполнен
            else {
              if (dayData['oldCellId'] != null) {
                // скрываем значение по умолчанию ячейки
                textCell = '';
              } else if (dayData['newCellId'] != null) {
                textCell = dayData['completed_at'];
                fontColor = AppColor.red;
              }
            }
          }
        }
        // день прошел
        else if (now.weekday > dayIndex) {
          // не выполнен
          if (dayData['completed_at'].isEmpty) {
            badgeColor = AppColor.red;
            textCell = dayData['start_at'];
          }
          // выполнен
          else {
            if (dayData['newCellId'] != null) {
              badgeColor = AppColor.accent.withOpacity(0.5);
              textCell = dayData['completed_at'];
            } else if (dayData['oldCellId'] != null) {
              badgeColor = AppColor.accent.withOpacity(0);
              textCell = dayData['start_at'];
            } else if (dayData['day_matches'] != null) {
              badgeColor = AppColor.accent;
              textCell = dayData['completed_at'];
            }
          }
        }
        // запланированный день
        else {
          // если не воскресенье
          if (gridIndex != 6) {
            badgeColor = AppColor.grey1;
            textCell = dayData['start_at'];
          } else {
            badgeColor = AppColor.grey1.withOpacity(0);
            fontColor = AppColor.red;
          }
        }
      }
    }

    return Container(
      color: cellColor,
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
              style: TextStyle(color: fontColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
