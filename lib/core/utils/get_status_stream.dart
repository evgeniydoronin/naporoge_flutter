import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../features/planning/domain/entities/stream_entity.dart';
import 'get_week_number.dart';

getStreamStatus(NPStream stream) {
  Map statusStream = {};

  DateTime now = DateTime.now();
  DateTime completedTime = DateTime(now.year, now.month, now.day, 0, 0, 0);
  // текущая неделя
  int weekNumber = getWeekNumber(DateTime.now());

  int daysBefore = stream.startAt!.difference(now).inDays;

  DateTime startStream = stream.startAt!;
  DateTime endStream = stream.startAt!.add(Duration(
      days: (stream.weeks! * 7) - 1, hours: 23, minutes: 59, seconds: 59));

  bool isBeforeStartStream = startStream.isAfter(now);
  bool isAfterEndStream = endStream.isBefore(now);

  // До старта курса
  if (isBeforeStartStream) {
    // до старта курса
    print('до старта курса');
    statusStream = {
      'status': 'beforeStartStream',
      'messages': {
        'topMessage': 'Осталось дней до старта курса - $daysBefore',
      },
      'buttons': {'total': 'Внести результаты'},
      'weekProgress': {
        'progress': 0,
        'title': 'Старт ${DateFormat('dd.MM').format(stream.startAt!)}',
        'description': 'В разделе "Ещё" много полезной теории',
      },
      'weekStatusPoint': [],
    };
    // находим дни первой недели курса
    for (Day day in stream.weekBacklink.first.dayBacklink) {
      // print(day.id);
      statusStream['weekStatusPoint'].add({
        'status': 'opened',
        'dayID': day.id!,
        'title': DateFormat('HH:mm').format(day.startAt!),
        'weekDay': DateFormat('EEEE').format(day.startAt!),
      });
    }
  }
  // После завершения курса
  else if (isAfterEndStream) {
    // после завершения курса
    print('после завершения курса');
    List completedDays = [];

    statusStream = {
      'status': 'afterEndStream',
      'messages': {
        'topMessage': 'Курс пройден',
      },
      'buttons': {
        'status': 'active',
        'total': 'Итоги',
        'page': 'ResultsStreamScreenRoute',
      },
      'weekStatusPoint': [],
      'weekProgress': {
        'title': 'Ты прошел курс',
      },
    };

    for (Week week in stream.weekBacklink) {
      // формируем завершенные дни
      completedDays.addAll(
          week.dayBacklink.where((element) => element.completedAt != null));

      // воскресенье
      Day sunday =
          week.dayBacklink.whereIndexed((index, element) => index == 6).first;

      /////////////////////
      // Последняя неделя курса
      for (Day day in stream.weekBacklink.last.dayBacklink) {
        DateTime dayStartAt =
            DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
        DateTime currentDay = DateTime.parse(DateFormat('y-MM-dd').format(now));

        // statusStream['messages']['topMessage'] = 'Результаты сохранены';

        // print('dayStartAt: $dayStartAt');
        // print('currentDay: $currentDay');

        // Перебираем дни недели
        // если день прошел и day.completedAt == null, статус - skipped
        if (dayStartAt.isBefore(currentDay) && day.completedAt == null) {
          // print('skipped == dayStartAt.isBefore(currentDay)');
          statusStream['weekStatusPoint'].add({
            'status': 'skipped',
            'dayID': day.id!,
            'title': DateFormat('HH:mm').format(day.startAt!),
            'weekDay': DateFormat('EEEE').format(day.startAt!),
          });
        }
        // если день прошел и day.completedAt != null, статус - completed
        else if (dayStartAt.isBefore(currentDay) && day.completedAt != null) {
          // print('completed == dayStartAt.isBefore(currentDay)');
          statusStream['weekStatusPoint'].add({
            'status': 'completed',
            'dayID': day.id!,
            'title': DateFormat('HH:mm').format(day.startAt!),
            'weekDay': DateFormat('EEEE').format(day.startAt!),
          });
        }
        // если текущий день не прошел,
        else if (dayStartAt.isAtSameMomentAs(currentDay)) {
          // если текущий и day.completedAt == null, статус - opened
          if (day.completedAt == null) {
            statusStream['messages']['topMessage'] = 'Внесите результаты дня';

            statusStream['weekStatusPoint'].add({
              'status': 'opened',
              'dayID': day.id!,
              'title': DateFormat('HH:mm').format(day.startAt!),
              'weekDay': DateFormat('EEEE').format(day.startAt!),
            });
          }
          // если текущий и day.completedAt != null, статус - completed
          else {
            statusStream['messages']['topMessage'] = 'Результаты сохранены';

            statusStream['weekStatusPoint'].add({
              'status': 'completed',
              'dayID': day.id!,
              'title': DateFormat('HH:mm').format(day.startAt!),
              'weekDay': DateFormat('EEEE').format(day.startAt!),
            });

            statusStream['buttons']['status'] = 'disable';
          }
        }
        // последующие дни в статусе - opened
        else if (dayStartAt.isAfter(currentDay)) {
          statusStream['weekStatusPoint'].add({
            'status': 'opened',
            'dayID': day.id!,
            'title': DateFormat('HH:mm').format(day.startAt!),
            'weekDay': DateFormat('EEEE').format(day.startAt!),
          });
        }
      }
    }

    int completedDaysInPercent =
        (completedDays.length * 100 / (stream.weeks! * 6))
            .floorToDouble()
            .round();
    int percentLeft = 100 - completedDaysInPercent;

    statusStream['weekProgress']['progress'] =
        completedDaysInPercent.toString();
    statusStream['weekProgress']['description'] =
        'Лузер, ты не выполнил ${percentLeft.toString()}%';
  }
  // Во время прохождения курса
  else if (!isBeforeStartStream && !isAfterEndStream) {
    print('во время прохождения курса');

    List completedDays = [];

    statusStream = {
      'status': 'beforeStartStream',
      'messages': {
        'topMessage': 'Внесите результаты дня',
      },
      'buttons': {
        'status': 'active',
        'total': 'Внести результаты',
        'page': 'DayResultsSaveScreenRoute',
      },
      'weekProgress': {
        'title': 'Ты на первой неделе',
      },
      'weekStatusPoint': [],
    };

    // print('stream.weekBacklink: ${stream.weekBacklink.length}');

    List weeksTitle = [
      'первой',
      'второй',
      'третьей',
      'четвертой',
      'пятой',
      'шестой',
      'седьмой',
      'восьмой',
      'девятой'
    ];
    for (Week week in stream.weekBacklink) {
      // print('weekNumber: $weekNumber');
      // print('week.weekNumber: ${week.weekNumber}');
      if (weekNumber == week.weekNumber) {
        var weekIndex = stream.weekBacklink
            .whereIndexed((index, element) => element.weekNumber == weekNumber);
        // print('weekIndex::: ${weekIndex.indexed.first.$1}');
        statusStream['weekProgress']['title'] =
            'Ты на ${weeksTitle[weekIndex.indexed.first.$1]} неделе';
      }
      // если дни недели были созданы при создании курса
      if (week.dayBacklink.isNotEmpty) {
        // формируем завершенные дни
        completedDays.addAll(
            week.dayBacklink.where((element) => element.completedAt != null));

        // воскресенье
        Day sunday =
            week.dayBacklink.whereIndexed((index, element) => index == 6).first;

        for (Day day in week.dayBacklink) {
          DateTime dayStartAt =
              DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
          DateTime currentDay =
              DateTime.parse(DateFormat('y-MM-dd').format(now));
          /////////////////////
          // Текущая неделя
          if (week.weekNumber == weekNumber) {
            // statusStream['messages']['topMessage'] = 'Результаты сохранены';

            // print('dayStartAt: $dayStartAt');
            // print('currentDay: $currentDay');

            // Перебираем дни недели
            // если день прошел и day.completedAt == null, статус - skipped
            if (dayStartAt.isBefore(currentDay) && day.completedAt == null) {
              // print('skipped == dayStartAt.isBefore(currentDay)');
              statusStream['weekStatusPoint'].add({
                'status': 'skipped',
                'dayID': day.id!,
                'title': DateFormat('HH:mm').format(day.startAt!),
                'weekDay': DateFormat('EEEE').format(day.startAt!),
              });
            }
            // если день прошел и day.completedAt != null, статус - completed
            else if (dayStartAt.isBefore(currentDay) &&
                day.completedAt != null) {
              // print('completed == dayStartAt.isBefore(currentDay)');
              statusStream['weekStatusPoint'].add({
                'status': 'completed',
                'dayID': day.id!,
                'title': DateFormat('HH:mm').format(day.startAt!),
                'weekDay': DateFormat('EEEE').format(day.startAt!),
              });
            }
            // если текущий день не прошел,
            else if (dayStartAt.isAtSameMomentAs(currentDay)) {
              // если текущий и day.completedAt == null, статус - opened
              if (day.completedAt == null) {
                statusStream['messages']['topMessage'] =
                    'Внесите результаты дня';

                statusStream['weekStatusPoint'].add({
                  'status': 'opened',
                  'dayID': day.id!,
                  'title': DateFormat('HH:mm').format(day.startAt!),
                  'weekDay': DateFormat('EEEE').format(day.startAt!),
                });
              }
              // если текущий и day.completedAt != null, статус - completed
              else {
                statusStream['messages']['topMessage'] = 'Результаты сохранены';

                statusStream['weekStatusPoint'].add({
                  'status': 'completed',
                  'dayID': day.id!,
                  'title': DateFormat('HH:mm').format(day.startAt!),
                  'weekDay': DateFormat('EEEE').format(day.startAt!),
                });

                statusStream['buttons']['status'] = 'disable';
              }
            }
            // последующие дни в статусе - opened
            else if (dayStartAt.isAfter(currentDay)) {
              statusStream['weekStatusPoint'].add({
                'status': 'opened',
                'dayID': day.id!,
                'title': DateFormat('HH:mm').format(day.startAt!),
                'weekDay': DateFormat('EEEE').format(day.startAt!),
              });
            }
          }
        }
      }
    }

    int completedDaysInPercent =
        (completedDays.length * 100 / (stream.weeks! * 6))
            .floorToDouble()
            .round();
    int percentLeft = 100 - completedDaysInPercent;

    statusStream['weekProgress']['progress'] =
        completedDaysInPercent.toString();
    statusStream['weekProgress']['description'] =
        '${percentLeft.toString()}% осталось до полного выполнения дела';
  }

  return statusStream;
}
