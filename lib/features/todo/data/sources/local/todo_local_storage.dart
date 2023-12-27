import '../../../../../core/services/db_client/isar_service.dart';
import '../../../domain/entities/todo_entity.dart';

class TodoLocal {
  final isarService = IsarService();

  Future<void> createTodoLocal(Todo todo) async {
    final isar = await isarService.db;

    // TODO: продолжить тут
    print('isar: $isar');

    // Map streamData = todoDataFromServer['stream'];
    //
    // // деактивируем предыдущий курс, если есть
    // NPStream? previousStream;
    // int? previousStreamId = todoDataFromServer['old_stream'];
    // if (previousStreamId != null) {
    //   previousStream = await isar.nPStreams.get(previousStreamId);
    //   previousStream?.isActive = false;
    // }
    //
    // final newStream = NPStream()
    //   ..id = streamData['id']
    //   ..courseId = streamData['course_id']
    //   ..isActive = streamData['is_active']
    //   ..title = streamData['title']
    //   ..weeks = streamData['weeks']
    //   ..description = streamData['description']
    //   ..startAt = DateTime.parse(streamData['start_at']);
    //
    // isar.writeTxnSync(() async {
    //   // деактивируем предыдущий курс
    //   if (previousStream != null) {
    //     isar.nPStreams.putSync(previousStream);
    //   }
    //   isar.nPStreams.putSync(newStream);
    // });
  }
}
