import 'package:isar/isar.dart';

part 'diary_note_entity.g.dart';

@collection
class DiaryNote {
  Id? id;
  DateTime? createAt;
  DateTime? updateAt;
  String? diaryNote;
}
