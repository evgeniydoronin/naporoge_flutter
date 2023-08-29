import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import '../widgets/statistic_count_week_days.dart';
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
              child: Column(
                children: [
                  Text(
                    'График',
                    style: AppFont.scaffoldTitleDark,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Данный график отображает только фактически выполненные дни',
                    style: TextStyle(fontSize: AppFont.small),
                    textAlign: TextAlign.center,
                  ),
                  const LineChartStream(),
                  Row(
                    children: [
                      Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: AppLayout.primaryRadius),
                      ),
                      const SizedBox(width: 10),
                      const Text('Процент выполнения Дела')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(color: AppColor.red, borderRadius: AppLayout.primaryRadius),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Сила нежеланий и прочих отвлечений',
                        style: TextStyle(color: AppColor.red),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(color: AppColor.accent, borderRadius: AppLayout.primaryRadius),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Сила желаний выполнить Дело',
                        style: TextStyle(color: AppColor.accent),
                      )
                    ],
                  ),
                ],
              ),
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

class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 18,
        // TODO: VAR - stream weeks
        maxY: 100,
        minY: -10,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        enabled: false,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
        lineChartBarData2_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 50:
        text = '50%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 35,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;

    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 18:
        text = const Text('18', style: style);
        break;
      case 24:
        text = const Text('24', style: style);
        break;
      case 30:
        text = const Text('30', style: style);
        break;
      case 36:
        text = const Text('36', style: style);
        break;
      case 42:
        text = const Text('42', style: style);
        break;
      case 48:
        text = const Text('48', style: style);
        break;
      case 54:
        text = const Text('54', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(axisSide: meta.axisSide, space: 0, child: text);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: AppColor.grey2, width: 1),
          left: BorderSide(color: AppColor.grey2, width: 1),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: AppColor.accent,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 45),
          FlSpot(2, 35),
          FlSpot(3, 35),
          FlSpot(4, 66),
          FlSpot(5, 60),
          FlSpot(6, 80),
          FlSpot(7, 20),
          FlSpot(8, 15),
          FlSpot(9, 100),
          FlSpot(10, 98),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: AppColor.red,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: AppColor.red,
        ),
        spots: const [
          FlSpot(1, 15),
          FlSpot(2, 45),
          FlSpot(3, 45),
          FlSpot(4, 76),
          FlSpot(5, 80),
          FlSpot(6, 90),
          FlSpot(7, 10),
          FlSpot(8, 15),
          FlSpot(9, 50),
          FlSpot(10, 98),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: AppColor.blk,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 78),
          FlSpot(2, 28),
          FlSpot(3, 25),
          FlSpot(4, 46),
          FlSpot(5, 68),
          FlSpot(6, 89),
          FlSpot(7, 70),
          FlSpot(8, 65),
          FlSpot(9, 88),
          FlSpot(10, 87),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.green.withOpacity(0.5),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: Colors.pink.withOpacity(0.5),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Colors.pink.withOpacity(0.2),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.cyan.withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
}

class LineChartStream extends StatefulWidget {
  const LineChartStream({super.key});

  @override
  State<StatefulWidget> createState() => LineChartStreamState();
}

class LineChartStreamState extends State<LineChartStream> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 35,
              ),
              Expanded(
                child: _LineChart(isShowingMainData: isShowingMainData),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}
