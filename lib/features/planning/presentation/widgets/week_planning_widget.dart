import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/get_stream_status.dart';
import '../../domain/entities/stream_entity.dart';
import '../../data/sources/local/stream_local_storage.dart';
import '../bloc/planner_bloc.dart';
import 'core.dart';
import 'editable_week/editable_day_period_row.dart';
import 'utils/get_week_data.dart';

List<Map> cells = [];
List<List> newCellsList = [];
List<List> deleteCellsList = [];

Future getWeeksData() async {
  await Future.delayed(const Duration(milliseconds: 500));

  // данные всех недель
  Map weeksData = {};

  final storage = StreamLocalStorage();
  NPStream stream = await storage.getActiveStream();
  // всего недель на курсе
  int weeks = stream.weeks!;
  weeksData['stream'] = stream;
  weeksData['weeks'] = weeks;
  // создано недель на курсе
  weeksData['existsWeeks'] = stream.weekBacklink.length;
  // статус курса (before, after, process)
  Map streamStatus = await getStreamStatus();

  // print('streamStatus: $streamStatus');

  // формирование недели по умолчанию при открытии Календаря
  // До старта курса
  if (streamStatus['status'] == 'before') {
    Map _weekData = await getWeekData(stream, 'before');

    // добавляем после
    weeksData['weeksOnPage'] = _weekData['weeksOnPage'];
    weeksData['allPages'] = _weekData['allPages'];
    weeksData['defaultPageIndex'] = _weekData['defaultPageIndex'];

    // print('streamStatus before: $streamStatus');
  }
  // После окончания курса
  else if (streamStatus['status'] == 'after') {
    Map _weekData = await getWeekData(stream, 'after');

    // добавляем после
    weeksData['weeksOnPage'] = _weekData['weeksOnPage'];
    weeksData['allPages'] = _weekData['allPages'];
    weeksData['defaultPageIndex'] = _weekData['defaultPageIndex'];
  }
  // Во время прохождения курса
  else if (streamStatus['status'] == 'process') {
    // print('streamStatus 2: $streamStatus');
    Map _weekData = await getWeekData(stream, 'process');

    // добавляем после
    weeksData['weeksOnPage'] = _weekData['weeksOnPage'];
    weeksData['allPages'] = _weekData['allPages'];
    weeksData['defaultPageIndex'] = _weekData['defaultPageIndex'];
  }

  return weeksData;
}

class WeekPlanningWidget extends StatefulWidget {
  final NPStream stream;

  const WeekPlanningWidget({super.key, required this.stream});

  @override
  State<WeekPlanningWidget> createState() => _WeekPlanningWidgetState();
}

class _WeekPlanningWidgetState extends State<WeekPlanningWidget> {
  late Future weeksData;
  late PageController pageController;
  late int _pageIndex;

