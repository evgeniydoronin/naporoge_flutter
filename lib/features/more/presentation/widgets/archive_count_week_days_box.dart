import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/db_client/isar_service.dart';

class ArchiveCountWeekDaysBox extends StatefulWidget {
  final NPStream stream;

  const ArchiveCountWeekDaysBox({super.key, required this.stream});

  @override
  State<ArchiveCountWeekDaysBox> createState() => _CountWeekDaysBoxState();
}

class _CountWeekDaysBoxState extends State<ArchiveCountWeekDaysBox> {
  late Future weekDays;
  late NPStream stream;

  @override
  void initState() {
    stream = widget.stream;
    weekDays = archiveCountWeekDays(stream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: weekDays,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data;

            List daysOfWeek = [];

            for (int i = 0; i < data['daysOfWeek'].length; i++) {
              int weekNumber = data['daysOfWeek'][i]['weekNumber'] + 1;
              int completedDays = data['daysOfWeek'][i]['completedDays'];
              daysOfWeek.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        weekNumber.toString(),
                        style: TextStyle(fontSize: AppFont.regular),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '$completedDays из 6',
                        style: TextStyle(fontSize: AppFont.regular),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ]);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Количество дней',
                  style: AppFont.scaffoldTitleDark,
                ),
                Text(
                  'выполнения дела',
                  style: AppFont.scaffoldTitleDark,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Номер недели',
                        style: TextStyle(fontSize: AppFont.regular),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Количество дней',
                        style: TextStyle(fontSize: AppFont.regular),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Column(
                  children: [...daysOfWeek],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(color: AppColor.blk, fontSize: AppFont.regular),
                              text: 'Всего дело выполнялось',
                              children: [
                            TextSpan(text: ' ${data['completedDays']} ', style: TextStyle(color: AppColor.red)),
                            TextSpan(text: 'дней'),
                          ])),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Запланировано - ${data['plannedDays']} дней',
                        style: TextStyle(fontSize: AppFont.regular),
                        textAlign: TextAlign.start,
                      ),
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

Future archiveCountWeekDays(NPStream stream) async {
  int weeks = stream.weeks!;

  Map resultData = {};
  List daysOfWeek = [];

  // запланировано дней
  int plannedDays = stream.weeks! * 6;
  resultData['plannedDays'] = plannedDays;
  // выполнялось дней на текущий момент
  List completedCurrentDays = [];

  // количество выполненных дней в неделю
  for (int i = 0; i < weeks; i++) {
    Week? week = stream.weekBacklink.elementAtOrNull(i);
    // неделя создана
    if (week != null) {
      final completedDays = await week.dayBacklink.filter().completedAtIsNotNull().findAll();

      // выполнялось дней по параметру executionScope
      List dayResults = [];
      for (Day day in completedDays) {
        final res = await day.dayResultBacklink.filter().executionScopeGreaterThan(0).findFirst();
        if (res != null) {
          dayResults.add(res);
          completedCurrentDays.add(1);
        }
      }

      daysOfWeek.add({
        'weekNumber': i,
        'completedDays': dayResults.length,
      });
    }
    // неделя НЕ создана
    else {
      daysOfWeek.add({
        'weekNumber': i,
        'completedDays': 0,
      });
    }
  }

  resultData['completedDays'] = completedCurrentDays.length;
  resultData['daysOfWeek'] = daysOfWeek;

  return resultData;
}
