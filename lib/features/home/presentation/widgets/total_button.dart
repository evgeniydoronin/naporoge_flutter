import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/get_status_stream.dart';
import '../../../planning/domain/entities/stream_entity.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/get_week_number.dart';

class TotalButton extends StatelessWidget {
  const TotalButton({super.key, required this.stream});

  final NPStream stream;

  @override
  Widget build(BuildContext context) {
    Map streamStatus = getStreamStatus(stream);

    late ElevatedButton elevatedButton;
    // текущая неделя
    int weekNumber = getWeekNumber(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          if (streamStatus['status'] == 'beforeStartStream') {

          } else if (streamStatus['status'] == 'afterEndStream') {

          } else if (streamStatus['status'] == 'inStream') {
            context.router.push(const DayResultsSaveScreenRoute());
          }
        },
        style: AppLayout.accentBowBTNStyle,
        child: Text(
          'Внести результаты',
          style: AppFont.regularSemibold,
        ),
      ),
    );
  }
}
