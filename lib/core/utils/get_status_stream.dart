import 'package:intl/intl.dart';

import '../../features/planning/domain/entities/stream_entity.dart';
import 'get_week_number.dart';

getStreamStatus(stream) {
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

  if (isBeforeStartStream) {
    // до старта курса
    statusStream = {
      'status': 'beforeStartStream',
      'topMessage': 'Осталось дней до старта курса - $daysBefore'
    };
  } else if (isAfterEndStream) {
    // после завершения курса
    statusStream = {'status': 'afterEndStream', 'topMessage': 'Курс пройден'};
  } else if (!isBeforeStartStream && !isAfterEndStream) {
    // во время
    statusStream = {
      'status': 'inStream',
      'weekNumber': weekNumber,
      'completedTime': completedTime,
    };
    for (Week week in stream.weekBacklink) {
      if (week.weekNumber == weekNumber) {
        // дни текущей недели
        for (Day day in week.dayBacklink) {
          DateTime dayStartAt =
              DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
          DateTime currentDay =
              DateTime.parse(DateFormat('y-MM-dd').format(now));
          // текущий день
          if (dayStartAt.isAtSameMomentAs(currentDay)) {
            if (day.dayResultBacklink.isNotEmpty) {
              // topMessage = 'Результаты дня сохранены';
              // activeBtnDayResultSave = false;
              statusStream['topMessage'] = 'Результаты сохранены';
            } else {
              statusStream['topMessage'] = 'Внесите результаты дня';
            }
          }
        }
      }
    }
  }

  return statusStream;
}
