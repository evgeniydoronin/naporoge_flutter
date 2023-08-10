import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/get_week_number.dart';
import '../../domain/entities/stream_entity.dart';
import '../../data/sources/local/stream_local_storage.dart';
import '../bloc/planner_bloc.dart';
import 'core.dart';
import 'editable_week/editable_day_period_row.dart';

Future getStreamStatus() async {
  Map streamStatus = {};

  final storage = StreamLocalStorage();
  NPStream stream = await storage.getActiveStream();

  DateTime now = DateTime.now();

  DateTime startStream = stream.startAt!;
  DateTime endStream = stream.startAt!.add(Duration(
      days: (stream.weeks! * 7) - 1, hours: 23, minutes: 59, seconds: 59));

  bool isBeforeStartStream = startStream.isAfter(now);
  bool isAfterEndStream = endStream.isBefore(now);

  // До старта курса
  if (isBeforeStartStream) {
    streamStatus['status'] = "before";
  }
  // После завершения курса
  else if (isAfterEndStream) {
    streamStatus['status'] = "after";
  }
  // Во время прохождения курса
  else if (!isBeforeStartStream && !isAfterEndStream) {
    streamStatus['status'] = "process";
  }

  return streamStatus;
}

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
  int existsWeeks = stream.weekBacklink.length;
  weeksData['existsWeeks'] = existsWeeks;
  // статус курса (before, after, process)
  Map streamStatus = await getStreamStatus();

  // формирование недели по умолчанию при открытии Календаря
  // До старта курса
  if (streamStatus['status'] == 'before') {
    // первая неделя курса по умолчанию
    weeksData['defaultPageIndex'] = 0;
    print('streamStatus: $streamStatus');
  }
  // После окончания курса
  else if (streamStatus['status'] == 'after') {
    // открывать по умолчанию последнюю неделю курса
    weeksData['defaultPageIndex'] = weeks - 1;
    print('streamStatus: $streamStatus');
  }
  // Во время прохождения курса
  else if (streamStatus['status'] == 'process') {
    // страниц планера
    int allPages = stream.weekBacklink.length;
    // формируем все недели с данными
    List weeksOnPage = [];
    // индекс текущей недели
    int? currentWeekIndex;

    // формируем созданные недели с данными
    for (int i = 0; i < stream.weekBacklink.length; i++) {
      Week week = stream.weekBacklink.elementAt(i);
      List _cells = jsonDecode(week.cells!);
      List cellsWeekData = [];
      List weekOpenedPeriod = [];

      // найти pageIndex текущей недели
      if (getWeekNumber(DateTime.now()) == week.weekNumber) {
        currentWeekIndex = i;
        weeksData['defaultPageIndex'] = i;
      }

      // Формирование данных ячеек
      for (int i = 0; i < _cells.length; i++) {
        int cellIndex = _cells[i]['cellId'][2];

        // добавляем индекс заполненного периода
        weekOpenedPeriod.add(_cells[i]['cellId'][0]);

        var _day = week.dayBacklink.indexed
            .where((element) => element.$1 == cellIndex);

        Day day = _day.first.$2;
        // DAY START AT
        DateTime startAtDate =
            DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

        // День завершен
        if (day.completedAt != null) {
          // час старта дела по плану
          String startAtHour = DateFormat('H').format(day.startAt!);
          // час завершения дела актуальный
          String completedAtHour = DateFormat('H').format(day.completedAt!);
          // print('startAtHour: $startAtHour');
          // print('completedAtHour: $completedAtHour');

          // Если час выполнения не совпадает
          if (startAtHour != completedAtHour) {
            for (Map hour in periodHoursIndexList) {
              // час завершения дела актуальный
              if (hour.keys.first == completedAtHour) {
                // находим индекс дня ячейки
                int gridIndex = _cells[i]['cellId'].last;
                // Создаем новый список
                List newHourCellId = List.from(hour.values.first);
                newHourCellId.add(gridIndex);

                // добавляем новую ячейку с новым индексом
                cellsWeekData.addAll([
                  {
                    'day_id': day.id,
                    'cellId': newHourCellId,
                    'start_at': DateFormat('HH:mm').format(day.startAt!),
                    'completed_at':
                        DateFormat('HH:mm').format(day.completedAt!),
                    'newCellId': true,
                  }
                ]);
                // добавляем индекс заполненного периода
                weekOpenedPeriod.add(gridIndex);

                // print('hourIndex: $hourIndex');
              } else if (hour.keys.first == startAtHour) {
                // добавляем  ячейку
                cellsWeekData.addAll([
                  {
                    'day_id': day.id,
                    'cellId': _cells[i]['cellId'],
                    'start_at': DateFormat('HH:mm').format(day.startAt!),
                    'completed_at':
                        DateFormat('HH:mm').format(day.completedAt!),
                    'oldCellId': true,
                  }
                ]);
                // добавляем индекс заполненного периода
                weekOpenedPeriod.add(_cells[i]['cellId'][0]);
              }
            }
          }
          // Если час выполнения совпадает
          else if (startAtHour == completedAtHour) {
            cellsWeekData.addAll([
              {
                'day_id': day.id,
                'cellId': _cells[i]['cellId'],
                'start_at': DateFormat('HH:mm').format(day.startAt!),
                'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                'day_matches': true,
              }
            ]);
            // добавляем индекс заполненного периода
            weekOpenedPeriod.add(_cells[i]['cellId'][0]);
          }
        }
        // День НЕ завершен
        else {
          cellsWeekData.addAll([
            {
              'day_id': day.id,
              'cellId': _cells[i]['cellId'],
              'start_at': DateFormat('HH:mm').format(day.startAt!),
              'completed_at': '',
            }
          ]);
        }
      }

      // print('weekOpenedPeriod 1: ${weekOpenedPeriod.toSet().toList()}');

      // Добавление недель с данными
      weeksOnPage.addAll([
        {
          'pageIndex': i,
          'monday': week.dayBacklink.first.startAt,
          'sunday': week.dayBacklink.last.startAt,
          'cellsWeekData': cellsWeekData,
          'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
        }
      ]);
    }

    // формируем будущую редактируемую неделю
    if (existsWeeks < weeks) {
      // индекс следующей недели
      int nextWeekIndex = currentWeekIndex! + 1;
      // добавляем новую страницу в планере
      allPages = stream.weekBacklink.length + 1;
      // проверить - если неделя не началась
      // последняя созданная неделя
      Week lastCreatedWeek = stream.weekBacklink
          .elementAt(weeksOnPage[currentWeekIndex]['pageIndex']);

      List _cells = jsonDecode(lastCreatedWeek.cells!);
      List cellsWeekData = [];
      List weekOpenedPeriod = [];

      // Формирование данных ячеек
      for (int i = 0; i < _cells.length; i++) {
        int cellIndex = _cells[i]['cellId'][2];

        // добавляем индекс заполненного периода
        weekOpenedPeriod.add(_cells[i]['cellId'][0]);

        var _day = lastCreatedWeek.dayBacklink.indexed
            .where((element) => element.$1 == cellIndex);

        Day day = _day.first.$2;
        // DAY START AT
        DateTime startAtDate =
            DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

        cellsWeekData.addAll([
          {
            'day_id': 0,
            'cellId': _cells[i]['cellId'],
            'start_at': DateFormat('HH:mm').format(day.startAt!),
            'completed_at': '',
          }
        ]);
      }

      // Добавление будущей недели с данными
      weeksOnPage.addAll([
        {
          'pageIndex': nextWeekIndex,
          'monday': lastCreatedWeek.dayBacklink.first.startAt!
              .add(const Duration(days: 7)),
          'sunday': lastCreatedWeek.dayBacklink.last.startAt!
              .add(const Duration(days: 7)),
          'cellsWeekData': cellsWeekData,
          'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
          'isEditable': true,
        }
      ]);
    }

    // добавляем после всех проверок
    weeksData['weeksOnPage'] = weeksOnPage;
    weeksData['allPages'] = allPages;

    // количество недель назначать на одну больше чем создано
    // для того, чтобы пользователь смог создать будущую неделю

    // Нужно получить все созданные недели на курсе
    // определить текущую неделю
    // взять индекс этой недели и назначить
    // этот индекс странице Календаря - pageIndex
    // проверить неделю на создано или нет
    // если текущая неделя не создана
    // если неделя первая - дать возможность создать
    // если не первая, то
    // проверить предыдущую неделю
    // если создана - взять данные для отображения подсказок
    // если не создана, проверить первую неделю
    // и взять подсказки, при условии что первая создана

    // проверка предыдущих недель осуществляется
    // по входящему индексу страницы

    //

    // print('pageIndex 33: $pageIndex');
    // print('streamStatus: $streamStatus');
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
    defaultAllTitleHeight = 220;

    return FutureBuilder(
        future: weeksData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map pageData = snapshot.data;
            // print('pageData 333: ${pageData['weeksOnPage'][1]}');
            // print('pageData 333: ${pageData['weeksOnPage'][1]}');

            _pageIndex = pageData['defaultPageIndex'];
            NPStream stream = pageData['stream'];
            int weeks = pageData['weeks'];
            int allPages = pageData['allPages'];

            // страница по умолчанию
            pageController = PageController(initialPage: _pageIndex);

            return BlocConsumer<PlannerBloc, PlannerState>(
              listener: (context, state) {},
              builder: (context, state) {
                double wrapHeight = 0;
                // print('state.wrapWeekBoxHeight: ${state.wrapWeekBoxHeight}');
                // print('defaultAllTitleHeight: ${defaultAllTitleHeight}');
                // print('weeksPeriodsHeight: ${weeksPeriodsHeight[_pageIndex]}');
                wrapHeight = defaultAllTitleHeight +
                    context
                        .read<PlannerBloc>()
                        .state
                        .wrapWeekBoxHeight
                        .toDouble();
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: wrapHeight,
                  child: PageView.builder(
                      controller: pageController,
                      itemCount: allPages,
                      itemBuilder: (context, pageIndex) {
                        String pageTitle = "Неделя  ${pageIndex + 1}/$weeks";
                        String weekMonday = DateFormat('dd.MM').format(
                            pageData['weeksOnPage'][pageIndex]['monday']);
                        String weekSunday = DateFormat('dd.MM').format(
                            pageData['weeksOnPage'][pageIndex]['sunday']);
                        String weekPeriod = "$weekMonday - $weekSunday";
                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // Навигация по неделям и период недели
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    pageTitle,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          // сброс блока высоты периодов
                                          // periodAllTitlesClosedHeight = [220];

                                          pageController.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 10),
                                              curve: Curves.easeIn);
                                        },
                                        child: const Icon(
                                            Icons.arrow_back_ios_new),
                                      ),
                                      Text(weekPeriod),
                                      GestureDetector(
                                        onTap: () async {
                                          pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 10),
                                              curve: Curves.easeIn);
                                        },
                                        child: const RotatedBox(
                                            quarterTurns: 2,
                                            child:
                                                Icon(Icons.arrow_back_ios_new)),
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
                                  child:
                                      SvgPicture.asset('assets/icons/time.svg'),
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      crossAxisSpacing: 1,
                                    ),
                                    itemCount: weekDaysNameRu.length,
                                    itemBuilder:
                                        (BuildContext context, dayIndex) {
                                      return Center(
                                        child: Text(
                                          weekDaysNameRu[dayIndex]
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: AppFont.smaller,
                                              color: weekDaysNameRu[dayIndex] ==
                                                      'вс'
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
                                pageData: pageData, pageIndex: pageIndex),
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
  final Map pageData;
  final int pageIndex;

  const ExpandDayPeriod(
      {super.key, required this.pageData, required this.pageIndex});

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
    context
        .read<PlannerBloc>()
        .add(const WrapWeekBoxHeightStream(wrapWeekBoxHeight: 0));
    print('pageData 11: $pageData');
    // перебираем недели
    for (Map page in pageData['weeksOnPage']) {
      // если входящий индекс страницы совпадает с недельным
      if (pageIndex == page['pageIndex']) {
        // если есть заполненные ячейки
        if (page['weekOpenedPeriod'].isNotEmpty) {
          weeksPeriodsHeight.add({
            "pageIndex": page['pageIndex'],
            "height": [],
            "periodIndex": page['weekOpenedPeriod'],
          });
        }
      }
    }

    // если есть заполненные ячейки страницы - открываем периоды
    if (weeksPeriodsHeight.isNotEmpty) {
      if (weeksPeriodsHeight[0]['periodIndex'].isNotEmpty) {
        // print('weeksPeriodsHeight: $weeksPeriodsHeight');
        for (int i = 0; i < weeksPeriodsHeight[0]['periodIndex'].length; i++) {
          onCollapseToggle(i, pageIndex);
        }
      }
    }
  }

  onCollapseToggle(val, pageIndex) {
    print('val: $val, pageIndex: $pageIndex, period.length: ${period.length}');
    for (int i = 0; i < period.length; i++) {
      if (i == val && period[val].isExpanded) {
        setState(() {
          period[val].isExpanded = false;
        });

        // удаляем высоту периода в списке
        weeksPeriodsHeight[0]['height'].remove((period[val].rows * 43).toInt());

        // удаляем высоту периода в стейте
        context.read<PlannerBloc>().add(WrapWeekBoxHeightStream(
            wrapWeekBoxHeight:
                weeksPeriodsHeight[0]['height'].fold(0, (a, b) => a + b)));
      } else if (i == val && !period[val].isExpanded) {
        print('open: ${weeksPeriodsHeight}');
        setState(() {
          period[val].isExpanded = true;
        });

        // добавляем высоту периода в список
        weeksPeriodsHeight[0]['height']
            .addAll([(period[val].rows * 43).toInt()]);

        // добавляем высоту периода в стейт
        context.read<PlannerBloc>().add(WrapWeekBoxHeightStream(
            wrapWeekBoxHeight:
                weeksPeriodsHeight[0]['height'].fold(0, (a, b) => a + b)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditable = pageData['weeksOnPage'][pageIndex]['isEditable'] ?? false;
    List cellsData = pageData['weeksOnPage'][pageIndex]['cellsWeekData'];
    // print(pageData['weeksOnPage'][pageIndex]['cellsWeekData']);
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
              child: isEditable
                  ? EditableDayPeriodRow(
                      periodIndex: periodIndex,
                      daysData: cellsData,
                    )
                  : DayPeriodRow(
                      periodIndex: periodIndex,
                      daysData: cellsData,
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

  const DayPeriodRow(
      {super.key, required this.periodIndex, required this.daysData});

  @override
  State<DayPeriodRow> createState() => _DayPeriodRowState();
}

class _DayPeriodRowState extends State<DayPeriodRow> {
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

                        return DayPeriodExistedCell(
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

class DayPeriodExistedCell extends StatefulWidget {
  final Map dayData;
  final int periodIndex, rowIndex, gridIndex;

  const DayPeriodExistedCell(
      {super.key,
      required this.dayData,
      required this.periodIndex,
      required this.rowIndex,
      required this.gridIndex});

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
