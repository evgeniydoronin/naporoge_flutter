import 'package:isar/isar.dart';
import '../../../core/utils/get_actual_week_day.dart';
import '../../planning/domain/entities/stream_entity.dart';

import '../../../core/services/db_client/isar_service.dart';
import '../../../core/utils/get_actual_student_day.dart';
import '../../../core/utils/get_stream_status.dart';

Future getCurrentWeekDaysPoint() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  DateTime actualUserDay = getActualStudentDay();

  // статус курса (before, after, process)
  Map streamStatus = await getStreamStatus();

  // текущая неделя
  // int currentWeekNumber = getWeekNumber(actualUserDay);

  /// всего недель с индексом
  List allWeeksIndexed = stream!.weekBacklink.indexed.toList();

  /// актуальный день студента
  DateTime actualStudentDay = getActualStudentDay();

  /// понедельник текущей недели
  final currMonday = findFirstDateOfTheWeek(actualStudentDay);

  List days = [];

  // До старта курса
  if (streamStatus['status'] == 'before') {
    // Первая неделя курса
    Week week = allWeeksIndexed.first.$2;

    days = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
  }
  // После завершения курса
  else if (streamStatus['status'] == 'after') {
    Week week = allWeeksIndexed.last.$2;

    // print('week: ${week.dayBacklink.first.startAt}');
    if (week.dayBacklink.first.startAt != null) {
      days = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
    } else {
      days = await week.dayBacklink.filter().findAll();
    }
  }
  // Во время прохождения курса
  else if (streamStatus['status'] == 'process') {
    for (int i = 0; i < allWeeksIndexed.length; i++) {
      Week week = allWeeksIndexed[i].$2;

      /// текущая неделя
      if (currMonday.isAtSameMomentAs(week.monday!)) {
        days = await week.dayBacklink.filter().sortByDateAt().thenByDateAt().findAll();
      }
    }
  }

  // print("'days': $days, 'actualUserDay': $actualUserDay");

  return {'days': days, 'actualUserDay': actualUserDay};
}
