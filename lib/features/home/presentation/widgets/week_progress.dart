import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/get_week_number.dart';

class WeekProgress extends StatelessWidget {
  const WeekProgress({super.key, required this.stream});

  final NPStream stream;

  @override
  Widget build(BuildContext context) {
    // текущая неделя
    int weekNumber = getWeekNumber(DateTime.now());

    List completedDays = [];
    for (Week week in stream.weekBacklink) {
      completedDays.addAll(
          week.dayBacklink.where((element) => element.completedAt != null));
      if (week.weekNumber == weekNumber) {
        print(week);
      }
    }

    int completedDaysInPercent =
        (completedDays.length * 100 / (stream.weeks! * 6))
            .floorToDouble()
            .round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 45),
        decoration: AppLayout.boxDecorationShadowBG,
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: CircularPercentIndicator(
                radius: 30,
                percent: completedDaysInPercent / 100,
                center: Text(
                  '$completedDaysInPercent%',
                  style: TextStyle(
                      color: AppColor.accentBOW,
                      fontSize: AppFont.large,
                      fontWeight: FontWeight.w800),
                ),
                progressColor: AppColor.accentBOW,
                backgroundColor: AppColor.grey1,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ты на первой неделе',
                    style: AppFont.largeExtraBold,
                  ),
                  Text(
                    '$completedDaysInPercent% осталось до полного выполнения дела',
                    style: AppFont.smallNormal,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
