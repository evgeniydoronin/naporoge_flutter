import 'dart:convert';

import 'package:isar/isar.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../domain/entities/stream_entity.dart';

class StreamLocalStorage {
  final isarService = IsarService();

  Future<void> saveStream(Map streamDataFromServer) async {
    final isar = await isarService.db;

    Map streamData = streamDataFromServer['stream'];
    Map weekData = streamDataFromServer['week'];

    final newStream = NPStream()
      ..id = streamData['id']
      ..courseId = streamData['course_id']
      ..isActive = streamData['is_active']
      ..title = streamData['title']
      ..weeks = streamData['weeks']
      ..description = streamData['description']
      ..startAt = DateTime.parse(streamData['start_at']);

    final newWeek = Week()
      ..id = weekData['id']
      ..weekNumber = weekData['number']
      ..streamId = weekData['stream_id']
      ..cells = json.encode(weekData['cells'])
      ..nPStream.value = newStream;

    isar.writeTxnSync(() async {
      isar.nPStreams.putSync(newStream);
      isar.weeks.putSync(newWeek);

      for (Map dayData in streamDataFromServer['days']) {
        final newDay = Day()
          ..id = dayData['day']['id']
          ..weekId = dayData['day']['week_id']
          ..startAt = DateTime.parse(dayData['day']['start_at'])
          ..week.value = newWeek;
        isar.days.putSync(newDay);
      }
    });
  }

  Future<void> updateStream(Map streamDataFromServer) async {
    final isar = await isarService.db;

    Map streamData = streamDataFromServer['stream'];
    Map weekData = streamDataFromServer['week'];

    final stream = await isar.nPStreams.get(streamData['id']);
    stream!.description = streamData['description'];

    final week = await isar.weeks.get(weekData['id']);
    week!.cells = json.encode(weekData['cells']);

    isar.writeTxnSync(() {
      // update stream
      isar.nPStreams.putSync(stream);

      // update week
      isar.weeks.putSync(week);

      // update days
      for (Map dayData in streamDataFromServer['updatedDays']) {
        final newDay = isar.days.getSync(dayData['id']);
        newDay!.startAt = DateTime.parse(dayData['start_at']);
        isar.days.putSync(newDay);
      }
    });

    // final newStream = NPStream()
    //   ..id = streamData['id']
    //   ..courseId = streamData['course_id']
    //   ..isActive = streamData['is_active']
    //   ..title = streamData['title']
    //   ..weeks = streamData['weeks']
    //   ..description = streamData['description']
    //   ..startAt = DateTime.parse(streamData['start_at']);
    //
    // final newWeek = Week()
    //   ..id = weekData['id']
    //   ..weekNumber = weekData['number']
    //   ..streamId = weekData['stream_id']
    //   ..cells = json.encode(weekData['cells'])
    //   ..nPStream.value = newStream;
    //
    // isar.writeTxnSync(() async {
    //   isar.nPStreams.putSync(newStream);
    //   isar.weeks.putSync(newWeek);
    //
    //   for (Map dayData in streamDataFromServer['days']) {
    //     final newDay = Day()
    //       ..id = dayData['day']['id']
    //       ..weekId = dayData['day']['week_id']
    //       ..startAt = DateTime.parse(dayData['day']['start_at'])
    //       ..week.value = newWeek;
    //     isar.days.putSync(newDay);
    //   }
    // });
  }

  Future<List<NPStream>> getAllStreams() async {
    final isar = await isarService.db;

    var streams = await isar.nPStreams.where().findAll();
    return streams; // get
  }

  Future getActiveStream() async {
    final isar = await isarService.db;

    final activeStream =
        await isar.nPStreams.filter().isActiveEqualTo(true).findAll();

    return activeStream.first; // get
  }

  Future saveDayResult(Map data) async {
    final isar = await isarService.db;

    final day = await isar.days.get(data['day']['id']);

    // print('day: $day');

    final dayResult = DayResult()
      ..id = data['day_result']['id']
      ..dayId = data['day_result']['day_id']
      ..executionScope = data['day_result']['execution_scope']
      ..result = data['day_result']['result']
      ..desires = data['day_result']['desires']
      ..reluctance = data['day_result']['reluctance']
      ..interference = data['day_result']['interference']
      ..rejoice = data['day_result']['rejoice']
      ..day.value = day;

    day!.completedAt = DateTime.parse(data['day']['completed_at']);

    await isar.writeTxn(() async {
      await isar.dayResults.put(dayResult);
      await isar.days.put(day);
      await dayResult.day.save();
    });
  }
}
