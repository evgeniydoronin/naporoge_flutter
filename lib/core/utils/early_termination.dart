import 'package:isar/isar.dart';
import '../../features/planning/data/sources/local/stream_local_storage.dart';
import '../../features/planning/domain/entities/stream_entity.dart';
import '../../features/planning/presentation/stream_controller.dart';
import '../services/controllers/service_locator.dart';
import '../services/db_client/isar_service.dart';

Future earlyTermination() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  DateTime now = DateTime.now();
  final NPStream? activeStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
  final DateTime startAt = activeStream!.startAt!;
  final DateTime needDelete = startAt.add(const Duration(days: 7));

  // Удаление дела
  if (now.isBefore(needDelete)) {
    print('Удаление дела');
    await deleteStream(activeStream);
  }
  // Деактивация без удаления дела
  else {
    print('Деактивация без удаления дела');
    await deactivateStream(activeStream);
  }
}

/// Delete stream
Future deleteStream(NPStream stream) async {
  final streamController = getIt<StreamController>();
  final streamLocalStorage = StreamLocalStorage();

  Map streamData = {
    "stream_id": stream.id,
  };

  // delete  on server
  var deletedStream = await streamController.deleteStream(streamData);
  //
  // print('deletedStream: $deletedStream');

  // delete on local
  if (deletedStream['stream']['id'] != null) {
    await streamLocalStorage.deleteStream(deletedStream);
  }
}

/// Deactivate stream
Future deactivateStream(NPStream stream) async {
  final streamController = getIt<StreamController>();
  final streamLocalStorage = StreamLocalStorage();

  Map streamData = {
    "stream_id": stream.id,
  };

  // deactivate  on server
  var deactivatedStream = await streamController.deactivateStream(streamData);
  //
  print('deactivatedStream: $deactivatedStream');

  // deactivate on local
  if (deactivatedStream['stream']['id'] != null) {
    await streamLocalStorage.deactivateStream(deactivatedStream);
  }
}
