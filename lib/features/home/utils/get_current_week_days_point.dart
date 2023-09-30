import 'package:isar/isar.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';

import '../../../core/services/db_client/isar_service.dart';
import '../../../core/utils/get_actual_student_day.dart';
import '../../../core/utils/get_stream_status.dart';
import '../../../core/utils/get_week_number.dart';

Future getCurrentWeekDaysPoint() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  DateTime actualUserDay = getActualStudentDay();

  // статус курса (before, after, process)
  Map streamStatus = await getStreamStatus();

  // текущая неделя
  int currentWeekNumber = getWeekNumber(actualUserDay);

  List days = [];

  // До старта курса
  if (streamStatus['status'] == 'before') {
    // Первая неделя курса
    Week week = stream!.weekBacklink.first;

    days = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
  }
  // После завершения курса
  else if (streamStatus['status'] == 'after') {
    Week week = stream!.weekBacklink.last;

    // print('week: ${week.dayBacklink.first.startAt}');
    if (week.dayBacklink.first.startAt != null) {
      days = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
    } else {
      days = await week.dayBacklink.filter().findAll();
    }
  }
  // Во время прохождения курса
  else if (streamStatus['status'] == 'process') {
    // недели не созданы
    // первая неделя пустая
    if (stream!.weekBacklink.isEmpty) {
      days = [];
    }
    // первая неделя на курсе создана
    else {
      Week week = stream.weekBacklink.where((week) => week.weekNumber == currentWeekNumber).first;
      // неделя не пустая
      if (week.dayBacklink.first.startAt != null) {
        days = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
      }
      // пустая неделя
      else {
        days = await week.dayBacklink.filter().findAll();
      }
    }
  }

  return {'days': days, 'actualUserDay': actualUserDay};
}
