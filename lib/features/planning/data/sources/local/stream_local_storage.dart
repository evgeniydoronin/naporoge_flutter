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
    Map weekData = streamDataFromServer['week'];

    final stream = await isar.nPStreams.get(streamData['id']);
    stream!.title = streamData['title'];
    stream.description = streamData['description'];
    stream.courseId = streamData['course_id'];

    final week = await isar.weeks.get(weekData['id']);
    week!.cells = json.encode(weekData['cells']);
    week.userConfirmed = true;

    isar.writeTxnSync(() {
      // update stream
      isar.nPStreams.putSync(stream);

      // update week
      isar.weeks.putSync(week);

      // update days
      for (Map dayData in streamDataFromServer['days']) {
        final newDay = Day()
          ..id = dayData['day']['id']
          ..weekId = dayData['day']['week_id']
          ..startAt = DateTime.parse(dayData['day']['start_at'])
          ..week.value = week;
        isar.days.putSync(newDay);
      }
      // for (Map dayData in streamDataFromServer['updatedDays']) {
      //   final newDay = isar.days.getSync(dayData['id']);
      //   newDay!.startAt = DateTime.parse(dayData['start_at']);
      //   isar.days.putSync(newDay);
      // }
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
          ..startAt = dayData['day']['start_at'] != null ? DateTime.parse(dayData['day']['start_at']) : null
          ..week.value = newWeek;
        isar.days.putSync(newDay);
      }
    });
    // final week = await isar.weeks.get(weekDataFromServer['week']['id']);
    // {"cells":"[{\"dayId\":949,\"cellId\":[2,0,5]},{\"dayId\":950,\"cellId\":[1,6,4]},{\"dayId\":951,\"cellId\":[1,4,2]},{\"dayId\":952,\"cellId\":[0,0,0]},{\"dayId\":953,\"cellId\":[1,5,3]},{\"dayId\":954,\"cellId\":[1,3,1]},{\"dayId\":955,\"cellId\":[0,0,6]}]","id":215,"streamId":239,"weekNumber":31}
    // week!.cells = jsonEncode(weekDataFromServer['newCells']);
    // TODO: решить вопрос с кто подтверждает неделю
    // TODO: user_confirmed или system_confirmed
    // print('weekDataFromServer:: $weekDataFromServer');
    // print('day 949:: ${week.dayBacklink.where((day) => day.id == 949)}');

    // isar.writeTxnSync(() {
    //   // update week
    //   isar.weeks.putSync(week);
    //   // update days
    //   for (Map dayData in weekDataFromServer['days']) {
    //     final day = isar.days.getSync(dayData['day']['id']);
    //     day!.startAt = DateTime.parse(dayData['day']['start_at']);
    //
    //     isar.days.putSync(day);
    //   }
    // });
  }

  Future<void> updateWeek(Map weekDataFromServer) async {
    final isar = await isarService.db;
    final week = await isar.weeks.get(weekDataFromServer['week']['id']);
    // {"cells":"[{\"dayId\":949,\"cellId\":[2,0,5]},{\"dayId\":950,\"cellId\":[1,6,4]},{\"dayId\":951,\"cellId\":[1,4,2]},{\"dayId\":952,\"cellId\":[0,0,0]},{\"dayId\":953,\"cellId\":[1,5,3]},{\"dayId\":954,\"cellId\":[1,3,1]},{\"dayId\":955,\"cellId\":[0,0,6]}]","id":215,"streamId":239,"weekNumber":31}
    week!.cells = jsonEncode(weekDataFromServer['newCells']);
    // TODO: решить вопрос с кто подтверждает неделю
    // TODO: user_confirmed или system_confirmed
    // print('weekDataFromServer:: $weekDataFromServer');
    // print('day 949:: ${week.dayBacklink.where((day) => day.id == 949)}');

    isar.writeTxnSync(() {
      // update week
      isar.weeks.putSync(week);
      // update days
      for (Map dayData in weekDataFromServer['days']) {
        final day = isar.days.getSync(dayData['day']['id']);
        day!.startAt = DateTime.parse(dayData['day']['start_at']);

        isar.days.putSync(day);
      }
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

    day!.completedAt = DateTime.parse(data['day']['completed_at']);

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
