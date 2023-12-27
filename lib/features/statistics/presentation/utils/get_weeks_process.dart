import 'package:isar/isar.dart';
import 'package:naporoge/core/utils/get_actual_student_day.dart';
import '../../../../core/utils/get_stream_status.dart';
import '../../../../core/utils/get_week_number.dart';
import '../../../planning/domain/entities/stream_entity.dart';

import '../../../../core/services/db_client/isar_service.dart';

Future getWeeksProcess() async {
  Map streamStatus = await getStreamStatus();
  final isarService = IsarService();
  final isar = await isarService.db;
  final NPStream? stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  List weeksData = [];

  /// До старта курса
  if (streamStatus['status'] == 'before') {
    /// Первая неделя
    Week firstWeek = stream!.weekBacklink.first;

    // все дни недели
    List weekDays = await firstWeek.dayBacklink.filter().findAll();
    final weekDay = await firstWeek.dayBacklink.filter().completedAtIsNotNull().startAtIsNotNull().findFirst();

    // не пустая неделя
    // есть время старта
    // сортируем дни по порядку
    if (weekDay != null) {
      weekDays = await firstWeek.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
    }

    List daysProgress = [];
    List days = [];

    for (Day day in weekDays) {
      DayResult? dayResult = await isar.dayResults.filter().dayIdEqualTo(day.id).resultIsNotNull().findFirst();
      daysProgress.addAll([
        {'day': day, 'dayResult': dayResult}
      ]);
      // print('dayResult: $dayResult, day: ${day.startAt}');
    }

    weeksData.addAll([
      {'week': firstWeek, 'daysProgress': daysProgress, 'weekResultsSave': false}
    ]);
  }

  /// После завершения
  else if (streamStatus['status'] == 'after') {
    // текущая неделя и все предыдущие
    for (Week week in stream!.weekBacklink) {
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
      List days = [];

      for (Day day in weekDays) {
        DayResult? dayResult = await isar.dayResults.filter().dayIdEqualTo(day.id).resultIsNotNull().findFirst();
        daysProgress.addAll([
          {'day': day, 'dayResult': dayResult}
        ]);
        // print('dayResult: $dayResult, day: ${day.startAt}');
      }

      weeksData.addAll([
        {'week': week, 'daysProgress': daysProgress, 'weekResultsSave': true}
      ]);
    }
  }

  /// В процессе
  else if (streamStatus['status'] == 'process') {
    // текущая неделя и все предыдущие
    for (Week week in stream!.weekBacklink) {
      DateTime monday = week.monday!;

      if (monday.isBefore(DateTime.now())) {
        // все дни недели по порядку
        List weekDays = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();

        List daysProgress = [];

        for (Day day in weekDays) {
          DayResult? dayResult = await isar.dayResults.filter().dayIdEqualTo(day.id).resultIsNotNull().findFirst();
          daysProgress.addAll([
            {'day': day, 'dayResult': dayResult}
          ]);
          // print('dayResult: $dayResult, day: ${day.startAt}');
        }

        weeksData.addAll([
          {'week': week, 'daysProgress': daysProgress, 'weekResultsSave': true}
        ]);
      }
    }
  }

  // print('weeksData: $weeksData');
  return weeksData;
}
