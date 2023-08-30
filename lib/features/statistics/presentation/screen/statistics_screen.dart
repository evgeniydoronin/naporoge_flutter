import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';
import '../widgets/statistic_count_week_days.dart';
import '../widgets/statistic_stream_chart.dart';
import '../widgets/statistic_stream_title.dart';
import '../widgets/statistic_weeks_progress.dart';

@RoutePage()
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        backgroundColor: AppColor.lightBG,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Статистика',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
              decoration: BoxDecoration(
                color: AppColor.lightBGItem,
                borderRadius: AppLayout.primaryRadius,
              ),
              child: const StreamTitle(),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: const WeeksProgressBox(),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: const StreamChartBox(),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: const CountWeekDaysBox(),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
