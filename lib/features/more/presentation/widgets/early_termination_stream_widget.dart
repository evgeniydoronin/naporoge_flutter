import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/core/utils/get_actual_student_day.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/early_termination_stream_dialog.dart';
import '../../../planning/domain/entities/stream_entity.dart';

class EarlyTerminationStreamWidget extends StatelessWidget {
  const EarlyTerminationStreamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: earlyTermination(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isActiveButton = snapshot.data;

            return isActiveButton
                ? Column(
                    children: [
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                decoration: BoxDecoration(
                                  color: AppColor.lightBGItem,
                                  borderRadius: AppLayout.primaryRadius,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: InkWell(
                                    onTap: () {
                                      earlyTerminationStreamDialog(context);
                                    },
                                    child: Text(
                                      'Досрочное завершение дела ',
                                      style: TextStyle(fontSize: AppFont.large, color: AppColor.accentBOW),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

Future earlyTermination() async {
  // Первое дело - 4я неделя понедельник и последующие стримы
  bool isActiveButton = false;
  final isarService = IsarService();
  final isar = await isarService.db;
  final List streams = await isar.nPStreams.where().findAll();
  final NPStream? activeStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
  final DateTime startAt = activeStream!.startAt!;
  final int weeks = activeStream.weeks!;
  final DateTime endOfStream = startAt.add(Duration(days: (weeks * 7) - 1));
  final DateTime now = DateTime.now();

  // NOT first stream
  if (streams.length > 1) {
    String nowData = DateFormat('yyyy-MM-d').format(now);
    String endOfStreamDate = DateFormat('yyyy-MM-d').format(endOfStream);
    // если сегодня последний день курса
    if (nowData == endOfStreamDate) {
      DateTime min = DateTime(now.year, now.month, now.day, 0, 0, 0);
      DateTime max = DateTime(now.year, now.month, now.day, 23, 59, 59);
      // проверяем выполнен ли день
      Day? day = await isar.days.filter().startAtBetween(min, max).findFirst();
      if (day!.completedAt == null) {
        isActiveButton = true;
      }
    }
    // до завершения курса
    else if (now.isBefore(endOfStream)) {
      isActiveButton = true;
    }
  }
  return isActiveButton;
}
