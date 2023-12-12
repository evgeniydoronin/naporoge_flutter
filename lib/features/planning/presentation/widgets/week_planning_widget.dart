import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/get_actual_student_day.dart';
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
    weeksData['createdWeeks'] = _weekData['createdWeeks'];
    weeksData['defaultPageIndex'] = _weekData['defaultPageIndex'];

    // print('streamStatus before: $streamStatus');
  }
  // После окончания курса
  else if (streamStatus['status'] == 'after') {
    Map _weekData = await getWeekData(stream, 'after');

    // добавляем после
    weeksData['weeksOnPage'] = _weekData['weeksOnPage'];
    weeksData['createdWeeks'] = _weekData['createdWeeks'];
    weeksData['defaultPageIndex'] = _weekData['defaultPageIndex'];
  }
  // Во время прохождения курса
  else if (streamStatus['status'] == 'process') {
    // print('streamStatus 2: $streamStatus');
    Map _weekData = await getWeekData(stream, 'process');

    // добавляем после
    weeksData['weeksOnPage'] = _weekData['weeksOnPage'];
    weeksData['createdWeeks'] = _weekData['createdWeeks'];
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
        future: getWeeksData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map pageData = snapshot.data;
            // print('pageData 333: $pageData');
            // print('weeksOnPage: ${pageData['weeksOnPage'][0]['monday']}');
            // print('weeksOnPage: ${pageData['weeksOnPage'][1]['monday']}');
            // print('weeksOnPage: ${pageData['weeksOnPage'][2]['monday']}');
            // print('weeksOnPage: ${pageData['weeksOnPage'][3]['monday']}');
            // print('weeksOnPage: ${pageData['weeksOnPage'][4]['monday']}');
            // print('weeksOnPage: ${pageData['weeksOnPage'][5]['monday']}');
            // print('weeksOnPage: ${pageData['weeksOnPage'][6]['monday']}');
            // print('weeksOnPage: ${pageData['weeksOnPage'][7]['monday']}');
            // print('weeksOnPage: ${pageData['weeksOnPage'][8]}');

            _pageIndex = pageData['defaultPageIndex'];
            NPStream stream = pageData['stream'];
            int weeks = pageData['weeks'];
            int createdWeeks = pageData['createdWeeks'];

            // print('createdWeeks 3: $createdWeeks');

            // страница по умолчанию
            pageController = PageController(initialPage: _pageIndex);

            return BlocConsumer<PlannerBloc, PlannerState>(
              listener: (context, state) {},
              builder: (context, state) {
                double wrapHeight =
                    defaultAllTitleHeight + context.read<PlannerBloc>().state.wrapWeekBoxHeight.toDouble();
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  height: wrapHeight,
                  child: PageView.builder(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: createdWeeks,
                      itemBuilder: (context, pageIndex) {
                        String pageTitle = "Неделя  ${pageIndex + 1}/$weeks";
                        String weekMonday = DateFormat('dd.MM').format(pageData['weeksOnPage'][pageIndex]['monday']);
                        String weekSunday = DateFormat('dd.MM').format(pageData['weeksOnPage'][pageIndex]['sunday']);
                        String weekPeriod = "$weekMonday - $weekSunday";

                        // неделя прошла
                        // проверяем на составление плана
                        // план не составлялся
                        Map isPlannedWeek = {};
                        DateTime now = getActualStudentDay();
                        DateTime monday = pageData['weeksOnPage'][pageIndex]['monday'];
                        Week? week = pageData['weeksOnPage'][pageIndex]['week'];

                        // План на неделю не составлен
                        // неделя прошла
                        if (week != null) {
                          if (now.isAfter(monday) || now.isAtSameMomentAs(monday)) {
                            if (week.systemConfirmed != null) {
                              isPlannedWeek['title'] = 'План не составлен';
                              isPlannedWeek['color'] = AppColor.red;
                            }
                          }
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
                                      pageIndex != 0
                                          ? GestureDetector(
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
                                            )
                                          : const Icon(Icons.arrow_back_ios_new),
                                      Text(weekPeriod),
                                      pageIndex + 1 < createdWeeks
                                          ? GestureDetector(
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
                                              child: const RotatedBox(
                                                  quarterTurns: 2, child: Icon(Icons.arrow_back_ios_new)),
                                            )
                                          : const RotatedBox(quarterTurns: 2, child: Icon(Icons.arrow_back_ios_new)),
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
                                      crossAxisSpacing: 0,
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
                            isPlannedWeek.isNotEmpty
                                ? Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      height: 50,
                                      child: Text(
                                        isPlannedWeek['title'],
                                        style: TextStyle(color: isPlannedWeek['color']),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
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
    // print('isEditable: ${pageData['weeksOnPage'][pageIndex]}');
    bool isEditable = pageData['weeksOnPage'][pageIndex]['isEditable'] ?? false;
    List cellsData = pageData['weeksOnPage'][pageIndex]['cellsWeekData'];

    // выводим кнопку План мне подходит
    // если неделя редактируемая
    context.read<PlannerBloc>().add(PlanningConfirmBtnStream(isPlanningConfirmBtn: isEditable));

    // добавляем в стейт данные по редактируемой неделе
    // если ячейки дней не созданы
    context.read<PlannerBloc>().add(EditableWeekStream(editableWeekData: {
          'weekId': pageData['weeksOnPage'][pageIndex]['weekId'],
          'monday': pageData['weeksOnPage'][pageIndex]['monday'],
          'weekOfYear': pageData['weeksOnPage'][pageIndex]['weekOfYear'],
          'weekYear': int.parse(DateFormat('y').format(pageData['weeksOnPage'][pageIndex]['monday'])),
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

    Week week = widget.stream.weekBacklink.where((week) => week.id == widget.weeksOnPage['weekId']).first;
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
                          Day day = week.dayBacklink.where((day) => day.id == daysData[i]['day_id']).first;

                          /// день выполнен
                          /// return: 2023-11-27 00:00:00.000
                          DateTime? dayCompletedAt = daysData[i]['completed_at'] != null
                              ? DateTime.parse(DateFormat('y-MM-dd').format(day.completedAt!))
                              : null;

                          /// день выполнен вовремя
                          /// return: true | false
                          bool completedOnTime = daysData[i]['completedOnTime'];

                          bool isHintDay = daysData[i]['hintCellId'] != null ? true : false;

                          /// {day_id: 11924,
                          /// dateAt: 2023-11-27 00:00:00.000,
                          /// cellId: [0, 1, 0],
                          /// hintCellId: null,
                          /// hintCellStartAt: null,
                          /// newCellId: [1, 0, 0],
                          /// start_at: 05:00,
                          /// completed_at: 12:45,
                          /// completedOnTime: false}
                          ///

                          /// подсказка
                          if (isHintDay) {
                            if (eq(daysData[i]['hintCellId'], [periodIndex, rowIndex, gridIndex])) {
                              dayData = {
                                ...daysData[i],
                                ...{'day': day}
                              };
                            }
                          }

                          /// день выполнен
                          if (dayCompletedAt != null) {
                            /// вовремя
                            if (completedOnTime) {
                              if (eq(daysData[i]['cellId'], [periodIndex, rowIndex, gridIndex])) {
                                dayData = {
                                  ...daysData[i],
                                  ...{'day': day}
                                };
                              }
                            }

                            /// не вовремя
                            else {
                              /// новая ячейка
                              if (eq(daysData[i]['newCellId'], [periodIndex, rowIndex, gridIndex])) {
                                dayData = {
                                  ...daysData[i],
                                  ...{'day': day}
                                };
                              }

                              /// старая ячейка
                              if (eq(daysData[i]['cellId'], [periodIndex, rowIndex, gridIndex])) {
                                dayData = {
                                  ...daysData[i],
                                  ...{'day': day}
                                };
                              }
                            }
                          }

                          /// день не выполнен
                          if (dayCompletedAt == null) {
                            if (eq(daysData[i]['cellId'], [periodIndex, rowIndex, gridIndex])) {
                              dayData = {
                                ...daysData[i],
                                ...{'day': day}
                              };
                            }
                          }
                        }

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

  const DayPeriodExistedCell(
      {super.key,
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

    /// воскресенье
    bool isSunday = gridIndex == 6;
    Color cellColor = isSunday ? const Color(0xFF00A2FF).withOpacity(0.3) : Colors.white;

    Color fontColor = AppColor.blk;
    Color badgeColor = AppColor.grey1.withOpacity(0);
    String textCell = '';

    if (dayData.isNotEmpty) {
      Day day = dayData['day'];
      // print('dayID: ${day.id} - ${periodIndex}, ${rowIndex}, ${gridIndex}');
      DateTime dayDate = dayData['dateAt'];

      /// время старта
      DateTime? dayStartAt =
          dayData['start_at'] != null ? DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!)) : null;

      /// время завершения
      DateTime? dayCompletedAt =
          dayData['completed_at'] != null ? DateTime.parse(DateFormat('y-MM-dd').format(day.completedAt!)) : null;

      /// день подсказка
      Day? dayHint = dayData['hintCellId'] != null ? day : null;

      /// день выполнен вовремя
      /// return: true | false
      bool completedOnTime = dayData['completedOnTime'];

      DateTime actualStudentDay = getActualStudentDay();
      DateTime now = DateTime.parse(DateFormat('y-MM-dd').format(actualStudentDay));
      int dayIndex = gridIndex + 1;

      /// {
      ///   'day_id': day.id,
      //    'dateAt': day.dateAt,
      //    'cellId': cells[cell]['cellId'], // [0, 6, 2]
      //    'hintCellId': hintCellId, // [0, 6, 2]
      //    'hintCellStartAt': hintCellStartAt,
      //    'newCellId': newCellId, // [0, 6, 2]
      //    'start_at': day.startAt != null ? DateFormat('HH:mm').format(day.startAt!) : null,
      //    'completed_at': day.completedAt != null ? DateFormat('HH:mm').format(day.completedAt!) : null,
      //    'completedOnTime': completedOnTime,
      /// }

      /// День ПОДСКАЗКА
      if (dayHint != null) {
        /// ПОДСКАЗКА
        /// ДЕНЬ ВЫПОЛНЕН
        if (dayCompletedAt != null) {
          if (eq(dayData['newCellId'], [periodIndex, rowIndex, gridIndex])) {
            textCell = DateFormat('HH:mm').format(day.completedAt!);
            badgeColor = !isSunday ? AppColor.accent.withOpacity(0.5) : Colors.transparent;
            fontColor = !isSunday ? AppColor.blk : AppColor.red;
          }
        }

        /// Подсказки
        else {
          if (eq(dayData['hintCellId'], [periodIndex, rowIndex, gridIndex])) {
            textCell = !isSunday ? DateFormat('HH:mm').format(dayData['hintCellStartAt']) : '';
          }
        }
      }

      /// ДЕНЬ НЕ ПОДСКАЗКА
      else {
        /// НЕ ПОДСКАЗКА
        /// ДЕНЬ ВЫПОЛНЕН
        if (dayCompletedAt != null) {
          /// {day_id: 11924,
          /// dateAt: 2023-11-27 00:00:00.000,
          /// cellId: [0, 1, 0],
          /// hintCellId: null,
          /// hintCellStartAt: null,
          /// newCellId: [1, 0, 0],
          /// start_at: 05:00,
          /// completed_at: 12:45,
          /// completedOnTime: false,
          /// day: Instance of 'Day'}

          /// НЕ ПОДСКАЗКА
          /// ДЕНЬ ВЫПОЛНЕН
          /// ВОВРЕМЯ
          if (completedOnTime) {
            if (eq(dayData['cellId'], [periodIndex, rowIndex, gridIndex])) {
              textCell = DateFormat('HH:mm').format(day.completedAt!);
              badgeColor = !isSunday ? AppColor.accent : Colors.transparent;
              fontColor = !isSunday ? AppColor.blk : AppColor.red;
            }
          }

          /// НЕ ПОДСКАЗКА
          /// ДЕНЬ ВЫПОЛНЕН
          /// НЕ ВОВРЕМЯ
          else {
            /// новая ячейка
            if (eq(dayData['newCellId'], [periodIndex, rowIndex, gridIndex])) {
              textCell = DateFormat('HH:mm').format(day.completedAt!);
              badgeColor = !isSunday ? AppColor.accent.withOpacity(0.5) : Colors.transparent;
              fontColor = !isSunday ? AppColor.blk : AppColor.red;
            }

            /// старая ячейка
            if (eq(dayData['cellId'], [periodIndex, rowIndex, gridIndex])) {
              textCell = !isSunday && day.startAt != null ? DateFormat('HH:mm').format(day.startAt!) : '';
              badgeColor = !isSunday && day.startAt != null ? AppColor.grey1 : Colors.transparent;
            }
          }
        }

        /// НЕ ПОДСКАЗКА
        /// ДЕНЬ НЕ ВЫПОЛНЕН
        /// И НЕ ПУСТАЯ ПЕРВАЯ НЕДЕЛЯ
        /// {day_id: 12330, dateAt: 2024-02-05 00:00:00.000, cellId: [0, 0, 0], hintCellId: null, hintCellStartAt: null, newCellId: null, start_at: null, completed_at: null, completedOnTime: false}
        else {
          /// текущий день
          if (now.isAtSameMomentAs(day.dateAt!)) {
            /// старая ячейка
            if (eq(dayData['cellId'], [periodIndex, rowIndex, gridIndex])) {
              textCell = !isSunday && day.startAt != null ? DateFormat('HH:mm').format(day.startAt!) : '';
              badgeColor = !isSunday && day.startAt != null ? AppColor.grey1 : Colors.transparent;
            }
          }

          /// прошедший день
          else if (now.isAfter(day.dateAt!)) {
            /// старая ячейка
            if (eq(dayData['cellId'], [periodIndex, rowIndex, gridIndex])) {
              textCell = !isSunday && day.startAt != null ? DateFormat('HH:mm').format(day.startAt!) : '';
              badgeColor = !isSunday && day.startAt != null ? AppColor.red : Colors.transparent;
            }
          }

          /// будущий день
          else if (now.isBefore(day.dateAt!)) {
            /// старая ячейка
            if (eq(dayData['cellId'], [periodIndex, rowIndex, gridIndex])) {
              textCell = !isSunday && day.startAt != null ? DateFormat('HH:mm').format(day.startAt!) : '';
              badgeColor = !isSunday && day.startAt != null ? AppColor.grey1 : Colors.transparent;
            }
          }
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