  @override
  void initState() {
    weeksData = getWeeksData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // сброс высоты периодов для
    // корректного рассчета при переходах между экранами
    defaultAllTitleHeight = 270;

    return FutureBuilder(
        future: weeksData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map pageData = snapshot.data;
            // print('pageData 333: $pageData');
            // print('weeksOnPage: ${pageData['weeksOnPage'][0]}');

            _pageIndex = pageData['defaultPageIndex'];
            NPStream stream = pageData['stream'];
            int weeks = pageData['weeks'];
            int allPages = pageData['allPages'];

            // страница по умолчанию
            pageController = PageController(initialPage: _pageIndex);

            return BlocConsumer<PlannerBloc, PlannerState>(
              listener: (context, state) {},
              builder: (context, state) {
                double wrapHeight =
                    defaultAllTitleHeight + context
                        .read<PlannerBloc>()
                        .state
                        .wrapWeekBoxHeight
                        .toDouble();
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  height: wrapHeight,
                  child: PageView.builder(
                      controller: pageController,
                      itemCount: allPages,
                      itemBuilder: (context, pageIndex) {
                        String pageTitle = "Неделя  ${pageIndex + 1}/$weeks";
                        String weekMonday = DateFormat('dd.MM').format(pageData['weeksOnPage'][pageIndex]['monday']);
                        String weekSunday = DateFormat('dd.MM').format(pageData['weeksOnPage'][pageIndex]['sunday']);
                        String weekPeriod = "$weekMonday - $weekSunday";

                        // план не составлялся
                        Map isPlannedWeek = {};
                        if (pageData['weeksOnPage'][pageIndex]['cellsWeekData'][0]['start_at'] == '') {
                          isPlannedWeek['title'] = 'План не составлен';
                          isPlannedWeek['color'] = AppColor.red;
                        } else {
                          isPlannedWeek['title'] = 'План составлен';
                          isPlannedWeek['color'] = AppColor.primary;
                        }


                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // Навигация по неделям и период недели
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    pageTitle,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          // сброс раздела Планирование
                                          // при переходе по вкладкам
                                          // необходим для сброса стейта с финальными ячейками
                                          // если пользователь ушёл с планнера без сохранения
                                          context
                                              .read<PlannerBloc>()
                                              .add(const FinalCellForCreateStream(finalCellIDs: []));

                                          pageController.previousPage(
                                              duration: const Duration(milliseconds: 10), curve: Curves.easeIn);
                                        },
                                        child: const Icon(Icons.arrow_back_ios_new),
                                      ),
                                      Text(weekPeriod),
                                      GestureDetector(
                                        onTap: () async {
                                          // сброс раздела Планирование
                                          // при переходе по вкладкам
                                          // необходим для сброса стейта с финальными ячейками
                                          // если пользователь ушёл с планнера без сохранения
                                          context
                                              .read<PlannerBloc>()
                                              .add(const FinalCellForCreateStream(finalCellIDs: []));

                                          pageController.nextPage(
                                              duration: const Duration(milliseconds: 10), curve: Curves.easeIn);
                                        },
                                        child: const RotatedBox(quarterTurns: 2, child: Icon(Icons.arrow_back_ios_new)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Дни недели
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
                                              color:
                                              weekDaysNameRu[dayIndex] == 'вс' ? AppColor.grey2 : AppColor.accent),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            ExpandDayPeriod(stream: stream, pageData: pageData, pageIndex: pageIndex),
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                height: 50,
                                child: Text(isPlannedWeek['title'], style: TextStyle(color: isPlannedWeek['color']),),
                              ),
                            ),
                          ],
                        );
                      }),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class ExpandDayPeriod extends StatefulWidget {
  final NPStream stream;
  final Map pageData;
  final int pageIndex;

  const ExpandDayPeriod({super.key, required this.pageData, required this.pageIndex, required this.stream});

  @override
  State<ExpandDayPeriod> createState() => _ExpandDayPeriodState();
}

class _ExpandDayPeriodState extends State<ExpandDayPeriod> {
  late bool isExpanded;
  late Map pageData;
  late int pageIndex;

  final List<NPDayPeriod> period = [
    NPDayPeriod(title: 'Утро', rows: 8, start: 4),
    NPDayPeriod(title: 'День', rows: 7, start: 12),
    NPDayPeriod(title: 'Вечер', rows: 8, start: 19),
  ];

  @override
  void initState() {
    isExpanded = false;
    pageData = widget.pageData;
    pageIndex = widget.pageIndex;

    buildDefaultWeekPeriod();

    super.initState();
  }

  buildDefaultWeekPeriod() {
    // сброс высоты всех страниц
    weeksPeriodsHeight = [];
    // сброс высоту периода в стейте
    context.read<PlannerBloc>().add(const WrapWeekBoxHeightStream(wrapWeekBoxHeight: 0));
    // print('pageData 11: $pageData');
    // перебираем недели
    for (Map page in pageData['weeksOnPage']) {
      // если входящий индекс страницы совпадает с недельным
      if (pageIndex == page['pageIndex']) {
        // print('pageData 11: $pageData');
        weeksPeriodsHeight.add({
          "pageIndex": page['pageIndex'],
          "height": [],
          "periodIndex": page['weekOpenedPeriod'], // [0, 2, 1]
        });
        // // если есть заполненные ячейки
        // if (page['weekOpenedPeriod'].isNotEmpty) {
        //   // print('page weekOpenedPeriod: ${page['weekOpenedPeriod']}');
        //   weeksPeriodsHeight.add({
        //     "pageIndex": page['pageIndex'],
        //     "height": [],
        //     "periodIndex": page['weekOpenedPeriod'], // [0, 2, 1]
        //   });
        // } else {
        //   weeksPeriodsHeight.add({
        //     "pageIndex": page['pageIndex'],
        //     "height": [],
        //     "periodIndex": page['weekOpenedPeriod'], // [0, 2, 1]
        //   });
        // }
      }
    }

    // если есть заполненные ячейки страницы - открываем периоды
    if (weeksPeriodsHeight.isNotEmpty) {
      // print('weeksPeriodsHeight: $weeksPeriodsHeight');
      if (weeksPeriodsHeight[0]['periodIndex'].isNotEmpty) {
        for (int i = 0; i < weeksPeriodsHeight[0]['periodIndex'].length; i++) {
          int periodIndex = weeksPeriodsHeight[0]['periodIndex'][i];
          onCollapseToggle(periodIndex, pageIndex);
        }
      }
    }
  }

