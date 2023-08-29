import 'package:isar/isar.dart';
import '../../../../core/utils/get_week_number.dart';
import '../../../planning/domain/entities/stream_entity.dart';

import '../../../../core/services/db_client/isar_service.dart';

Future getWeeksProcess() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final NPStream? stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  int currentWeekNumber = getWeekNumber(DateTime.now());

  List weeksData = [];
  // текущая неделя и все предыдущие
  for (Week week in stream!.weekBacklink) {
    // прошедшие недели
    if (week.weekNumber! <= currentWeekNumber) {
      // все дни недели
      List weekDays = await week.dayBacklink.filter().findAll();
      final weekDay = await week.dayBacklink.filter().completedAtIsNotNull().startAtIsNotNull().findFirst();

      // не пустая неделя
      // есть время старта
      // сортируем дни по порядку
      if (weekDay != null) {
        weekDays = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
      }

      List daysProgress = [];

      for (Day day in weekDays) {
        DayResult? dayResult = await isar.dayResults.filter().dayIdEqualTo(day.id).resultIsNotNull().findFirst();
        daysProgress.addAll([dayResult]);
      }

      weeksData.addAll([
        {'week': week, 'daysProgress': daysProgress}
      ]);
    }
  }

  return weeksData;
}
