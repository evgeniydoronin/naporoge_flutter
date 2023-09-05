import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/circular_loading.dart';
import '../utils/get_main_diary_screen_data.dart';
import '../utils/get_month_data.dart';

List<String> weekDay = [
  'пн',
  'вт',
  'ср',
  'чт',
  'пт',
  'сб',
  'вс',
];

class DiaryCalendarBox extends StatefulWidget {
  const DiaryCalendarBox({Key? key}) : super(key: key);

  @override
  State<DiaryCalendarBox> createState() => _DiaryCalendarBoxState();
}

class _DiaryCalendarBoxState extends State<DiaryCalendarBox> {
  late DateTime currentDay;

  @override
  void initState() {
    currentDay = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map? monthData;
    return FutureBuilder(
        future: getMonthData(currentDay, null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            monthData = snapshot.data;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          CircularLoading(context).startLoading();
                          monthData = await getMonthData(monthData!['currentDay'], false);

                          if (monthData != null) {
                            setState(() {
                              currentDay = monthData!['currentDay'];
                            });
                            if (context.mounted) {
                              CircularLoading(context).stopAutoRouterLoading();
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        )),
                    Text(
                      monthData!['monthTitle'],
                      style: AppFont.scaffoldTitleDark,
                    ),
                    IconButton(
                      onPressed: () async {
                        CircularLoading(context).startLoading();
                        monthData = await getMonthData(monthData!['currentDay'], true);
                        setState(() {
                          currentDay = monthData!['currentDay'];
                        });
                        if (context.mounted) {
                          CircularLoading(context).stopAutoRouterLoading();
                        }
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
                DiaryCalendarGrid(monthData: monthData ?? {}),
                const SizedBox(height: 10),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class DiaryCalendarGrid extends StatefulWidget {
  final Map monthData;

  const DiaryCalendarGrid({super.key, required this.monthData});

  @override
  State<DiaryCalendarGrid> createState() => _DiaryCalendarGridState();
}

class _DiaryCalendarGridState extends State<DiaryCalendarGrid> {
  late DateTime isActiveDay;

  @override
  void initState() {
    isActiveDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    print('isActiveDay: $isActiveDay');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 10,
          mainAxisExtent: 30,
        ),
        itemCount: widget.monthData['days'] + widget.monthData['offsetStartMonth'],
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, cellIndex) {
          final index = cellIndex + 1;
          final _day = index - widget.monthData['offsetStartMonth'];
          DateTime day =
              DateTime(widget.monthData['currentDay'].year, widget.monthData['currentDay'].month, _day.toInt());

          // вывод дней со сдвигом ячейки
          if (widget.monthData['offsetStartMonth'] <= cellIndex) {
            return GestureDetector(
              onTap: () async {
                CircularLoading(context).startLoading();

                setState(() {
                  isActiveDay = day;
                });

                final diaryData = await getMainDiaryData(day);

                if (diaryData != null) {
                  if (context.mounted) {
                    CircularLoading(context).stopAutoRouterLoading();
                  }
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActiveDay == day ? AppColor.accent.withOpacity(0.5) : AppColor.accent.withOpacity(0.1)),
                  child: Center(
                      child: Text(
                    day.day.toString(),
                    style: const TextStyle(fontSize: 20),
                  ))),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