  onCollapseToggle(val, pageIndex) {
    // print('val: $val, pageIndex: $pageIndex, period.length: ${period.length}');
    for (int i = 0; i < period.length; i++) {
      if (i == val && period[val].isExpanded) {
        setState(() {
          period[val].isExpanded = false;
        });

        // удаляем высоту периода в списке
        weeksPeriodsHeight[0]['height'].remove((period[val].rows * 43).toInt());

        // удаляем высоту периода в стейте
        context
            .read<PlannerBloc>()
            .add(WrapWeekBoxHeightStream(wrapWeekBoxHeight: weeksPeriodsHeight[0]['height'].fold(0, (a, b) => a + b)));
      } else if (i == val && !period[val].isExpanded) {
        // print('open: ${weeksPeriodsHeight}');
        setState(() {
          period[val].isExpanded = true;
        });

        // добавляем высоту периода в список
        weeksPeriodsHeight[0]['height'].addAll([(period[val].rows * 43).toInt()]);

        // добавляем высоту периода в стейт
        context
            .read<PlannerBloc>()
            .add(WrapWeekBoxHeightStream(wrapWeekBoxHeight: weeksPeriodsHeight[0]['height'].fold(0, (a, b) => a + b)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditable = pageData['weeksOnPage'][pageIndex]['isEditable'] ?? false;
    List cellsData = pageData['weeksOnPage'][pageIndex]['cellsWeekData'];

    // print('weeksOnPage: ${pageData['weeksOnPage'][pageIndex]}');

    // выводим кнопку План мне подходит
    // если неделя редактируемая
    context.read<PlannerBloc>().add(PlanningConfirmBtnStream(isPlanningConfirmBtn: isEditable));

    // добавляем в стейт данные по редактируемой неделе
    // если ячейки дней не созданы
    context.read<PlannerBloc>().add(EditableWeekStream(editableWeekData: {
      'weekId': pageData['weeksOnPage'][pageIndex]['weekId'],
      'monday': pageData['weeksOnPage'][pageIndex]['monday'],
      'weekOfYear': pageData['weeksOnPage'][pageIndex]['weekOfYear'],
    }));

    // print("ячейки дней : ${pageData['weeksOnPage'][pageIndex]['weekId']}");
    //
    // print(
    //     "ячейки дней : ${pageData['weeksOnPage'][pageIndex]['cellsWeekData'].isEmpty}");
    // print('ExpandDay weeksPeriodsHeight: $weeksPeriodsHeight');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: period.length,
      itemBuilder: (context, periodIndex) {
        return Column(
          children: [
            GestureDetector(
              onTap: () async {
                // print('periodIndex: $periodIndex');
                onCollapseToggle(periodIndex, pageIndex);
              },
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(bottom: 2),
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 6, right: 10),
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
              height: period[periodIndex].isExpanded ? (period[periodIndex].rows * 43) : 0,
              child: isEditable
                  ? EditableDayPeriodRow(
                periodIndex: periodIndex,
                daysData: cellsData,
              )
                  : DayPeriodRow(
                periodIndex: periodIndex,
                daysData: cellsData,
                weeksOnPage: pageData['weeksOnPage'][pageIndex],
                stream: widget.stream,
              ),
            ),
          ],
        );
      },
    );
  }
}

class DayPeriodRow extends StatefulWidget {
  final int periodIndex;
  final List daysData;
  final Map weeksOnPage;
  final NPStream stream;

  const DayPeriodRow(
      {super.key, required this.periodIndex, required this.daysData, required this.weeksOnPage, required this.stream});

  @override
  State<DayPeriodRow> createState() => _DayPeriodRowState();
}

class _DayPeriodRowState extends State<DayPeriodRow> {
  @override
  Widget build(BuildContext context) {
    List daysData = widget.daysData;
    final periodIndex = widget.periodIndex;

    // print('weekOnPage: ${widget.weeksOnPage}');
    // print('daysData: $daysData');

    Week week = widget.stream.weekBacklink
        .where((week) => week.id == widget.weeksOnPage['weekId'])
        .first;
    // print('week: ${week}');

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
                    style: TextStyle(fontSize: AppFont.smaller, color: AppColor.grey3),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: 7,
                      itemBuilder: (BuildContext context, gridIndex) {
                        // формируем данные ячейки
                        Map dayData = {};

                        for (int i = 0; i < daysData.length; i++) {
                          if (eq(daysData[i]['cellId'], [periodIndex, rowIndex, gridIndex])) {
                            // print('daysData[i] : ${daysData[i]}');
                            // Находим объект ДНЯ и добавляем
                            Day day = week.dayBacklink
                                .where((day) => day.id == daysData[i]['day_id'])
                                .first;
                            // print("day: ${day.completedAt}");
                            dayData = {
                              ...daysData[i],
                              ...{'day': day}
                            };

                            // print('dayData: ${dayData}');
                            // print('day: ${week.dayBacklink.where((day) => day.id == daysData[i]['day_id']).first}');
                          }
                        }
                        // print('dayData: ${dayData}');

                        return DayPeriodExistedCell(
                          periodIndex: periodIndex,
                          gridIndex: gridIndex,
                          rowIndex: rowIndex,
                          dayData: dayData,
                          weeksOnPage: widget.weeksOnPage,
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

class DayPeriodExistedCell extends StatefulWidget {
  final Map dayData;
  final Map weeksOnPage;
  final int periodIndex, rowIndex, gridIndex;

  const DayPeriodExistedCell({super.key,
    required this.dayData,
    required this.periodIndex,
    required this.rowIndex,
    required this.gridIndex,
    required this.weeksOnPage});

  @override
  State<DayPeriodExistedCell> createState() => _DayPeriodExistedCellState();
}

class _DayPeriodExistedCellState extends State<DayPeriodExistedCell> {
  @override
  Widget build(BuildContext context) {
    Map dayData = widget.dayData;
    int periodIndex = widget.periodIndex;
    int rowIndex = widget.rowIndex;
    int gridIndex = widget.gridIndex;

    // print('dayData: $dayData');

    Color cellColor = gridIndex == 6 ? const Color(0xFF00A2FF).withOpacity(0.3) : Colors.white;

    Color fontColor = AppColor.blk;
    Color badgeColor = AppColor.grey1.withOpacity(0);
    String textCell = '';

    // print('dayData: $dayData');
    if (dayData.isNotEmpty) {
      // print('day: ${day}');

      // {day_id: 1029, cellId: [0, 6, 2], start_at: 08:00, completed_at: 10:00, newCellId: true}
      // {day_id: 1029, cellId: [0, 4, 2], start_at: 08:00, completed_at: 10:00, oldCellId: true}
      // {day_id: 1026, cellId: [0, 5, 0], start_at: 09:00, completed_at: 09:55, day_matches: true}
      if (eq(dayData['cellId'], [periodIndex, rowIndex, gridIndex])) {
        int dayIndex = gridIndex + 1;
        DateTime now = DateTime.parse(DateFormat('y-MM-dd').format(DateTime.now()));
        Day day = dayData['day'];

        // print('dayData[statusCell] : ${dayData['statusCell']}');
        // если дни недели созданы и ячейка не подсказка
        if (dayData['statusCell'] == null) {
          DateTime dayStartAt = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

          // String? completedAt = DateFormat('Y-mm-dd').format(day.completedAt);

          // print('dayStartAt: $dayStartAt, ${dayStartAt.isAtSameMomentAs(now)}');
          // print('isAfter: $dayStartAt, ${dayStartAt.isAfter(now)}');
          // print('isBefore: $dayStartAt, ${dayStartAt.isBefore(now)}');
          // print('now: ${DateTime.parse(DateFormat('y-MM-dd').format(now))}');

          ///////////////////////////////////////////
          // проверка на статусы выполнения
          ///////////////////////////////////////////
          // текущий день
          if (dayStartAt.isAtSameMomentAs(now)) {
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
          else if (dayStartAt.isBefore(now)) {
            // если не воскресенье
            if (dayIndex != 7) {
              // print('dayData: $dayData');
              // не выполнен
              if (day.completedAt == null) {
                badgeColor = AppColor.red;
                textCell = dayData['start_at'];
              } else {
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
            // если не воскресенье
            if (dayIndex != 7) {
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
          }
          // запланированный день
          else if (dayStartAt.isAfter(now)) {
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
        // ячейки подсказки
        else if (dayData['statusCell'] == 'helper') {
          // print('helper');
          // если не воскресенье
          if (gridIndex != 6) {
            badgeColor = AppColor.grey1.withOpacity(0);
            fontColor = AppColor.grey3;
            textCell = dayData['start_at'];
          } else {
            badgeColor = AppColor.grey1.withOpacity(0);
            fontColor = AppColor.red;
          }
        }
        // ячейки подсказки выполненые
        else if (dayData['statusCell'] == 'completed') {
          // если не воскресенье
          if (gridIndex != 6) {
            badgeColor = AppColor.accent.withOpacity(0.5);
            // fontColor = AppColor.grey3;
            textCell = dayData['completed_at'];
          } else {
            // print('completed: $dayData');
            textCell = dayData['completed_at'];
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
