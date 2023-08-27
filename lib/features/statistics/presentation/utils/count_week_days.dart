import 'package:isar/isar.dart';

import '../../../../core/services/db_client/isar_service.dart';
import '../../../planning/domain/entities/stream_entity.dart';

Future countWeekDays() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final NPStream? stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  int weeks = stream!.weeks!;

  Map resultData = {};
  List daysOfWeek = [];

  // запланировано дней
  int plannedDays = stream.weeks! * 6;
  resultData['plannedDays'] = plannedDays;
  // выполнялось дней на текущий момент
  List completedCurrentDays = [];

  // количество выполненных дней в неделю
  for (int i = 0; i < weeks; i++) {
    Week? week = stream.weekBacklink.elementAtOrNull(i);
    // неделя создана
    if (week != null) {
      final completedDays = await week.dayBacklink.filter().completedAtIsNotNull().findAll();

      // выполнялось дней по параметру executionScope
      List dayResults = [];
      for (Day day in completedDays) {
        final res = await day.dayResultBacklink.filter().executionScopeGreaterThan(0).findFirst();
        if (res != null) {
          dayResults.add(res);
          completedCurrentDays.add(1);
        }
      }
      
      daysOfWeek.add({
        'weekNumber': i,
        'completedDays': dayResults.length,
      });
    }
    // неделя НЕ создана
    else {
      daysOfWeek.add({
        'weekNumber': i,
        'completedDays': 0,
      });
    }
  }

  resultData['completedDays'] = completedCurrentDays.length;
  resultData['daysOfWeek'] = daysOfWeek;

  return resultData;
}
