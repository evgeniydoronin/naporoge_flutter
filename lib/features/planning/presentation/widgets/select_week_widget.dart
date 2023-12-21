import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';

import '../../../../core/constants/app_theme.dart';
import '../bloc/active_course/active_stream_bloc.dart';
import '../bloc/planner_bloc.dart';

List<String> weekDaysNameRu = [
  'пн',
  'вт',
  'ср',
  'чт',
  'пт',
  'сб',
  'вс',
];

class SelectWeekWidget extends StatelessWidget {
  const SelectWeekWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NPCalendar(currentDay: DateTime.now());
  }
}

class NPCalendar extends StatefulWidget {
  /// The start of the selected day range.
  final DateTime? rangeStartDay;

  /// The end of the selected day range.
  final DateTime? rangeEndDay;

  /// DateTime that determines which days are currently visible and focused.
  final DateTime? focusedDay;

  /// The first active day of `TableCalendar`.
  /// Blocks swiping to days before it.
  ///
  /// Days before it will use `disabledStyle` and trigger `onDisabledDayTapped` callback.
  final DateTime? firstDay;

  /// The last active day of `TableCalendar`.
  /// Blocks swiping to days after it.
  ///
  /// Days after it will use `disabledStyle` and trigger `onDisabledDayTapped` callback.
  final DateTime? lastDay;

  /// DateTime that will be treated as today. Defaults to `DateTime.now()`.
  ///
  /// Overriding this property might be useful for testing.
  final DateTime currentDay;

  /// List of days treated as weekend days.
  /// Use built-in `DateTime` weekday constants (e.g. `DateTime.monday`) instead of `int` literals (e.g. `1`).
  final List<int>? weekendDays;

  const NPCalendar(
      {super.key,
      this.rangeStartDay,
      this.rangeEndDay,
      this.focusedDay,
      this.firstDay,
      this.lastDay,
      required this.currentDay,
      this.weekendDays});

  @override
  State<NPCalendar> createState() => _NPCalendarState();
}

class _NPCalendarState extends State<NPCalendar> {
  late DateTime _currentDay;
  late int dayInMonth;

  late DateTime firstDayOfMonth;
  late DateTime firstDayOfNextMonth;

  late DateTime lastDayOfMonth = DateTime(_currentDay.year, _currentDay.month + 1, 0);
  late DateTime lastDayOfPreviousMonth = DateTime(_currentDay.year, _currentDay.month, 0);

  // Начало месяца со сдвигом на нужную неделю
  late int offsetStartMonth;

  Color colorCell = Colors.white;

