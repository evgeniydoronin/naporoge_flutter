import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/circular_loading.dart';
import '../utils/get_main_diary_screen_data.dart';

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

  late DateTime lastDayOfMonth;
  late DateTime lastDayOfPreviousMonth;

  // Начало месяца со сдвигом на нужную неделю
  late int offsetStartMonth;

  late String monthTitle;

  late Future calendarData;

  @override
  void initState() {
    _currentDay = DateTime.now();
    firstDayOfMonth = DateTime(_currentDay.year, _currentDay.month, 1);
    firstDayOfNextMonth = DateTime(_currentDay.year, _currentDay.month + 1);
    lastDayOfMonth = DateTime(_currentDay.year, _currentDay.month + 1, 0);
    lastDayOfPreviousMonth = DateTime(_currentDay.year, _currentDay.month, 0);
    offsetStartMonth = firstDayOfMonth.weekday - 1;
    dayInMonth = (firstDayOfMonth.difference(firstDayOfNextMonth).inDays).abs();
    monthTitle = DateFormat('LLLL', 'ru').format(_currentDay);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () async {
                  await getMainDiaryData(DateTime.now());
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
              onPressed: () async {
                CircularLoading(context).startLoading();
                final r = await getMainDiaryData(DateTime.now());
                // print(r['calendarData']);
                // print(r['calendarData'] != null);
                if (r['calendarData'] != null) {
                  print('object');
                  if (context.mounted) {
                    CircularLoading(context).stopLoading();
                  }
                }
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
      monthTitle = DateFormat('LLLL', 'ru').format(DateTime(_currentDay.year, _currentDay.month));
    });
  }
}
