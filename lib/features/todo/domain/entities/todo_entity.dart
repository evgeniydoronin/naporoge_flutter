import 'package:isar/isar.dart';

part 'todo_entity.g.dart';

@collection
class TodoEntity {
  Id? id;
  int? parentId;
  String? title;
  int? category;
  int? order;
  bool? isChecked;
}
