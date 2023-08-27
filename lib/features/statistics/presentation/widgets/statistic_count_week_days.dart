import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';
import '../utils/count_week_days.dart';

class CountWeekDaysBox extends StatefulWidget {
  const CountWeekDaysBox({super.key});

  @override
  State<CountWeekDaysBox> createState() => _CountWeekDaysBoxState();
}

class _CountWeekDaysBoxState extends State<CountWeekDaysBox> {
  late Future weekDays;

  @override
  void initState() {
    weekDays = countWeekDays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: countWeekDays(),
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
