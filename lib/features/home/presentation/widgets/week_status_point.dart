import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/week_data_constant.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import '../../../../core/constants/app_theme.dart';
import '../../utils/get_current_week_days_point.dart';

class WeekStatusPoint extends StatelessWidget {
  const WeekStatusPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentWeekDaysPoint(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List days = snapshot.data['days'];

          // адаптация текущего дня до 3 ночи
          DateTime actualUserDay = snapshot.data['actualUserDay'];

          // список дней и статуса
          List daysStatus = [];

          // неделя не пустая
          if (days.isNotEmpty) {
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
                DateTime _dayStartAt = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
                DateTime dayStartAt = DateTime(_dayStartAt.year, _dayStartAt.month, _dayStartAt.day);
                String dayStartAtString = DateFormat('H:mm').format(day.startAt!);

                // print('actualUserDay: $actualUserDay');
                // print('dayStartAt: $dayStartAt');

                // текущий день
                if (dayStartAt.isAtSameMomentAs(actualUserDay)) {
                  // print('dayStartAt: $dayStartAt');
                  // print('actualUserDay: $actualUserDay');
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
                else if (dayStartAt.isBefore(actualUserDay)) {
                  // выполнен
                  if (day.completedAt != null) {
                    daysStatus.add({'status': 'completed', 'startAt': dayStartAtString});
                  }
                  // не выполнен
                  else {
                    daysStatus.add({'status': 'skipped', 'startAt': dayStartAtString});
                  }
                }
                // запланированный день
                else if (dayStartAt.isAfter(actualUserDay)) {
                  daysStatus.add({'status': 'future', 'startAt': dayStartAtString});
                }
              }
            }
          }
          // неделя пустая
          else {
            for (int i = 0; i < 7; i++) {
              daysStatus.add({'status': 'empty_not_completed', 'startAt': ''});
            }
          }

          // print(daysStatus);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 98,
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1 / 1.9,
                ),
                itemCount: 7,
                itemBuilder: (context, gridIndex) {
                  Container _container = Container();
                  // Будущий день
                  if (daysStatus[gridIndex]['status'] == 'future') {
                    _container = Container(
                      // height: 110,
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
                            height: 30,
                            // width: 34,
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
                      // height: 110,
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
                            height: 30,
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
                                style: TextStyle(fontSize: 10),
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
