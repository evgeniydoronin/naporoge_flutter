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

class AppCalendar extends StatefulWidget {
  const AppCalendar({Key? key}) : super(key: key);

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final numberWeekOfStartMonth = weekNumber(firstDayOfMonth);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final numberWeekOfEndMonth = weekNumber(lastDayOfMonth);
    final int offset = firstDayOfMonth.weekday - 1;
    final monthTitle = DateFormat('LLLL', 'ru').format(firstDateOfTheWeek(now));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                )),
            Text(
              monthTitle,
              style: AppFont.scaffoldTitleDark,
            ),
            IconButton(
                onPressed: () {},
                icon: RotatedBox(
                    quarterTurns: 2,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                    ))),
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
            itemCount: lastDayOfMonth.day + offset,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, i) {
              final index = i + 1;
              final day = index - offset;

              return i >= offset
                  ? i > 10 && i < 20
                      ? GestureDetector(
                          onTap: () {
                            context.router.push(const DiaryItemsScreenRoute());
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.accent.withOpacity(0.1)),
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
