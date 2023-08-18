import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../planning/domain/entities/stream_entity.dart';
import '../../../core/services/db_client/isar_service.dart';
import '../../../core/utils/get_stream_status.dart';
import '../../../core/utils/get_week_number.dart';

Future getHomeStatus() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  DateTime now = DateTime.now();

  // статус курса (before, after, process)
  Map streamStatus = await getStreamStatus();

  // сообщение в шапке
  Map topMessage = {'text': 'Внесите результаты дня'};
  // статус кнопки сохранения
  Map button = {
    'isActive': false, // по умолчанию
  };

  // текущая неделя
  int currentWeekNumber = getWeekNumber(DateTime.now());

  print('currentWeekNumber: $currentWeekNumber');

  // Во время прохождения курса
  if (streamStatus['status'] == 'process') {
    Week week = stream!
        .weekBacklink
        .where((week) => week.weekNumber == currentWeekNumber)
        .first;

    print('currentWeek: ${week.weekNumber}');

    List days = await isar.days.filter().weekIdEqualTo(week.id).sortByStartAt().findAll();

    // проверки в воскресенье
    if (now.weekday == 7) {
      // завершенные дни
      List daysCompleted = await isar.days.filter().weekIdEqualTo(week.id).completedAtIsNotNull().findAll();
      // завершенные дни текущей недели не пустые
      if (daysCompleted.isNotEmpty) {
        // текущее воскресенье
        final sunday = await isar.days.get(days[6].id);

        // воскресенье не сохранялось
        if (sunday!.completedAt == null) {
          List executionScope = [];
          // проверяем объем выполнения дня
          for (Day dayCompleted in daysCompleted) {
            int i = await isar.dayResults.filter().dayIdEqualTo(dayCompleted.id).executionScopeGreaterThan(0).count();
            // значение выполненного объема больше 0
            if (i != 0) {
              executionScope.add(i);
            }
          }
          print('executionScope: $executionScope');

          // количество выполненных дней
          if (executionScope.length < 6) {
            // активируем кнопку сохранения
            button['isActive'] = true;
          } else {
            topMessage['text'] = 'Выходной';
          }
        }
        // воскресенье сохранялось
        else {
          topMessage['text'] = 'Результаты сохранены';
        }
      }
    }
    // проверки в будни + суббота
    else {
      for (Day day in days) {
        DateTime dayStartAt = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

        // текущий день
        if (dayStartAt.isAtSameMomentAs(DateTime.parse(DateFormat('y-MM-dd').format(now)))) {
          // проверяем выполненные дни
          if (day.completedAt != null) {
            topMessage['text'] = 'Результаты сохранены';
          } else {
            button['isActive'] = true;
          }
        }
      }
    }
  }

  return {'button': button, 'topMessage': topMessage};
}
