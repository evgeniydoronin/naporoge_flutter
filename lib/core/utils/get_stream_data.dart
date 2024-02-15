import 'package:isar/isar.dart';

import '../../features/planning/domain/entities/stream_entity.dart';
import '../services/db_client/isar_service.dart';

Future getTwoTargets() async {
  final isarService = IsarService();
  final isar = await isarService.db;

  TwoTarget? data = await isar.twoTargets.filter().nPStream((q) => q.isActiveEqualTo(true)).findFirst();
  return data ?? 0;
}
