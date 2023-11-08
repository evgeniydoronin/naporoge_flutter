import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/core/utils/get_actual_student_day.dart';
import '../../planning/domain/entities/stream_entity.dart';

import '../../../core/services/db_client/isar_service.dart';
import '../../../core/utils/get_stream_status.dart';
import '../../../core/utils/get_week_number.dart';

Future getCourseProgress() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
  DateTime startStreamAt = stream!.startAt!;
  int weeks = stream.weeks!;
  int days = weeks * 7;

  DateTime now = DateTime.parse(DateFormat('yyyy-MM-dd').format(getActualStudentDay()));

  // статус курса (before, after, process)
  Map streamStatus = await getStreamStatus();

  // Проверка в предпоследний и последний день курса
  // для вывода Итогов
  bool isLastWeekOnStream = false;

  // текущая неделя
  int currentWeekNumber = getWeekNumber(DateTime.now());

  Map data = {};

  // print('currentWeekNumber: $currentWeekNumber');

  // До старта курса
  if (streamStatus['status'] == 'before') {
    data = {
      'title': 'Старт ${DateFormat('dd.MM').format(startStreamAt)}',
      'description': 'В разделе "Ещё" много полезной теории',
      'percent': 0,
    };
  }
  // После завершения курса
  else if (streamStatus['status'] == 'after') {
    int leftPercent = 0;
    data['title'] = 'Курс завершен';
    data['percent'] = 100;
    data['description'] = '$leftPercent% осталось до полного выполнения дела';
    data['colored'] = true;
  }
  // Во время прохождения курса
  else if (streamStatus['status'] == 'process') {
    // + 1: прибавляем текущий день, он сразу считается как прошедший
    int passedDays = startStreamAt
        .difference(now)
        .inDays
        .abs() + 1;
    // последняя неделя курса
    Week? lastWeek = stream.weekBacklink.elementAtOrNull(weeks - 1);

    // Title
    for (int i = 0; i < weeks; i++) {
      Week? week = stream.weekBacklink.elementAtOrNull(i);

      if (week != null) {
        String _currentWeek = '';
        if (week.weekNumber == currentWeekNumber) {
          switch (i) {
            case 0:
              _currentWeek = 'первой';
            case 1:
              _currentWeek = 'второй';
            case 2:
              _currentWeek = 'третьей';
            case 3:
              _currentWeek = 'четвертой';
            case 4:
              _currentWeek = 'пятой';
            case 5:
              _currentWeek = 'шестой';
            case 6:
              _currentWeek = 'седьмой';
            case 7:
              _currentWeek = 'восьмой';
            case 8:
              _currentWeek = 'девятой';
          }

          data['title'] = 'Вы на $_currentWeek неделе';
          print('Вы на $_currentWeek неделе');
        }
      }
    }

    int leftPercent = 100 - (passedDays * 100 / days).ceil();
    data['percent'] = (passedDays * 100 / days).ceil();
    data['description'] = '$leftPercent% осталось до полного выполнения дела';

    // последняя неделя
    if (lastWeek != null && currentWeekNumber == lastWeek.weekNumber) {
      print('getCourseProgress: текущая неделя последняя');
      List lastWeekdays = await isar.days.filter().weekIdEqualTo(lastWeek.id).findAll();
      Day? monday = await isar.days.filter().weekIdEqualTo(lastWeek.id).findFirst();
      // пустая неделя
      bool weekIsEmpty = true;
      if (monday?.startAt != null) {
        weekIsEmpty = false;
      }
      // пустая неделя
      if (weekIsEmpty) {
        print('пустая последняя неделя 33');
        // суббота
        if (now.weekday == 6 || now.weekday == 7) {
          // завершенные дни текущей недели
          List daysWeekCompleted = await isar.days.filter().weekIdEqualTo(lastWeek.id).completedAtIsNotNull().findAll();

          // вывод итогов
          int needForTotal = weeks * 6;

          // Результат выполнения текущей недели
          List currentWeekExecutionScope = [];
          if (daysWeekCompleted.isNotEmpty) {
            for (int i = 0; i < daysWeekCompleted.length; i++) {
              Day day = daysWeekCompleted[i];
              final res = await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

              if (res != null) {
                currentWeekExecutionScope.add(res);
              }
            }
          }

          List weekIds = stream.weekBacklink.map((week) => week.id).toList();

          // Завершенные дни
          List daysIdCompleted = [];
          for (int i = 0; i < weekIds.length; i++) {
            List daysInWeek = await isar.days.filter().weekIdEqualTo(weekIds[i]).completedAtIsNotNull().findAll();
            daysIdCompleted.addAll(daysInWeek);
          }

          // Результат выполнения дня
          List executionScope = [];
          if (daysIdCompleted.isNotEmpty) {
            for (int i = 0; i < daysIdCompleted.length; i++) {
              Day day = daysIdCompleted[i];
              final res = await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

              if (res != null) {
                executionScope.add(res);
              }
            }
          }

          for (Day day in lastWeekdays) {
            // saturday
            if (now.weekday == 6) {
              // суботта выполнена
              if (lastWeekdays[5].completedAt != null) {
                if (executionScope.length >= needForTotal || currentWeekExecutionScope.length >= 6) {
                  int leftPercent = 0;
                  data['percent'] = 100;
                  data['description'] = '$leftPercent% осталось до полного выполнения дела';
                  data['colored'] = true;
                }
              }
            }
            // воскресенье
            else if (now.weekday == 7) {
              if (executionScope.length >= needForTotal ||
                  currentWeekExecutionScope.length >= 6 ||
                  lastWeekdays[6].completedAt != null
              ) {
                int leftPercent = 0;
                data['percent'] = 100;
                data['description'] = '$leftPercent% осталось до полного выполнения дела';
                data['colored'] = true;
              }
            }
          }
        }
      }
      // НЕ пустая неделя
      else {
        print('НЕ пустая последняя неделя');
        // суббота или воскресенье
        if (now.weekday == 6 || now.weekday == 7) {
          // завершенные дни текущей недели
          List daysWeekCompleted = await isar.days.filter().weekIdEqualTo(lastWeek.id).completedAtIsNotNull().findAll();

          // вывод итогов
          int needForTotal = weeks * 6;

          // Результат выполнения текущей недели
          List currentWeekExecutionScope = [];
          if (daysWeekCompleted.isNotEmpty) {
            for (int i = 0; i < daysWeekCompleted.length; i++) {
              Day day = daysWeekCompleted[i];
              final res = await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

              if (res != null) {
                currentWeekExecutionScope.add(res);
              }
            }
          }

          List weekIds = stream.weekBacklink.map((week) => week.id).toList();

          // Завершенные дни
          List daysIdCompleted = [];
          for (int i = 0; i < weekIds.length; i++) {
            List daysInWeek = await isar.days.filter().weekIdEqualTo(weekIds[i]).completedAtIsNotNull().findAll();
            daysIdCompleted.addAll(daysInWeek);
          }

          // Результат выполнения дня
          List executionScope = [];
          if (daysIdCompleted.isNotEmpty) {
            for (int i = 0; i < daysIdCompleted.length; i++) {
              Day day = daysIdCompleted[i];
              final res = await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

              if (res != null) {
                executionScope.add(res);
              }
            }
          }

          for (Day day in lastWeekdays) {
            DateTime dayStartAt = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

            // текущий день
            if (dayStartAt.isAtSameMomentAs(DateTime.parse(DateFormat('y-MM-dd').format(now)))) {
              print('текущий день');
              print('day.completedAt : ${day.completedAt}');
              // проверяем выполненные дни
              if (day.completedAt != null) {
                if (now.weekday == 7) {
                  data['percent'] = 100;
                  data['description'] = '$leftPercent% осталось до полного выполнения дела';
                  data['colored'] = true;
                } else {
                  if (executionScope.length >= needForTotal || currentWeekExecutionScope.length >= 6) {
                    data['percent'] = 100;
                    data['description'] = '0% осталось до полного выполнения дела';
                    data['colored'] = true;
                  }
                }
              }
              // день не выполнен
              else {
                if (now.weekday == 7) {
                  data['percent'] = 100;
                  data['description'] = '$leftPercent% осталось до полного выполнения дела';
                  data['colored'] = true;
                }
              }
            }
          }
        }
      }
    }
  }

  return data;
}
