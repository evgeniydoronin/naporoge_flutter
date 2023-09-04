import 'package:isar/isar.dart';

import '../../../../core/services/db_client/isar_service.dart';
import '../../../planning/domain/entities/stream_entity.dart';

Future getDiaryDayResults(date) async {
  await Future.delayed(const Duration(milliseconds: 200));
  Map? data = {};
  DayResult? dayResult;

  DateTime currentDate = date;
  DateTime lower = DateTime(currentDate.year, currentDate.month, currentDate.day, 0);
  DateTime upper = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);

  final isarService = IsarService();
  final isar = await isarService.db;

  final day = await isar.days.filter().completedAtIsNotNull().completedAtBetween(lower, upper).findFirst();

  if (day != null) {
    dayResult = await isar.dayResults.filter().dayIdEqualTo(day.id).findFirst();

    data = {
      'dayResult': dayResult,
      'completedAt': day.completedAt,
    };
  }

  return data.isNotEmpty ? data : null;
}
