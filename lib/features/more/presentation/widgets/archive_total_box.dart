import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../planning/domain/entities/stream_entity.dart';

import '../../../../core/services/db_client/isar_service.dart';

class ArchiveTotalBox extends StatefulWidget {
  final NPStream stream;

  const ArchiveTotalBox({super.key, required this.stream});

  @override
  State<ArchiveTotalBox> createState() => _ArchiveTotalBoxState();
}

class _ArchiveTotalBoxState extends State<ArchiveTotalBox> {
  late Future _getTotal;
  late NPStream stream;

  @override
  void initState() {
    stream = widget.stream;
    _getTotal = getArchiveTotalResultsStream(stream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getTotal,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map streamResults = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Объем выполнения дела (дней)',
                  style: AppFont.scaffoldTitleDark,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Отлично',
                      style: TextStyle(fontSize: AppFont.regular),
                    ),
                    Text(
                      '${streamResults['high']}',
                      style: TextStyle(fontSize: AppFont.regular),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Хорошо',
                      style: TextStyle(fontSize: AppFont.regular),
                    ),
                    Text(
                      '${streamResults['middle']}',
                      style: TextStyle(fontSize: AppFont.regular),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Слабо',
                      style: TextStyle(fontSize: AppFont.regular),
                    ),
                    Text(
                      '${streamResults['low']}',
                      style: TextStyle(fontSize: AppFont.regular),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'План не составлялся',
                      style: TextStyle(fontSize: AppFont.regular, color: AppColor.red),
                    ),
                    Text(
                      '${streamResults['weekNotPlanned']} из ${streamResults['weeks']}',
                      style: TextStyle(fontSize: AppFont.regular, color: AppColor.red),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

Future<Map> getArchiveTotalResultsStream(NPStream stream) async {
  Map total = {};

  final isarService = IsarService();
  final isar = await isarService.db;

  int weeks = stream.weeks!;
  int days = 6 * weeks;

  // формируем завершенные дни
  List weekIds = stream.weekBacklink.map((week) => week.id).toList();

  ///////////////////////////////
  // Завершенные дни
  ///////////////////////////////
  List daysIdCompleted = [];
  for (int i = 0; i < weekIds.length; i++) {
    List daysInWeek = await isar.days.filter().weekIdEqualTo(weekIds[i]).completedAtIsNotNull().findAll();
    daysIdCompleted.addAll(daysInWeek);
  }

  // print('daysIdCompleted: $daysIdCompleted');

  ///////////////////////////////
  // Результат выполнения дня
  ///////////////////////////////
  List executionScope = [];
  if (daysIdCompleted.isNotEmpty) {
    for (int i = 0; i < daysIdCompleted.length; i++) {
      Day day = daysIdCompleted[i];
      final res = await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

      if (res != null) {
        executionScope.add(res);
      }
    }
  }

  ///////////////////////////////
  // объем выполнения
  ///////////////////////////////
  List middle = [];
  List high = [];

  for (Week week in stream.weekBacklink) {
    for (Day day in week.dayBacklink) {
      for (DayResult result in day.dayResultBacklink) {
        if (result.executionScope! > 50 && result.executionScope! <= 80) {
          middle.add(1);
        } else if (result.executionScope! >= 81) {
          high.add(1);
        }
      }
    }
  }

  // слабо, все дни курса минус выполненные на хорошо и отлично
  int low = days - middle.length - high.length;

  print('low: $low');

  ///////////////////////////////
  // сообщение
  ///////////////////////////////
  TextSpan? message;
  List margePoint = [low, middle.length, high.length];
  int point = margePoint.reduce((a, b) => a > b ? a : b);
  int? maxPointIndex;

  for (int i = 0; i < margePoint.length; i++) {
    // print('point: $point');
    // print('i: $i');
    // print('margePoint[i]: ${margePoint[i]}');

    if (margePoint[i] == point) {
      maxPointIndex = i;
    }
  }

  // слабо
  if (maxPointIndex == 0) {
    message = const TextSpan(
      text: 'Слабо. \n',
      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      children: <TextSpan>[
        TextSpan(
            text:
                'Продолжайте тренировать волю. Делайте дело «во что бы то ни стало». Не забывайте радоваться успехам. Возникнут трудности – присоединяйтесь в чат',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
      ],
    );
  }
  // хорошо
  else if (maxPointIndex == 1) {
    message = const TextSpan(
      text: 'Хорошо. \n',
      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      children: <TextSpan>[
        TextSpan(
            text: 'Рекомендуем продолжать саморазвитие. У вас хорошие способности',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
      ],
    );
  }
  // отлично
  else if (maxPointIndex == 2) {
    message = const TextSpan(
      text: 'Отлично. \n',
      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      children: <TextSpan>[
        TextSpan(
            text: 'Поздравляем! Рекомендуем продолжать саморазвитие. Реальный шанс сильно продвинуться',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
      ],
    );
  }

  ///////////////////////////////
  // План не составлялся
  ///////////////////////////////
  List weekNotPlannedList = [];
  for (int i = 0; i < stream.weekBacklink.length; i++) {
    Week week = stream.weekBacklink.elementAt(i);

    if (week.dayBacklink.first.startAt == null) {
      weekNotPlannedList.add(1);
    }
  }

  // РЕЗУЛЬТАТЫ
  total['title'] = stream.title;
  total['weeks'] = weeks;
  total['days'] = days;
  total['message'] = message;
  total['low'] = low;
  total['middle'] = middle.length;
  total['high'] = high.length;
  total['executionScope'] = executionScope.length;
  total['weekNotPlanned'] = weekNotPlannedList.length;

  return total;
}
