import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../planning/presentation/bloc/active_course/active_stream_bloc.dart';
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
          // неделя создана
          if (activeStream.weekBacklink.isNotEmpty) {
            print('SplashScreen - неделя создана');
            if (context.mounted) {
              context.router.replace(const DashboardScreenRoute());
            }
          }
          // неделя не создана
          else {
            print('SplashScreen - неделя не создана');
            if (context.mounted) {
              /// активное дело
              context.read<ActiveStreamBloc>().add(ActiveStreamChanged(npStream: activeStream));
              context.router.replace(const SelectDayPeriodRoute());
            }
          }
        }
        // во время прохождения
        else if (streamStarted) {
          print('SplashScreen - после старта');

          // текущая неделя
          int currentWeekNumber = getWeekNumber(DateTime.now());

          Week? week = activeStream.weekBacklink.where((week) => week.weekNumber == currentWeekNumber).firstOrNull;

          // print('SplashScreen weeks: $weeks');
          // print('SplashScreen activeStream.weekBacklink: ${activeStream.weekBacklink.length}');

          // Первая неделя может создаться пустой без дней
          // проверяем и создаем дни
          if (week == null) {
            // print(activeStream);
            // ни одной недели на курсе не создано
            if (activeStream.weekBacklink.isEmpty) {
              Map newWeekData = {};

              // print('SplashScreen Понедельник, текущая неделя НЕ создана');

              // понедельник текущей недели
              int daysOfWeek = now.weekday - 1;
              DateTime firstDay = DateTime(now.year, now.month, now.day - daysOfWeek);
              DateTime lastDay = firstDay.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

              // print('firstDay: $firstDay');
              // print('lastDay: $lastDay');

              // CREATE WEEK
              newWeekData['streamId'] = activeStream.id;
              newWeekData['cells'] = [];
              newWeekData['monday'] = DateFormat('y-MM-dd').format(firstDay);
              newWeekData['weekOfYear'] = currentWeekNumber;

              // create on server
              var createWeek = await _streamController.createWeek(newWeekData);

              print('SplashScreen createWeek: $createWeek');

              // create on local
              if (createWeek['week'] != null) {
                streamLocalStorage.createWeek(createWeek);
              }
            }
            // есть на курсе созданные недели
            else {
              // проверяем количество созданных недель
              // если меньше чем можно создать
              // создаем неделю
              if (activeStream.weekBacklink.length < weeks) {
                // текущая неделя НЕ создана
                Map newWeekData = {};

                print('SplashScreen текущая неделя НЕ создана');

                // понедельник текущей недели
                int daysOfWeek = now.weekday - 1;
                DateTime firstDay = DateTime(now.year, now.month, now.day - daysOfWeek);
                DateTime lastDay = firstDay.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

                // CREATE WEEK
                newWeekData['streamId'] = activeStream.id;
                newWeekData['cells'] = [];
                newWeekData['monday'] = DateFormat('y-MM-dd').format(firstDay);
                newWeekData['weekOfYear'] = currentWeekNumber;

                // create on server
                var createWeek = await _streamController.createWeek(newWeekData);

                // create on local
                if (createWeek['week'] != null) {
                  streamLocalStorage.createWeek(createWeek);
                }
              }
            }
          }

          // найти текущую неделю
          // если вторая или третья
          // проверить на количество созданных
          // если вторая, третья неделя имеет дубликаты
          // отправить запрос на удаление дубликатов на сервер
          // удалить дубликаты в локальной БД
          // ID дубликатов недель
          List weeksIdForDelete = [];
          List daysIdForDelete = [];

          if (week != null) {
            // print('activeStream 1: ${activeStream.weekBacklink.length}');
            if (currentWeekNumber == week.weekNumber) {
              List allCurrentWeeks =
                  await activeStream.weekBacklink.filter().weekNumberEqualTo(currentWeekNumber).findAll();
              // print('currentWeekNumber: $currentWeekNumber');
              Week neededWeek = allCurrentWeeks.first;

              for (Week week in allCurrentWeeks) {
                if (week != neededWeek) {
                  weeksIdForDelete.add(week.id);

                  List daysOfWeek = await week.dayBacklink.filter().findAll();

                  for (Day day in daysOfWeek) {
                    daysIdForDelete.add(day.id);
                  }
                }
              }
            }
          }

          // отправляем запрос на удаление дубликатов на сервер
          // удаляем дубликаты в локальной БД
          if (weeksIdForDelete.isNotEmpty) {
            Map deleteDuplicates = {
              'weeksIdForDelete': weeksIdForDelete,
              'daysIdForDelete': daysIdForDelete,
            };
            // print('deleteDuplicates: $deleteDuplicates');
            // delete duplicates on server
            var resDeleteDuplicates = await _streamController.deleteDuplicatesResult(deleteDuplicates);

            // если успешное удаление
            if (resDeleteDuplicates['status'] == 'success') {
              print(resDeleteDuplicates['data']);
              // удаляем локальные дубли
              await streamLocalStorage.deleteDuplicatesResult(resDeleteDuplicates['data']);
            }
          }

          if (context.mounted) {
            context.router.replace(const DashboardScreenRoute());
          }
        }
      }
    }
    // нет пользователя
    else if (userExists == 0) {
      print('SplashScreen - нет пользователя');
      if (context.mounted) {
        AutoRouter.of(context).navigate(const LoginEmptyRouter());
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
