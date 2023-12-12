import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../../core/utils/get_actual_student_day.dart';
import '../../../core/utils/get_current_week_data.dart';
import '../../planning/domain/entities/stream_entity.dart';
import '../../../core/services/db_client/isar_service.dart';
import '../../../core/utils/get_stream_status.dart';

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

  Map data = {};

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
    int passedDays = startStreamAt.difference(now).inDays.abs() + 1;
    // последняя неделя курса
    Map currentWeekData = await getCurrentWeekData();
    print('passedDays: $passedDays');

    Week? lastWeek = currentWeekData['isLast'] ? currentWeekData['week'] : null;
    bool isEmpty = currentWeekData['isEmpty'];
    int weekIndex = currentWeekData['weekIndex'];
    String currentWeekTitle = '';

    // Title
    for (int i = 0; i < weeks; i++) {
      switch (weekIndex) {
        case 0:
          currentWeekTitle = 'первой';
        case 1:
          currentWeekTitle = 'второй';
        case 2:
          currentWeekTitle = 'третьей';
        case 3:
          currentWeekTitle = 'четвертой';
        case 4:
          currentWeekTitle = 'пятой';
        case 5:
          currentWeekTitle = 'шестой';
        case 6:
          currentWeekTitle = 'седьмой';
        case 7:
          currentWeekTitle = 'восьмой';
        case 8:
          currentWeekTitle = 'девятой';
      }
    }
    data['title'] = 'Вы на $currentWeekTitle неделе';

    int leftPercent = 100 - (passedDays * 100 / days).ceil();
    data['percent'] = (passedDays * 100 / days).ceil();
    data['description'] = '$leftPercent% осталось до полного выполнения дела';

    // последняя неделя
    if (lastWeek != null) {
      List lastWeekdays = await isar.days.filter().weekIdEqualTo(lastWeek.id).findAll();
      Day? monday = await isar.days.filter().weekIdEqualTo(lastWeek.id).findFirst();

      // пустая неделя
      if (isEmpty) {
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
                  lastWeekdays[6].completedAt != null) {
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
              // print('текущий день');
              // print('day.completedAt : ${day.completedAt}');
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
                  if (executionScope.length < needForTotal) {
                    data['percent'] = 100;
                    data['description'] = '$leftPercent% осталось до полного выполнения дела';
                  } else {
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
  }

  return data;
}
