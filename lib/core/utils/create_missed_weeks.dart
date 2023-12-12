import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../features/planning/domain/entities/stream_entity.dart';

import '../../features/planning/data/sources/local/stream_local_storage.dart';
import '../../features/planning/presentation/stream_controller.dart';
import '../services/controllers/service_locator.dart';
import '../services/db_client/isar_service.dart';
import 'get_actual_week_day.dart';
import 'get_week_number.dart';

Future createMissedWeeks() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final streamController = getIt<StreamController>();
  final streamLocalStorage = StreamLocalStorage();
  final NPStream? activeStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
  DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0, 0);

  /// определить сколько недель прошло
  /// максимальное количество пропущенных недель
  int mayBeMissed = 9;
  int missedWeeks = 0;
  bool isFirstWeek = false;

  /// найти последнюю созданную неделю
  Week? lastCreatedWeek = activeStream?.weekBacklink.lastOrNull;

  /// первая неделя курса не создавалась
  if (lastCreatedWeek == null) {
    missedWeeks = 1;
    isFirstWeek = true;
  }

  /// понедельник последней недели
  /// если недели не создавались
  /// берем понедельник из курса
  final lastMonday = lastCreatedWeek != null ? lastCreatedWeek.monday : activeStream!.startAt;

  /// определить понедельник текущей
  DateTime mondayOfTheWeek = findFirstDateOfTheWeek(now);

  for (int i = 0; i < mayBeMissed; i++) {
    int humanIndex = i + 1;
    DateTime nextMonday = lastMonday!.add(Duration(days: 7 * humanIndex));
    if (nextMonday.isAtSameMomentAs(mondayOfTheWeek)) {
      missedWeeks = humanIndex;
    }
  }

  /// количество созданных недель не больше значения по умолчанию
  /// не создаем недели после завершения курса
  if (activeStream!.weekBacklink.length < activeStream.weeks!) {
    /// если есть пропущенные недели
    /// создаем их
    if (missedWeeks > 0) {
      for (int i = 0; i < missedWeeks; i++) {
        int humanIndex = i + 1;
        DateTime? monday = isFirstWeek ? lastMonday : lastMonday!.add(Duration(days: 7 * humanIndex));
        int currentWeekNumber = getWeekNumber(monday);
        Map newWeekData = {
          'streamId': activeStream.id,
          'cells': [],
          'monday': DateFormat('y-MM-dd').format(monday!),
          'weekOfYear': currentWeekNumber,
          'year': monday.year,
        };

        // print('newWeekData - $i : $newWeekData');
        /// create on server
        var createWeek = await streamController.createWeek(newWeekData);

        /// create on local
        await streamLocalStorage.createWeek(createWeek);
      }
    }
  }
}