  @override
  void initState() {
    _currentDay = widget.currentDay;
    firstDayOfMonth = DateTime(_currentDay.year, _currentDay.month, 1);
    firstDayOfNextMonth = DateTime(_currentDay.year, _currentDay.month + 1);
    offsetStartMonth = firstDayOfMonth.weekday - 1;
    dayInMonth = (firstDayOfMonth.difference(firstDayOfNextMonth).inDays).abs();

    super.initState();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    // Ячейки Дней не активны
    bool isActiveCellDay = false;

    // понедельник текущей недели
    DateTime mondayCurrentWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    // понедельник следующей недели
    DateTime mondayNextWeek = mondayCurrentWeek.add(const Duration(days: 7));

    int lastWeekNumberOfCurrentMonth = weekNumber(lastDayOfMonth);

    DateTime lastMondayOfMonth = lastDayOfMonth.subtract(Duration(days: lastDayOfMonth.weekday - 1));

    // если дата в рамках последней недели месяца
    // выводим следующий месяц
    // if (DateTime.now().isBefore(lastDayOfMonth.add(const Duration(hours: 23, minutes: 59, seconds: 59))) &&
    //     DateTime.now().isAfter(lastMondayOfMonth)) {
    //   // print(lastDayOfMonth.add(const Duration(days: 1)));
    //   setState(() {
    //     _currentDay = lastDayOfMonth.add(const Duration(days: 1));
    //     firstDayOfMonth = DateTime(_currentDay.year, _currentDay.month, 1);
    //     firstDayOfNextMonth = DateTime(_currentDay.year, _currentDay.month + 1);
    //     offsetStartMonth = firstDayOfMonth.weekday - 1;
    //     dayInMonth = (firstDayOfMonth.difference(firstDayOfNextMonth).inDays).abs();
    //   });
    // }

    String month = DateFormat.MMMM('ru').format(DateTime.parse(firstDayOfMonth.toString()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              month.replaceFirst(month[0], month[0].toUpperCase()),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (DateTime.now().compareTo(_currentDay) < 0) {
                        print('prev month');
                        changeMonth(false);
                      }
                    },
                    icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg'))),
                IconButton(
                    onPressed: () {
                      print('next month');
                      changeMonth(true);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/arrow.svg',
                    )),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: Color(0x20000000)),
            ),
          ),
          height: 25,
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemCount: weekDaysNameRu.length,
              itemBuilder: (BuildContext context, weekDayIndex) {
                return Text(
                  weekDaysNameRu[weekDayIndex].toUpperCase(),
                  style: TextStyle(fontSize: 12, color: weekDayIndex != 0 ? Colors.grey : Colors.black),
                  textAlign: TextAlign.center,
                );
              }),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, mainAxisSpacing: 1, childAspectRatio: 1),
          itemCount: dayInMonth + offsetStartMonth,
          itemBuilder: (BuildContext context, cellIndex) {
            // Дата в ячейке
            DateTime cellDate = firstDayOfMonth.add(Duration(days: cellIndex - offsetStartMonth));
            // Если следующая неделя и не последняя неделя месяца
            // делаем ячейки активные для выбора
            // Если последняя неделя месяца - выводим следующий месяц для выбора
            if (cellDate.isAfter(mondayNextWeek.subtract(const Duration(days: 1)))) {
              isActiveCellDay = true;
            }
            return cellIndex < offsetStartMonth
                ? const SizedBox()
                : isActiveCellDay
                    ? cellBuilder(cellIndex, offsetStartMonth)
                    : Center(
                        child: Text(
                          firstDayOfMonth.add(Duration(days: cellIndex - offsetStartMonth)).day.toString(),
                          style: TextStyle(color: AppColor.grey2, fontSize: 20),
                        ),
                      );
          },
        ),
      ],
    );
  }

  void changeMonth(direction) {
    print('_currentDay 1: $_currentDay');
    setState(() {
      _currentDay = direction
          ? DateTime(_currentDay.year, _currentDay.month + 1)
          : DateTime(_currentDay.year, _currentDay.month - 1);
      firstDayOfMonth = DateTime(_currentDay.year, _currentDay.month, 1);
      firstDayOfNextMonth = DateTime(_currentDay.year, _currentDay.month + 1);
      offsetStartMonth = firstDayOfMonth.weekday - 1;
      dayInMonth = (firstDayOfMonth.difference(firstDayOfNextMonth).inDays).abs();
    });

    print('_currentDay 2: $_currentDay');
  }

  Widget cellBuilder(cellIndex, offsetStartMonth) {
    DateTime cellDate = firstDayOfMonth.add(Duration(days: cellIndex - offsetStartMonth));

    return GestureDetector(
      onTap: () {
        DateTime selectCell =
            firstDayOfMonth.add(Duration(days: cellIndex - offsetStartMonth)); // 2022-10-14 00:00:00.000
        DateTime mondayStartRange = selectCell.subtract(Duration(days: selectCell.weekday - 1));

        // print('mondayStartRange: $mondayStartRange');
        context.read<PlannerBloc>().add(StreamStartDateChanged(DateFormat('yyyy-MM-dd').format(mondayStartRange)));
      },
      child: cellContainer(cellDate),
    );
  }

  Container cellContainer(cellDate) {
    var state = context.watch<PlannerBloc>().state;
    BoxDecoration decorationFirstLast = const BoxDecoration();
    BoxDecoration decoration = const BoxDecoration();
    TextStyle style = const TextStyle(fontSize: 20);

    String startDateString = state.startDate;
    int courseWeeks = state.courseWeeks;

    DateTime startDate = DateTime.now();

    if (startDateString.isNotEmpty) {
      startDate = DateTime.parse(startDateString);
    }

    for (int i = 0; i < courseWeeks * 7; i++) {
      if (cellDate.compareTo(startDate.add(Duration(days: i))) == 0) {
        // print(startDate.add(Duration(days: i)));
        colorCell = AppColor.accent;
        if (i == 0) {
          decoration = BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.accent.withOpacity(0.3),
          );
          decorationFirstLast = BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
            // borderRadius: const BorderRadius.all(Radius.circular(50)),
            color: AppColor.accent.withOpacity(0.1),
          );
          style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
        } else if (i == courseWeeks * 7 - 1) {
          decoration = BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.accent.withOpacity(0.3),
          );
          decorationFirstLast = BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            // borderRadius: const BorderRadius.all(Radius.circular(50)),
            color: AppColor.accent.withOpacity(0.1),
          );
          style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
        } else {
          decoration = BoxDecoration(
            color: AppColor.accent.withOpacity(0.1),
          );
        }
      }
    }

    return Container(
      decoration: decorationFirstLast,
      child: Container(
        decoration: decoration,
        child: Center(
          child: Text(
            cellDate.day.toString(),
            style: style,
          ),
        ),
      ),
    );
  }
}
