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
  // выполнялось дней
  final completedDays = await isar.days.filter().completedAtIsNotNull().findAll();
  resultData['completedDays'] = completedDays.length;

  // количество выполненных дней в неделю
  for (int i = 0; i < weeks; i++) {
    Week? week = stream.weekBacklink.elementAtOrNull(i);
    // неделя создана
    if (week != null) {
      List completedDays = await week.dayBacklink.filter().completedAtIsNotNull().findAll();
      daysOfWeek.add({
        'weekNumber': i,
        'completedDays': completedDays.length,
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

  resultData['daysOfWeek'] = daysOfWeek;

  return resultData;
}
