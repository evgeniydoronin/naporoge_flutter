import 'package:intl/intl.dart';

import '../../features/planning/domain/entities/stream_entity.dart';
import 'get_week_number.dart';

getStreamStatus(stream) {
  DateTime now = DateTime.now();

  int daysBefore = stream.startAt!.difference(now).inDays;

  DateTime startStream = stream.startAt!;
  DateTime endStream = stream.startAt!.add(Duration(
      days: (stream.weeks! * 7) - 1, hours: 23, minutes: 59, seconds: 59));

  bool isBeforeStartStream = startStream.isAfter(now);
  bool isAfterEndStream = endStream.isBefore(now);

  Map statusStream = {};

  if (isBeforeStartStream) {
    statusStream = {
      'status': 'beforeStartStream',
      'topMessage': 'Осталось дней до старта курса - $daysBefore'
    };
  } else if (isAfterEndStream) {
    statusStream = {'status': 'isAfterEndStream', 'topMessage': 'Курс пройден'};
    // _btnText = 'Итоги работы';
    // topMessage = 'Курс пройден';
    // activeBtnDayResultSave = true;
  } else if (!isBeforeStartStream && !isAfterEndStream) {
    statusStream = {
      'status': 'inStream',
    };
    // текущая неделя
    int weekNumber = getWeekNumber(DateTime.now());
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
