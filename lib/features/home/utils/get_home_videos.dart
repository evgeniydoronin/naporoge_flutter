import 'package:isar/isar.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';

import '../../../core/services/db_client/isar_service.dart';

Future getHomeVideos() async {
  List previewVideoIndex = [1, 0, 0, 0];
  // Сразу (Первое прохождение) “Появилось первое видео! Ключ к развитию”
  // Сб 9:00 недели 1 (Первое прохождение) “Появилось 2 новых видео! Что делать, когда не хочу делать дело? Почему откладываются дела?”
  // Сб 9:00  недели 2 (Первое прохождение) “Появилось новое видео: Верное завершение дел” (текст в пушах без кавычек)

  final isarService = IsarService();
  final isar = await isarService.db;
  List streams = await isar.nPStreams.where().findAll();
  DateTime now = DateTime.now();

  // первый курс
  if (streams.length == 1) {
    // print('first stream');
    DateTime startStreamAt = streams[0]!.startAt!;
    DateTime firstSaturday =
        DateTime(startStreamAt.year, startStreamAt.month, startStreamAt.day, 9, 0, 0).add(const Duration(days: 5));
    DateTime secondSaturday =
        DateTime(firstSaturday.year, firstSaturday.month, firstSaturday.day, 9, 0, 0).add(const Duration(days: 7));

    // print('startStreamAt: $startStreamAt');
    // print('firstSaturday: $firstSaturday');
    // print('secondSaturday: $secondSaturday');
    // print('now: $now');
    if (now.isAfter(firstSaturday)) {
      // print('Появилось 2 новых видео!');
      previewVideoIndex[1] = 1;
      previewVideoIndex[2] = 1;
    }
    if (now.isAfter(secondSaturday)) {
      // print('Появилось последнее видео!');
      previewVideoIndex[3] = 1;
    }
  }
  // не первый курс
  else {
    previewVideoIndex[1] = 1;
    previewVideoIndex[2] = 1;
    previewVideoIndex[3] = 1;
  }

  return previewVideoIndex;
}
