import 'package:collection/collection.dart';
import 'package:isar/isar.dart';

import '../../../../core/services/db_client/isar_service.dart';
import '../../../planning/domain/entities/stream_entity.dart';

Future getChartStream() async {
  Map chartData = {};

  final isarService = IsarService();
  final isar = await isarService.db;
  final NPStream? stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  // weeks of stream
  int? weeks = stream!.weeks;
  chartData['weeks'] = weeks;

  // days of stream
  double days = weeks! * 6;
  chartData['days'] = days;

  // results of days
  final resultsOfDaysData = [];
  final weeksOfStream = await isar.weeks.filter().streamIdEqualTo(stream.id).findAll();

  for (Week week in weeksOfStream) {
    final daysOfWeek = await isar.days.filter().weekIdEqualTo(week.id).completedAtIsNotNull().findAll();

    for (Day day in daysOfWeek) {
      final resultsOfDay = await isar.dayResults.filter().dayIdEqualTo(day.id).findFirst();

      resultsOfDaysData.add(resultsOfDay);
    }
  }

  // sort by id
  resultsOfDaysData.sort((a, b) => a.id.compareTo(b.id));


  chartData['resultsOfDaysData'] = resultsOfDaysData;

  return chartData;
}
