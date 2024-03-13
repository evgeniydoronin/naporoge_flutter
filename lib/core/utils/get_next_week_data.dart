import 'package:isar/isar.dart';
import '../../features/planning/domain/entities/stream_entity.dart';
import '../services/db_client/isar_service.dart';
import 'get_actual_student_day.dart';
import 'get_actual_week_day.dart';

Future<Map> getNextWeekData() async {
  Map nextWeekData = {};

  final isarService = IsarService();
  final isar = await isarService.db;
  final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  /// всего недель с индексом
  final List allWeeksIndexed = stream!.weekBacklink.indexed.toList();

  /// актуальный день студента
  final DateTime actualStudentDay = getActualStudentDay();

  /// понедельник текущей недели
  final currentMonday = findFirstDateOfTheWeek(actualStudentDay);

  /// текущая неделя
  late Week currentWeek;

  /// индекс текущей недели
  late int weekIndex;

  /// последняя неделя
  bool isLast = false;

  /// пустая неделя
  bool isEmpty = true;

  /// ID список недель
  List weekIds = stream.weekBacklink.map((week) => week.id).toList();

  for (int i = 0; i < allWeeksIndexed.length; i++) {
    Week week = allWeeksIndexed[i].$2;
    // print('week: ${week.monday}');

    if (currentMonday.isAtSameMomentAs(week.monday!)) {
      weekIndex = allWeeksIndexed[i].$1;
      isEmpty = week.dayBacklink.first.startAt != null ? false : true;
      currentWeek = week;

      /// последняя неделя
      if (i + 1 == stream.weeks) {
        isLast = true;
      }
    }
  }

  bool isExistNextWeek = true;

  /// if not last week
  if (!isLast) {
    /// не создана следующая неделя
    if (weekIndex + 1 == allWeeksIndexed.length) {
      isExistNextWeek = false;
    }
  }

  nextWeekData['week'] = currentWeek;
  nextWeekData['weekIndex'] = weekIndex;
  nextWeekData['isLast'] = isLast;
  nextWeekData['isEmpty'] = isEmpty;
  nextWeekData['weeks'] = stream.weeks;
  nextWeekData['weeksIds'] = weekIds;
  nextWeekData['isExistNextWeek'] = isExistNextWeek;

  // print('nextWeekData: nextWeekData');

  return nextWeekData;
}
