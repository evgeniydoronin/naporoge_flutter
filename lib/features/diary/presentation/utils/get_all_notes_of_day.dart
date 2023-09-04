import 'package:isar/isar.dart';
import '../../domain/entities/diary_note_entity.dart';
import '../../../../core/services/db_client/isar_service.dart';

Future getAllNotesOfDay(date) async {
  await Future.delayed(const Duration(milliseconds: 200));

  DateTime currentDate = date;
  DateTime lower = DateTime(currentDate.year, currentDate.month, currentDate.day, 0);
  DateTime upper = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);

  final isarService = IsarService();
  final isar = await isarService.db;

  List notes = await isar.diaryNotes.filter().createAtBetween(lower, upper).sortByCreateAtDesc().findAll();

  return notes;
}
