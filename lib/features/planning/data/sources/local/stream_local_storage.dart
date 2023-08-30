import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../domain/entities/stream_entity.dart';

class StreamLocalStorage {
  final isarService = IsarService();

  Future<void> createStream(Map streamDataFromServer) async {
    final isar = await isarService.db;

    Map streamData = streamDataFromServer['stream'];
    // Map weekData = streamDataFromServer['week'];

    final newStream = NPStream()
      ..id = streamData['id']
      ..courseId = streamData['course_id']
      ..isActive = streamData['is_active']
      ..title = streamData['title']
      ..weeks = streamData['weeks']
      ..description = streamData['description']
      ..startAt = DateTime.parse(streamData['start_at']);

    // final newWeek = Week()
    //   ..id = weekData['id']
    //   ..weekNumber = weekData['number']
    //   ..streamId = weekData['stream_id']
    //   ..cells = json.encode(weekData['cells'])
    //   ..nPStream.value = newStream;

    isar.writeTxnSync(() async {
      isar.nPStreams.putSync(newStream);
      // isar.weeks.putSync(newWeek);

      // for (Map dayData in streamDataFromServer['days']) {
      //   final newDay = Day()
      //     ..id = dayData['day']['id']
      //     ..weekId = dayData['day']['week_id']
      //     ..startAt = DateTime.parse(dayData['day']['start_at'])
      //     ..week.value = newWeek;
      //   isar.days.putSync(newDay);
      // }
    });
  }

  Future<void> updateStream(Map streamDataFromServer) async {
    final isar = await isarService.db;

    Map streamData = streamDataFromServer['stream'];
    // Map weekData = streamDataFromServer['week'];

    print('streamDataFromServer: $streamDataFromServer');

    NPStream? stream = await isar.nPStreams.get(streamData['id']);

    if (streamData['start_at'] != null) {
      stream!.startAt = DateTime.parse(streamData['start_at']);
    }
    if (streamData['title'] != null) {
      stream!.title = streamData['title'];
    }
    if (streamData['description'] != null) {
      stream!.description = streamData['description'];
    }
    if (streamData['course_id'] != null) {
      stream!.courseId = streamData['course_id'];
    }

    // update stream
    isar.writeTxnSync(() {
      isar.nPStreams.putSync(stream!);
    });
  }

  Future<void> createWeek(Map weekDataFromServer) async {
    final isar = await isarService.db;
    final stream = await isar.nPStreams.get(weekDataFromServer['week']['stream_id']);

    // получить stream
    // создать неделю
    final newWeek = Week()
      ..id = weekDataFromServer['week']['id']
      ..weekNumber = weekDataFromServer['week']['number']
      ..streamId = weekDataFromServer['week']['stream_id']
      ..userConfirmed = weekDataFromServer['week']['user_confirmed']
      ..systemConfirmed = weekDataFromServer['week']['system_confirmed']
      ..cells = json.encode(weekDataFromServer['week']['cells'])
      ..nPStream.value = stream;

    isar.writeTxnSync(() async {
      isar.weeks.putSync(newWeek);

      for (Map dayData in weekDataFromServer['days']) {
        final newDay = Day()
          ..id = dayData['day']['id']
          ..weekId = dayData['day']['week_id']
          ..startAt = dayData['day']['start_at'] != null
              ? DateTime.parse(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(dayData['day']['start_at'])))
              : null
          ..week.value = newWeek;
        isar.days.putSync(newDay);
      }
    });
  }

  Future<void> updateWeek(Map weekDataFromServer) async {
    final isar = await isarService.db;
    final week = await isar.weeks.get(weekDataFromServer['week']['id']);

    week!.cells = jsonEncode(weekDataFromServer['newCells']);

    isar.writeTxnSync(() {
      // update week
      isar.weeks.putSync(week);
      // update days
      for (Map dayData in weekDataFromServer['days']) {
        final day = isar.days.getSync(dayData['day']['id']);
        // приводим к нужному формату время сервера
        day!.startAt =
            DateTime.parse(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(dayData['day']['start_at'])));

        isar.days.putSync(day);
      }
    });
  }

  Future<void> updateWeekProgress(Map weekDataFromServer) async {
    final isar = await isarService.db;
    final week = await isar.weeks.get(weekDataFromServer['week']['id']);

    week!.progress = weekDataFromServer['week']['progress'];

    // update week
    isar.writeTxnSync(() {
      isar.weeks.putSync(week);
    });
  }

  Future<List<NPStream>> getAllStreams() async {
    final isar = await isarService.db;

    var streams = await isar.nPStreams.where().findAll();
    return streams; // get
  }

  Future getActiveStream() async {
    final isar = await isarService.db;

    final activeStream = await isar.nPStreams.filter().isActiveEqualTo(true).findAll();

    return activeStream.isNotEmpty ? activeStream.first : null; // get
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

    day!.completedAt =
        DateTime.parse(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(data['day']['completed_at'])));

    await isar.writeTxn(() async {
      await isar.dayResults.put(dayResult);
      await isar.days.put(day);
      await dayResult.day.save();
    });
  }

  Future getDayById(dayId) async {
    final isar = await isarService.db;
    final day = await isar.days.get(dayId);

    return day;
  }
}
