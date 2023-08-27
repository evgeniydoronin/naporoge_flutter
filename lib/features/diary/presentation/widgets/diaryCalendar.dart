import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';

List<String> weekDay = [
  'пн',
  'вт',
  'ср',
  'чт',
  'пт',
  'сб',
  'вс',
];

class DiaryCalendar extends StatefulWidget {
  const DiaryCalendar({Key? key}) : super(key: key);

  @override
  State<DiaryCalendar> createState() => _DiaryCalendarState();
}

class _DiaryCalendarState extends State<DiaryCalendar> {
  late DateTime _currentDay;
  late int dayInMonth;

  late DateTime firstDayOfMonth;
  late DateTime firstDayOfNextMonth;

  late DateTime lastDayOfMonth = DateTime(_currentDay.year, _currentDay.month + 1, 0);
  late DateTime lastDayOfPreviousMonth = DateTime(_currentDay.year, _currentDay.month, 0);

  // Начало месяца со сдвигом на нужную неделю
  late int offsetStartMonth;

  @override
  void initState() {
    _currentDay = DateTime.now();
    firstDayOfMonth = DateTime(_currentDay.year, _currentDay.month, 1);
    firstDayOfNextMonth = DateTime(_currentDay.year, _currentDay.month + 1);
    offsetStartMonth = firstDayOfMonth.weekday - 1;
    dayInMonth = (firstDayOfMonth.difference(firstDayOfNextMonth).inDays).abs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final now = DateTime.now();
    // final firstDayOfMonth = DateTime(now.year, now.month, 1);
    // final numberWeekOfStartMonth = weekNumber(firstDayOfMonth);
    final lastDayOfMonth = DateTime(_currentDay.year, _currentDay.month + 1, 0);
    // final numberWeekOfEndMonth = weekNumber(lastDayOfMonth);
    // final int offset = firstDayOfMonth.weekday - 1;
    final monthTitle = DateFormat('LLLL', 'ru').format(firstDateOfTheWeek(_currentDay));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  changeMonth(false);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                )),
            Text(
              monthTitle,
              style: AppFont.scaffoldTitleDark,
            ),
            IconButton(
              onPressed: () {
                changeMonth(true);
              },
              icon: const RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 7,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 2 / 1,
                  ),
                  itemBuilder: (BuildContext ctx, gridIndex) {
                    return Center(
                        child: Text(
                      weekDay[gridIndex].toUpperCase(),
                      style: TextStyle(color: AppColor.grey3, fontSize: 13),
                    ));
                  }),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10,
              mainAxisExtent: 30,
            ),
            itemCount: lastDayOfMonth.day + offsetStartMonth,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, i) {
              final index = i + 1;
              final day = index - offsetStartMonth;

              return i >= offsetStartMonth
                  ? i > 10 && i < 20
                      ? GestureDetector(
                          onTap: () {
                            print(day);
                            print(_currentDay);
                            // context.router.push(const DiaryItemsScreenRoute());
                          },
                          child: Container(
                              decoration:
                                  BoxDecoration(shape: BoxShape.circle, color: AppColor.accent.withOpacity(0.1)),
                              child: Center(
                                  child: Text(
                                day.toString(),
                                style: const TextStyle(fontSize: 20),
                              ))),
                        )
                      : Center(
                          child: Text(
                          day.toString(),
                          style: const TextStyle(fontSize: 20),
                        ))
                  : const SizedBox();
            }),
        const SizedBox(height: 10),
      ],
    );
  }

  void changeMonth(direction) {
    setState(() {
      _currentDay = direction
          ? DateTime(_currentDay.year, _currentDay.month + 1)
          : DateTime(_currentDay.year, _currentDay.month - 1);
      firstDayOfMonth = DateTime(_currentDay.year, _currentDay.month, 1);
      firstDayOfNextMonth = DateTime(_currentDay.year, _currentDay.month + 1);
      offsetStartMonth = firstDayOfMonth.weekday - 1;
      dayInMonth = (firstDayOfMonth.difference(firstDayOfNextMonth).inDays).abs();
    });
  }
}

int weekNumber(date) {
  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  final firstJan = DateTime(date.year, 1, 1);
  return weeksBetween(firstJan, date);
}

DateTime firstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}
