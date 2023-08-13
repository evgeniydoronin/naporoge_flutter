import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/core/utils/get_week_number.dart';
import '../../../../core/constants/week_data_constant.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/get_stream_status.dart';
import '../../../planning/domain/entities/stream_entity.dart';

import '../../../../core/constants/app_theme.dart';
import '../bloc/home_screen/home_screen_bloc.dart';

class WeekStatusPoint extends StatelessWidget {
  const WeekStatusPoint({super.key});

  Future getCurrentWeekDays() async {
    final isarService = IsarService();
    final isar = await isarService.db;
    final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

    DateTime now = DateTime.now();

    // статус курса (before, after, process)
    Map streamStatus = await getStreamStatus();

    // текущая неделя
    int currentWeekNumber = getWeekNumber(DateTime.now());

    List days = [];

    // До старта курса
    if (streamStatus['status'] == 'before') {
      // Первая неделя курса
      Week week = stream!.weekBacklink.first;

      days = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
    }
    // После завершения курса
    else if (streamStatus['status'] == 'after') {
      // streamStatus['status'] = "after";
    }
    // Во время прохождения курса
    else if (streamStatus['status'] == 'process') {
      Week week = stream!.weekBacklink.where((week) => week.weekNumber == currentWeekNumber).first;

      print('week: ${week.dayBacklink.first.startAt}');
      if (week.dayBacklink.first.startAt != null) {
        days = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
      } else {
        days = await week.dayBacklink.filter().findAll();
      }
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentWeekDays(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List days = snapshot.data;
          DateTime now = DateTime.parse(DateFormat('y-MM-dd').format(DateTime.now()));

          // список дней и статуса
          List daysStatus = [];
          for (Day day in days) {
            // пустая неделя
            if (day.startAt == null) {
              // выполнен
              if (day.completedAt != null) {
                // print('пустая неделя день выполнен');
                daysStatus.add({'status': 'empty_completed', 'startAt': ''});
              }
              // не выполнен
              else {
                // print('пустая неделя день НЕ выполнен');
                daysStatus.add({'status': 'empty_not_completed', 'startAt': ''});
              }
            }
            // не пустая неделя
            else {
              // print(day.startAt);
              DateTime dayStartAt = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
              String dayStartAtString = DateFormat('H:mm').format(day.startAt!);

              // текущий день
              if (dayStartAt.isAtSameMomentAs(now)) {
                // выполнен
                if (day.completedAt != null) {
                  daysStatus.add({'status': 'completed', 'startAt': dayStartAtString});
                }
                // не выполнен
                else {
                  daysStatus.add({'status': 'opened', 'startAt': dayStartAtString});
                }
              }
              // день прошел
              else if (dayStartAt.isBefore(now)) {
                // выполнен
                if (day.completedAt != null) {
                  daysStatus.add({'status': 'completed', 'startAt': dayStartAtString});
                }
                // не выполнен и не воскресенье
                else {
                  if (day.startAt!.weekday != 7) {
                    daysStatus.add({'status': 'skipped', 'startAt': dayStartAtString});
                  }
                }
              }
              // запланированный день
              else if (dayStartAt.isAfter(now)) {
                daysStatus.add({'status': 'future', 'startAt': dayStartAtString});
              }
            }
          }

          print(daysStatus);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 84,
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1 / 1.7,
                ),
                itemCount: 7,
                itemBuilder: (context, gridIndex) {
                  Container _container = Container();
                  // Будущий день
                  if (daysStatus[gridIndex]['status'] == 'future') {
                    _container = Container(
                      height: 110,
                      decoration: BoxDecoration(color: AppColor.grey1, borderRadius: BorderRadius.circular(34)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 34,
                            height: 33,
                            decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(34)),
                            child: Center(
                              child: Text(
                                weekDay[gridIndex].toUpperCase(),
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
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
                                gridIndex == 6 ? '-' : daysStatus[gridIndex]['startAt'],
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Результат дня сохранялся
                  else if (daysStatus[gridIndex]['status'] == 'completed') {
                    _container = Container(
                      decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(34)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(34)),
                            child: Center(
                              child: Text(
                                weekDay[gridIndex].toUpperCase(),
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Container(
                            height: 24,
                            padding: const EdgeInsets.only(bottom: 3),
                            decoration: BoxDecoration(color: AppColor.primary, borderRadius: AppLayout.primaryRadius),
                            child: SvgPicture.asset(
                              'assets/icons/checked_day.svg',
                              height: 24,
                              clipBehavior: Clip.none,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // День пропущен
                  else if (daysStatus[gridIndex]['status'] == 'skipped') {
                    _container = Container(
                      decoration: BoxDecoration(color: AppColor.blk, borderRadius: BorderRadius.circular(34)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(color: AppColor.blk, borderRadius: BorderRadius.circular(34)),
                            child: Center(
                              child: Text(
                                weekDay[gridIndex].toUpperCase(),
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Container(
                            height: 24,
                            padding: const EdgeInsets.only(bottom: 3),
                            decoration: BoxDecoration(color: AppColor.blk, borderRadius: AppLayout.primaryRadius),
                            child: SvgPicture.asset(
                              'assets/icons/missed_day.svg',
                              height: 24,
                              clipBehavior: Clip.none,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Текущий день
                  else if (daysStatus[gridIndex]['status'] == 'opened') {
                    _container = Container(
                      decoration: BoxDecoration(color: AppColor.grey1, borderRadius: BorderRadius.circular(34)),
                      child: Column(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(34)),
                            child: Center(
                              child: Text(
                                weekDay[gridIndex].toUpperCase(),
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Container(
                            height: 24,
                            decoration: const BoxDecoration(
                              // color: AppColor.primary,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(34),
                                bottomRight: Radius.circular(34),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                gridIndex == 6 ? '-' : daysStatus[gridIndex]['startAt'],
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Пустая неделя день не выполнен
                  else if (daysStatus[gridIndex]['status'] == 'empty_not_completed') {
                    _container = Container(
                      height: 110,
                      decoration: BoxDecoration(color: AppColor.grey1, borderRadius: BorderRadius.circular(34)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 34,
                            height: 33,
                            decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(34)),
                            child: Center(
                              child: Text(
                                weekDay[gridIndex].toUpperCase(),
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
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
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Пустая неделя день выполнен
                  else if (daysStatus[gridIndex]['status'] == 'empty_completed') {
                    _container = Container(
                      decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(34)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(34)),
                            child: Center(
                              child: Text(
                                weekDay[gridIndex].toUpperCase(),
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Container(
                            height: 24,
                            padding: const EdgeInsets.only(bottom: 3),
                            decoration: BoxDecoration(color: AppColor.primary, borderRadius: AppLayout.primaryRadius),
                            child: SvgPicture.asset(
                              'assets/icons/checked_day.svg',
                              height: 24,
                              clipBehavior: Clip.none,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return _container;
                },
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
