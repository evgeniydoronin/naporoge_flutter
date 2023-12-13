import 'dart:convert';
import 'dart:ffi';

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

  Future<void> deleteStream(Map streamDataFromServer) async {
    final isar = await isarService.db;

    Map streamData = streamDataFromServer['stream'];

    int streamId = streamData['id'];

    // стрим
    NPStream? stream = await isar.nPStreams.get(streamId);

    // недели
    List<Week> weeks = await isar.weeks.filter().streamIdEqualTo(streamId).findAll();
    List<int> weekIds = [];
    if (weeks.isNotEmpty) {
      weekIds.addAll(weeks.map((e) => e.id!));
    }

    // дни
    // Instance of 'Day'
    List<int> daysIds = [];
    if (weeks.isNotEmpty) {
      List<Day> days = await isar.days.filter().anyOf(weeks, (day, week) => day.weekIdEqualTo(week.id)).findAll();
      if (days.isNotEmpty) {
        daysIds.addAll(days.map((e) => e.id!));
      }
    }

    // результаты дней
    // Instance of 'DayResult'
    List<int> dayResultsIds = [];
    if (daysIds.isNotEmpty) {
      List<Day> daysIncludeResults = await isar.days
          .filter()
          .anyOf(daysIds, (day, dayId) => day.idEqualTo(dayId))
          .and()
          .completedAtIsNotNull()
          .findAll();

      if (daysIncludeResults.isNotEmpty) {
        List<DayResult> dayResults = await isar.dayResults
            .filter()
            .anyOf(daysIncludeResults, (dayResult, day) => dayResult.dayIdEqualTo(day.id))
            .findAll();

        if (dayResults.isNotEmpty) {
          dayResultsIds.addAll(dayResults.map((e) => e.id!));
        }
      }
    }

    // print('stream!.id : ${stream!.id}');
    // print('weekIds: $weekIds');
    // print('daysIds: $daysIds');
    // print('dayResultsIds: $dayResultsIds');

    // удаление
    await isar.writeTxn(() async {
      await isar.nPStreams.delete(stream!.id!);
      await isar.weeks.deleteAll(weekIds);
      await isar.days.deleteAll(daysIds);
      await isar.dayResults.deleteAll(dayResultsIds);
    });
  }

  Future<void> deactivateStream(Map streamDataFromServer) async {
    final isar = await isarService.db;

    Map streamData = streamDataFromServer['stream'];
    int streamId = streamData['id'];

    await isar.writeTxn(() async {
      final stream = await isar.nPStreams.get(streamId);
      stream!.isActive = false;
      await isar.nPStreams.put(stream);
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
    if (streamData['weeks'] != null) {
      stream!.weeks = streamData['weeks'];
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

    int year;
    if (weekDataFromServer['week']['year'] is String) {
      year = int.parse(weekDataFromServer['week']['year']);
    } else {
      year = weekDataFromServer['week']['year'];
    }

    // получить stream
    // создать неделю
    final newWeek = Week()
      ..id = weekDataFromServer['week']['id']
      ..weekNumber = weekDataFromServer['week']['number']
      ..weekYear = year
      ..monday = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(weekDataFromServer['week']['monday'])))
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
          ..dateAt = dayData['day']['date_at'] != null
              ? DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(dayData['day']['date_at'])))
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

  Future createTwoTargets(Map serverResponse) async {
    final isar = await isarService.db;
    final data = serverResponse['twoTargets'];
    final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

    final twoTargets = TwoTarget()
      ..id = data['id']
      ..title = data['title']
      ..minimum = data['minimum']
      ..targetOneTitle = data['target_one_title']
      ..targetOneDescription = data['target_one_description']
      ..targetTwoTitle = data['target_two_title']
      ..targetTwoDescription = data['target_two_description']
      ..nPStream.value = stream;

    isar.writeTxnSync(() async {
      isar.twoTargets.putSync(twoTargets);
    });

    return twoTargets;
  }

  Future updateTwoTargets(Map serverResponse) async {
    final isar = await isarService.db;
    final data = serverResponse['twoTargets'];

    final twoTargets = await isar.twoTargets.get(data['id']);

    twoTargets!.title = data['title'];
    twoTargets.minimum = data['minimum'];
    twoTargets.targetOneTitle = data['target_one_title'];
    twoTargets.targetOneDescription = data['target_one_description'];
    twoTargets.targetTwoTitle = data['target_two_title'];
    twoTargets.targetTwoDescription = data['target_two_description'];

    isar.writeTxnSync(() async {
      isar.twoTargets.putSync(twoTargets!);
    });

    return twoTargets;
  }
}
