import 'package:isar/isar.dart';

part 'stream_entity.g.dart';

@collection
class NPStream {
  Id? id;
  bool? isActive;
  String? courseId;
  int? weeks;
  DateTime? startAt;
  String? title;
  String? description;
  String? targetMinimum;
  String? targetExternalKey;
  String? targetExternalValue;
  String? targetInternalKey;
  String? targetInternalValue;

  @Backlink(to: 'nPStream')
  final weekBacklink = IsarLinks<Week>();
}

@collection
class Week {
  Id? id;
  int? streamId;
  int? weekNumber;
  String? cells;

  final nPStream = IsarLink<NPStream>();

  @Backlink(to: 'week')
  final dayBacklink = IsarLinks<Day>();
}

@collection
class Day {
  Id? id;
  int? weekId;
  DateTime? startAt;
  DateTime? completedAt;

  final week = IsarLink<Week>();

  @Backlink(to: 'day')
  final dayResultBacklink = IsarLinks<DayResult>();
}

@collection
class DayResult {
  Id? id;
  int? dayId;
  int? executionScope;
  String? result;
  String? desires;
  String? reluctance;
  String? interference;
  String? rejoice;

  final day = IsarLink<Day>();
}
