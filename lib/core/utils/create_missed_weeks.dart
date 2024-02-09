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

  /// недель на курсе
  final int weeks = activeStream!.weeks!;

  /// понедельник старта курса
  DateTime streamStartAt = activeStream.startAt!;

  /// понедельник последней недели курса
  DateTime streamEndAt = streamStartAt.add(Duration(days: weeks * 7));

  /// создано недель на курсе
  List<Week> createdWeeks = await isar.weeks.filter().streamIdEqualTo(activeStream.id).findAll();

  /// определить сколько недель прошло
  /// максимальное количество пропущенных недель
  int mayBeMissed = weeks - createdWeeks.length;
  int missedWeeks = 0;

  // /// первая созданная неделя
  // Week? firstCreatedWeek = activeStream.weekBacklink.firstOrNull;
  //
  // /// последняя созданная неделя
  // Week? lastCreatedWeek = activeStream.weekBacklink.lastOrNull;

  /// понедельник последней созданной недели
  /// если недели не создавались
  /// берем понедельник из курса
  DateTime? neededMonday;

  /// понедельник текущей недели
  DateTime mondayOfTheWeek = findFirstDateOfTheWeek(now);

  /// недели не создавались
  if (createdWeeks.isEmpty) {
    // print('недели не создавались');

    /// понедельник с которого требуется создать недели
    neededMonday = streamStartAt;

    /// если после завершения курса
    /// меняем текущий понедельник на последний понедельник недели курса
    if (now.isAfter(streamEndAt) || now.isAtSameMomentAs(streamEndAt)) {
      mondayOfTheWeek = streamEndAt.subtract(const Duration(days: 7));
    }

    /// разница понедельника текущей недели
    /// и понедельник для создания в неделях
    missedWeeks = ((mondayOfTheWeek.difference(streamStartAt).inDays + 1) / 7).ceil();
  }

  /// недели создавались
  else {
    // print('недели создавались');
    DateTime lastCreatedWeekMonday = createdWeeks.last.monday!;

    /// пропускаем создание на текущей созданной неделе
    if (lastCreatedWeekMonday.isAtSameMomentAs(mondayOfTheWeek)) {
      return;
    }

    /// создаем новые недели если текущая пустая
    else {
      // print('создаем новые недели если текущая пустая');

      /// после завершения курса
      if (mondayOfTheWeek.isAfter(streamEndAt) || mondayOfTheWeek.isAtSameMomentAs(streamEndAt)) {
        // print('после завершения курса');

        /// понедельник с которого требуется создать недели
        neededMonday = lastCreatedWeekMonday.add(const Duration(days: 7));

        missedWeeks = mayBeMissed;
      }

      /// до завершения курса
      else {
        /// понедельник с которого требуется создать недели
        neededMonday = lastCreatedWeekMonday.add(const Duration(days: 7));

        /// разница понедельника текущей недели
        /// и понедельник для создания в неделях
        missedWeeks = ((mondayOfTheWeek.difference(lastCreatedWeekMonday).inDays) / 7).ceil();
      }
    }
  }

  // print('missedWeeks: $missedWeeks');

  /// количество созданных недель не больше значения по умолчанию
  /// не создаем недели после завершения курса
  if (activeStream.weekBacklink.length < activeStream.weeks!) {
    /// если есть пропущенные недели
    /// создаем их

    if (missedWeeks > 0) {
      for (int i = 0; i < missedWeeks; i++) {
        // int humanIndex = i + 1;
        DateTime? monday = neededMonday!.add(Duration(days: 7 * i));
        int currentWeekNumber = getWeekNumber(monday);

        Map newWeekData = {
          'streamId': activeStream.id,
          'cells': [],
          'monday': DateFormat('y-MM-dd').format(monday),
          'weekOfYear': currentWeekNumber,
          'year': monday.year,
        };

        // print('newWeekData: $newWeekData');

        /// create on server
        var createWeek = await streamController.createWeek(newWeekData);

        /// create on local
        await streamLocalStorage.createWeek(createWeek);
      }
    }
  }
}
