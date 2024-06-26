import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:naporoge/features/planning/data/models/stream_model.dart';
import 'package:naporoge/features/todo/domain/entities/todo_entity.dart';
import '../../../todo/data/models/todo_model.dart';
import '../domain/user_model.dart';
import '../../../diary/domain/entities/diary_note_entity.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../planning/data/repositories/stream_repository.dart';
import '../data/repository/user_repository.dart';
import '../../../../core/services/controllers/service_locator.dart';

class AuthController {
  // --------------- Repository -------------
  final userRepository = getIt.get<UserRepository>();
  final streamRepository = getIt.get<StreamRepository>();

  // -------------- TextField Controller ---------------
  final phoneController = TextEditingController();
  final smsCodeController = TextEditingController();
  final authCodeController = TextEditingController();

  Future getSmsCode(phone) async {
    final newlySmsCode = await userRepository.getSmsConfirmCodeRequested(phone);
    // newUsers.add(newlySmsCode);
    return newlySmsCode;
  }

  Future confirmAuthCode(authCode) async {
    final confirmAuthCode = await userRepository.confirmAuthCodeRequested(authCode);
    return confirmAuthCode;
  }

  Future createStudent(phone, authCode) async {
    final confirmAuthCode = await userRepository.createStudentRequested(phone, authCode);
    return confirmAuthCode;
  }

  Future getStudent(phone) async {
    final student = await userRepository.getStudentRequested(phone);
    return student;
  }

  Future updateUserToken() async {
    await userRepository.updateUserTokenRequested();
  }

  /// Clear local DB
  Future clearLocalDB() async {
    final isarService = IsarService();
    final isar = await isarService.db;

    await isar.writeTxn(() async {
      await isar.users.clear();
      await isar.nPStreams.clear();
      await isar.weeks.clear();
      await isar.days.clear();
      await isar.dayResults.clear();
      await isar.diaryNotes.clear();
      await isar.twoTargets.clear();
      await isar.todoEntitys.clear();
    });
  }

  /// Get DB from server
  Future<Map> getDBFromServer(int userId) async {
    Map data = {};

    final streams = await streamRepository.getNPStreamsRequested(userId);
    final weeks = await streamRepository.getWeeksRequested(streams);
    final days = await streamRepository.getDaysRequested(weeks);
    final daysResults = await streamRepository.getDaysResultsRequested(days);
    final diaryNotes = await streamRepository.getDiaryNotesRequested(userId);
    final twoTargets = await streamRepository.getTwoTargetsRequested(streams);
    final todos = await streamRepository.getTodosRequested(userId);
    // final pushNotification = await streamRepository.getTodosRequested(userId);

    ///
    data['userId'] = userId;
    data['streams'] = streams;
    data['weeks'] = weeks;
    data['days'] = days;
    data['daysResults'] = daysResults;
    data['diaryNotes'] = diaryNotes;
    data['twoTargets'] = twoTargets;
    data['todos'] = todos;

    ///
    return data;
  }

  /// Create DB, remote to local
  Future<void> createLocalDB(Map data) async {
    final isarService = IsarService();
    final isar = await isarService.db;

    /// User
    final user = User()
      ..id = data['userId']
      ..isLoggedIn = true;

    /// Streams
    await insertStreams(data['streams']);

    /// Weeks
    await insertWeeks(data['weeks']);

    /// Days
    await insertDays(data['days']);

    /// Day Results
    await insertDayResults(data['daysResults']);

    /// Diary Notes
    await insertDiaryNotes(data['diaryNotes']);

    /// Two Targets
    if (data['twoTargets'] != null) {
      await insertTwoTargets(data['twoTargets']);
    }

    /// Todos
    await insertTodos(data['todos']);

    await isar.writeTxn(() async {
      /// Add user
      await isar.users.put(user);
    });
  }
}

/// Insert streams
Future insertStreams(data) async {
  final isarService = IsarService();
  final isar = await isarService.db;

  List<NPStreamModel>? streamsData = data;
  List<NPStream> streams = [];
  if (streamsData != null) {
    for (NPStreamModel item in streamsData) {
      final stream = NPStream()
        ..id = item.id
        ..isActive = item.isActive
        ..courseId = item.courseId
        ..weeks = item.weeks
        ..startAt = item.startAt
        ..title = item.title
        ..description = item.description;

      streams.add(stream);
    }
  }

  await isar.writeTxn(() async {
    /// insert streams
    if (streams.isNotEmpty) {
      await isar.nPStreams.putAll(streams);
    }
  });
}

