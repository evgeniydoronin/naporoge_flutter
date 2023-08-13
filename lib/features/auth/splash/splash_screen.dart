import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../../core/services/controllers/service_locator.dart';
import '../../planning/data/sources/local/stream_local_storage.dart';
import '../../planning/domain/entities/stream_entity.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/services/db_client/isar_service.dart';
import '../../../core/utils/get_week_number.dart';
import '../login/domain/user_model.dart';
import '../../planning/presentation/stream_controller.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final isarService = IsarService();

  startSplashScreenTimer() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigateToScreen);
  }

  void navigateToScreen() async {
    final isar = await isarService.db;
    final userExists = await isar.users.count();
    final NPStream? activeStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

    final _streamController = getIt<StreamController>();
    final streamLocalStorage = StreamLocalStorage();

    DateTime now = DateTime.now();
    // пользователь зарегистрирован
    if (userExists != 0) {
      print('SplashScreen - пользователь зарегистрирован');
      // курс не создан
      if (activeStream == null) {
        print('SplashScreen - курс не создан');
        if (context.mounted) {
          AutoRouter.of(context).push(const WelcomeScreenRoute());
        }
      }
      // курс создан
      else {
        print('SplashScreen - курс создан');
        DateTime startStream = activeStream.startAt!;
        DateTime endStream = activeStream.startAt!
            .add(Duration(days: (activeStream.weeks! * 7) - 1, hours: 23, minutes: 59, seconds: 59));
        bool streamNotStarted = startStream.isAfter(now);
        bool streamStarted = startStream.isBefore(now);
        bool isAfterEndStream = endStream.isBefore(now);

        int weeks = activeStream.weeks!;

        // до старта
        if (streamNotStarted) {
          print('SplashScreen - до старта');
          // дни созданы
          if (activeStream.weekBacklink.first.dayBacklink.isNotEmpty) {
            print('SplashScreen - дни созданы');
            if (context.mounted) {
              AutoRouter.of(context).push(const DashboardScreenRoute());
            }
          }
          // дни не созданы
          else {
            print('SplashScreen - дни не созданы');
            if (context.mounted) {
              AutoRouter.of(context).push(SelectDayPeriodRoute(isBackArrow: false));
            }
          }
        }
        // во время прохождения
        else if (streamStarted) {
          print('SplashScreen - после старта');

          // текущая неделя
          int currentWeekNumber = getWeekNumber(DateTime.now());

          Week? week = activeStream.weekBacklink.where((week) => week.weekNumber == currentWeekNumber).firstOrNull;

          print('SplashScreen weeks: $weeks');
          print('SplashScreen activeStream.weekBacklink: ${activeStream.weekBacklink.length}');

          // проверяем количество созданных недель
          // если меньше чем можно создать
          // создаем неделю
          if (weeks < activeStream.weekBacklink.length) {
            // текущая неделя НЕ создана
            if (week == null) {
              Map newWeekData = {};

              print('SplashScreen текущая неделя НЕ создана');

              // понедельник текущей недели
              int daysOfWeek = now.weekday - 1;
              DateTime firstDay = DateTime(now.year, now.month, now.day - daysOfWeek);
              DateTime lastDay = firstDay.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

              print('firstDay: $firstDay');
              print('lastDay: $lastDay');

              // CREATE WEEK
              newWeekData['streamId'] = activeStream.id;
              newWeekData['cells'] = [];
              newWeekData['monday'] = DateFormat('y-MM-dd').format(firstDay);
              newWeekData['weekOfYear'] = currentWeekNumber;

              // create on server
              var createWeek = await _streamController.createWeek(newWeekData);

              print('SplashScreen createWeek: $createWeek');
              AutoRouter.of(context).push(const DashboardScreenRoute());

              // create on local
              if (createWeek['week'] != null) {
                streamLocalStorage.createWeek(createWeek);

                if (context.mounted) {
                  AutoRouter.of(context).push(const DashboardScreenRoute());
                }
              }

              // // first day of the year
              // final DateTime firstDayOfYear = DateTime.utc(2023, 1, 1);
              //
              // // first day of the year weekday (Monday, Tuesday, etc...)
              // final int firstDayOfWeek = firstDayOfYear.weekday;
              //
              // // Calculate the number of days to the first day of the week (an offset)
              // final int daysToFirstWeek = (8 - firstDayOfWeek) % 7;
              //
              // // Get the date of the first day of the week
              // final DateTime firstDayOfGivenWeek = firstDayOfYear
              //     .add(Duration(days: daysToFirstWeek + (currentWeekNumber - 1) * 7));
              //
              // // Get the last date of the week
              // final DateTime lastDayOfGivenWeek =
              // firstDayOfGivenWeek.add(const Duration(days: 6));
              //
              // print('firstDayOfGivenWeek: $firstDayOfGivenWeek');
            }
            // текущая неделя создана
            else {
              print('SplashScreen текущая неделя создана');
              AutoRouter.of(context).push(const DashboardScreenRoute());
            }
          }

          if (context.mounted) {
            AutoRouter.of(context).push(const DashboardScreenRoute());
          }
        }
      }
    }
    // нет пользователя
    else if (userExists == 0) {
      print('SplashScreen - нет пользователя');
      if (context.mounted) {
        AutoRouter.of(context).push(const LoginEmptyRouter());
      }
    }

    // await isar.close();
  }

  @override
  void initState() {
    super.initState();

    startSplashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage('assets/images/waves.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(flex: 3, fit: FlexFit.tight, child: SvgPicture.asset('assets/icons/splash_logo.svg')),
            const Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Объединение молодежного саморазвития',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
