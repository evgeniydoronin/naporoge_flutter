import 'package:isar/isar.dart';

import '../../features/planning/domain/entities/stream_entity.dart';
import '../services/db_client/isar_service.dart';

Future<NPStream?> getCurrentStream() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final currentStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
  return currentStream;
}
