import 'package:isar/isar.dart';

part 'todo_entity.g.dart';

@collection
class Todo {
  Id? id;
  int? userId;
  int? parentId;
  String? title;
  int? category;
  int? order;
  bool? isChecked;
}
