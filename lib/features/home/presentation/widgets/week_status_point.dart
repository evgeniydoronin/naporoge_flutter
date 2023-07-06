import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:naporoge/core/constants/week_data_constant.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/get_week_number.dart';

class WeekStatusPoint extends StatelessWidget {
  const WeekStatusPoint({super.key, required this.stream});

  final NPStream stream;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime completedTime = DateTime(now.year, now.month, now.day, 0, 0, 0);

    List<Container> _container = [];

    // текущая неделя
    int weekNumber = getWeekNumber(DateTime.now());
    for (Week week in stream.weekBacklink) {
      if (week.weekNumber == weekNumber) {
        for (Day day in week.dayBacklink) {
          if (day.dayResultBacklink.isNotEmpty) {
            _container.add(Container(
              decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(34)),
              child: Column(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(34)),
                    child: Center(
                      child: Text(
                        weekDay[day.startAt!.weekday - 1].toUpperCase(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Container(
                    height: 24,
                    padding: const EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: AppLayout.primaryRadius),
                    child: SvgPicture.asset(
                      'assets/icons/checked_day.svg',
                      height: 24,
                      clipBehavior: Clip.none,
                    ),
                  ),
                ],
              ),
            ));
          } else {
            final DateTime? dayStartAt = day.startAt;
            // если день прошел
            bool isDaySkipped = dayStartAt!.isBefore(completedTime);
            if (isDaySkipped) {
              _container.add(Container(
                decoration: BoxDecoration(
                    color: AppColor.blk,
                    borderRadius: BorderRadius.circular(34)),
                child: Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                          color: AppColor.blk,
                          borderRadius: BorderRadius.circular(34)),
                      child: Center(
                        child: Text(
                          weekDay[day.startAt!.weekday - 1].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                      padding: const EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
                          color: AppColor.blk,
                          borderRadius: AppLayout.primaryRadius),
                      child: SvgPicture.asset(
                        'assets/icons/missed_day.svg',
                        height: 24,
                        clipBehavior: Clip.none,
                      ),
                    ),
                  ],
                ),
              ));
            } else {
              _container.add(Container(
                decoration: BoxDecoration(
                    color: AppColor.grey1,
                    borderRadius: BorderRadius.circular(34)),
                child: Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(34)),
                      child: Center(
                        child: Text(
                          weekDay[day.startAt!.weekday - 1].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      height: 28,
                      width: 34,
                      decoration: const BoxDecoration(
                        // color: AppColor.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(34),
                          bottomRight: Radius.circular(34),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('HH:mm').format(day.startAt!).toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
            }
          }
        }
      }
    }
    _container.add(Container(
      decoration: BoxDecoration(
          color: AppColor.grey1, borderRadius: BorderRadius.circular(34)),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(34)),
            child: const Center(
              child: Text(
                'ВС',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            height: 28,
            width: 34,
            decoration: const BoxDecoration(
              // color: AppColor.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(34),
                bottomRight: Radius.circular(34),
              ),
            ),
            child: const Center(
              child: Text(
                '-',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 18),
        decoration: AppLayout.boxDecorationShadowBG,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [..._container],
        ),
      ),
    );
  }
}
