import 'package:isar/isar.dart';
import '../../../../core/utils/get_stream_status.dart';
import '../../../../core/utils/get_week_number.dart';
import '../../../planning/domain/entities/stream_entity.dart';

import '../../../../core/services/db_client/isar_service.dart';

Future getWeeksProcess() async {
  Map streamStatus = await getStreamStatus();
  final isarService = IsarService();
  final isar = await isarService.db;
  final NPStream? stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  int currentWeekNumber = getWeekNumber(DateTime.now());

  List weeksData = [];

  // // До старта курса
  // if (streamStatus['status'] == 'before') {
  //   weeksData.addAll([
  //     {'week': stream?.weekBacklink.first, 'daysProgress': []}
  //   ]);
  // }

  // текущая неделя и все предыдущие
  for (Week week in stream!.weekBacklink) {
    // будущая неделя
    // если открывается экран Статистики до старта курса
    if (streamStatus['status'] == 'before') {
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
        {'week': week, 'daysProgress': daysProgress, 'weekResultsSave': false}
      ]);
    }
    // прошедшие недели
    else {
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

  return weeksData;
}