/// Insert weeks
Future insertWeeks(data) async {
  final isarService = IsarService();
  final isar = await isarService.db;

  final weeksData = data;
  List<Week> weeks = [];
  if (weeksData != null) {
    for (int i = 0; i < data.length; i++) {
      final WeekModel weekData = data[i];
      final stream = await isar.nPStreams.get(weekData.streamId!);

      final week = Week()
        ..id = weekData.id
        ..streamId = weekData.streamId
        ..weekNumber = weekData.weekNumber
        ..weekYear = weekData.weekYear
        ..monday = weekData.monday
        ..systemConfirmed = weekData.systemConfirmed
        ..userConfirmed = weekData.userConfirmed
        ..progress = weekData.progress
        ..cells = weekData.cells
        ..nPStream.value = stream;

      weeks.add(week);
    }
  }

  /// Add weeks
  isar.writeTxnSync(() async {
    if (weeks.isNotEmpty) {
      isar.weeks.putAllSync(weeks);
    }
  });
}

/// Insert days
Future insertDays(data) async {
  final isarService = IsarService();
  final isar = await isarService.db;

  final daysData = data;
  List<Day> days = [];
  if (daysData != null) {
    for (int i = 0; i < data.length; i++) {
      final DayModel dayData = data[i];
      final week = await isar.weeks.get(dayData.weekId!);

      final day = Day()
        ..id = dayData.id
        ..weekId = dayData.weekId
        ..dateAt = dayData.dateAt
        ..startAt = dayData.startAt
        ..completedAt = dayData.completedAt
        ..week.value = week;

      days.add(day);
    }
  }

  /// Add days
  isar.writeTxnSync(() async {
    if (days.isNotEmpty) {
      isar.days.putAllSync(days);
    }
  });
}

/// Insert day results
Future insertDayResults(data) async {
  final isarService = IsarService();
  final isar = await isarService.db;

  final dayResultsData = data;
  List<DayResult> daysResults = [];
  if (dayResultsData != null) {
    for (int i = 0; i < dayResultsData.length; i++) {
      final DayResultsModel dayResultData = dayResultsData[i];
      final day = await isar.days.get(dayResultData.dayId!);

      final dayResults = DayResult()
        ..id = dayResultData.id
        ..dayId = dayResultData.dayId
        ..executionScope = dayResultData.executionScope
        ..result = dayResultData.result
        ..desires = dayResultData.desires
        ..reluctance = dayResultData.reluctance
        ..interference = dayResultData.interference
        ..rejoice = dayResultData.rejoice
        ..day.value = day;

      daysResults.add(dayResults);
    }
  }

  /// Add day results
  isar.writeTxnSync(() async {
    if (daysResults.isNotEmpty) {
      isar.dayResults.putAllSync(daysResults);
    }
  });
}

/// Insert diary notes
Future insertDiaryNotes(data) async {
  final isarService = IsarService();
  final isar = await isarService.db;

  List<DiaryNote> diaryNotes = [];
  if (data != null) {
    for (int i = 0; i < data.length; i++) {
      final DiaryNoteModel diaryNoteData = data[i];

      final note = DiaryNote()
        ..id = diaryNoteData.id
        ..createAt = diaryNoteData.createAt
        ..updateAt = diaryNoteData.updateAt
        ..diaryNote = diaryNoteData.diaryNote;

      diaryNotes.add(note);
    }
  }

  /// Add weeks
  isar.writeTxnSync(() async {
    if (diaryNotes.isNotEmpty) {
      isar.diaryNotes.putAllSync(diaryNotes);
    }
  });
}

/// Insert two targets
Future insertTwoTargets(data) async {
  final isarService = IsarService();
  final isar = await isarService.db;

  // print('data 333: $data');
  // print('data 333: ${data.isEmpty}');

  Map? twoTargetData = data.isNotEmpty ? data[0] : null;

  if (twoTargetData != null) {
    final stream = await isar.nPStreams.get(twoTargetData['stream_id']);

    TwoTarget twoTarget = TwoTarget()
      ..id = twoTargetData['id']
      ..streamId = twoTargetData['stream_id']
      ..title = twoTargetData['title']
      ..minimum = twoTargetData['minimum']
      ..targetOneTitle = twoTargetData['target_one_title']
      ..targetOneDescription = twoTargetData['target_one_description']
      ..targetTwoTitle = twoTargetData['target_two_title']
      ..targetTwoDescription = twoTargetData['target_two_description']
      ..nPStream.value = stream;

    /// Add two targets
    isar.writeTxnSync(() async {
      isar.twoTargets.putSync(twoTarget);
    });
  }
}

/// Insert todos
Future insertTodos(data) async {
  final isarService = IsarService();
  final isar = await isarService.db;

  List<TodoModel>? todosData = data;
  List<TodoEntity> todos = [];

  if (todosData != null) {
    for (TodoModel item in todosData) {
      final todo = TodoEntity()
        ..id = item.id
        ..parentId = item.parentId
        ..title = item.title
        ..category = item.category
        ..order = item.order
        ..isChecked = item.isChecked!;

      todos.add(todo);
    }
  }

  await isar.writeTxn(() async {
    /// insert todos
    if (todos.isNotEmpty) {
      await isar.todoEntitys.putAll(todos);
    }
  });
}
