import 'package:isar/isar.dart';

part 'push_notifications_entity.g.dart';

@collection
class PushNotify {
  Id? id;
  String? title;
  String? body;
  String? startTime;
}
