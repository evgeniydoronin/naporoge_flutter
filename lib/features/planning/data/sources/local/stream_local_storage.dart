import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../../../../core/services/db_client/isar_service.dart';
import '../../../../diary/domain/entities/diary_note_entity.dart';
import '../../../domain/entities/stream_entity.dart';

class StreamLocalStorage {
  final isarService = IsarService();

  Future<void> createStream(Map streamDataFromServer) async {
    final isar = await isarService.db;

    Map streamData = streamDataFromServer['stream'];

    // деактивируем предыдущий курс, если есть
    NPStream? previousStream;
    int? previousStreamId = streamDataFromServer['old_stream'];
    if (previousStreamId != null) {
      previousStream = await isar.nPStreams.get(previousStreamId);
      previousStream?.isActive = false;
    }

    final newStream = NPStream()
      ..id = streamData['id']
      ..courseId = streamData['course_id']
      ..isActive = streamData['is_active']
      ..title = streamData['title']
      ..weeks = streamData['weeks']
      ..description = streamData['description']
      ..startAt = DateTime.parse(streamData['start_at']);

    isar.writeTxnSync(() async {
      // деактивируем предыдущий курс
      if (previousStream != null) {
        isar.nPStreams.putSync(previousStream);
      }
      isar.nPStreams.putSync(newStream);
    });
  }

  Future<void> createNextStream(Map streamDataFromServer) async {
    final isar = await isarService.db;

    Map streamData = streamDataFromServer['stream'];
    int oldStreamId = streamDataFromServer['old_stream'];

    // деактивируем старый курс
    final oldStream = await isar.nPStreams.get(oldStreamId);
    oldStream!.isActive = false;

    final newStream = NPStream()
      ..id = streamData['id']
      ..courseId = streamData['course_id']
      ..isActive = streamData['is_active']
      ..title = streamData['title']
      ..weeks = streamData['weeks']
      ..description = streamData['description']
      ..startAt = DateTime.parse(streamData['start_at']);

    isar.writeTxnSync(() async {
      // деактивируем старый курс
      isar.nPStreams.putSync(oldStream);
      // создаем новый курс
      isar.nPStreams.putSync(newStream);
    });
  }

  Future<void> updateStream(Map streamDataFromServer) async {
    final isar = await isarService.db;

    Map streamData = streamDataFromServer['stream'];
    // Map weekData = streamDataFromServer['week'];

    // print('streamDataFromServer: $streamDataFromServer');

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

  Future createDiaryNote(Map data) async {
    final isar = await isarService.db;

    final diaryNote = DiaryNote()
      ..id = data['note']['id']
      ..createAt = DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(data['note']['created_at'])))
      ..updateAt = DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(data['note']['updated_at'])))
      ..diaryNote = data['note']['note'];

    isar.writeTxnSync(() async {
      isar.diaryNotes.putSync(diaryNote);
    });

    return diaryNote;
  }

  Future updateDiaryNote(Map data) async {
    final isar = await isarService.db;
    final note = await isar.diaryNotes.get(data['note']['id']);

    note!.diaryNote = data['note']['note'];

    isar.writeTxnSync(() async {
      isar.diaryNotes.putSync(note);
    });

    return note;
  }

  Future deleteDiaryNote(Map data) async {
    final isar = await isarService.db;

    await isar.writeTxn(() async {
      final success = await isar.diaryNotes.delete(data['note_id']);
      print('Recipe deleted: $success');
    });
  }

  Future deleteDuplicatesResult(Map data) async {
    final isar = await isarService.db;
    List _weeks = data['weeksIdForDelete'];
    List _days = data['daysIdForDelete'];

    await isar.writeTxn(() async {
      final weeks = await isar.weeks.deleteAll(_weeks.cast<int>());
      final days = await isar.days.deleteAll(_days.cast<int>());
      print('We deleted $weeks weeks');
      print('We deleted $days days');
    });
  }
}
