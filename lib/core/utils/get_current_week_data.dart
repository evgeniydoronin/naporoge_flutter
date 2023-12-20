import 'package:isar/isar.dart';
import '../../features/planning/domain/entities/stream_entity.dart';
import '../services/db_client/isar_service.dart';
import 'get_actual_student_day.dart';
import 'get_actual_week_day.dart';

/// Get current week data
///
/// return: Map {week: Instance of 'Week', isLast: false, isEmpty: false}
Future<Map> getCurrentWeekData() async {
  Map currentWeekData = {};

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

  currentWeekData['week'] = currentWeek;
  currentWeekData['weekIndex'] = weekIndex;
  currentWeekData['isLast'] = isLast;
  currentWeekData['isEmpty'] = isEmpty;
  currentWeekData['weeks'] = stream.weeks;
  currentWeekData['weeksIds'] = weekIds;

  // print('currentWeekData: $currentWeekData');

  return currentWeekData;
}
