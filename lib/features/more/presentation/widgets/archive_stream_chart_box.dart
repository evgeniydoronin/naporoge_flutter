import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import '../utils/get_archive_chart_stream.dart';

class ArchiveStreamChartBox extends StatefulWidget {
  final NPStream stream;

  const ArchiveStreamChartBox({super.key, required this.stream});

  @override
  State<ArchiveStreamChartBox> createState() => _StreamChartBoxState();
}

class _StreamChartBoxState extends State<ArchiveStreamChartBox> {
  late NPStream stream;

  @override
  void initState() {
    stream = widget.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        ArchiveLineChartStream(stream: stream),
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
    );
  }
}

class _ArchiveLineChart extends StatefulWidget {
  final NPStream stream;

  const _ArchiveLineChart({super.key, required this.stream});

  @override
  State<_ArchiveLineChart> createState() => _ArchiveLineChartState();
}

class _ArchiveLineChartState extends State<_ArchiveLineChart> {
  late NPStream stream;
  late Future chartData;
  int weeks = 0;
  double days = 0;
  List resultsOfDaysData = [];
  List<FlSpot> flSpotExecutionScope = [];
  List<FlSpot> flSpotDesiresScope = [];
  List<FlSpot> flSpotReluctanceScope = [];

  @override
  void initState() {
    stream = widget.stream;
    chartData = getArchiveChartStream(stream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chartData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data;
            weeks = data['weeks'];
            days = data['days'];
            resultsOfDaysData = data['resultsOfDaysData'];
            flSpotExecutionScope = [];
            flSpotDesiresScope = [];
            flSpotReluctanceScope = [];

            for (int i = 0; i < resultsOfDaysData.length; i++) {
              DayResult dayResult = resultsOfDaysData[i];
              double index = i + 1;
              // Объем выполнения дела
              flSpotExecutionScope.add(FlSpot(index, dayResult.executionScope!.toDouble()));

              // -значения: левый 15%, центр 50%, правый 85%
              // Сила желаний
              List statusWishes = [
                {'small': 15.0},
                {'middle': 50.0},
                {'large': 85.0}
              ];
              for (Map status in statusWishes) {
                if (status.keys.single == dayResult.desires) {
                  flSpotDesiresScope.add(FlSpot(index, status.values.single));
                }
                if (status.keys.single == dayResult.reluctance) {
                  flSpotReluctanceScope.add(FlSpot(index, status.values.single));
                }
              }
              // print(dayResult.desires);
              // Сила нежеланий
            }

            return LineChart(
              streamData,
              duration: const Duration(milliseconds: 250),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  LineChartData get streamData => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 0,
        maxX: days,
        maxY: 100,
        minY: -10,
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

  List<LineChartBarData> get lineBarsData => [
        desires,
        reluctance,
        executionScope,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
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

  // Сила желаний
  LineChartBarData get desires => LineChartBarData(
        isCurved: true,
        color: AppColor.accent,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [...flSpotDesiresScope],
      );

  // Сила нежеланий
  LineChartBarData get reluctance => LineChartBarData(
        isCurved: true,
        color: AppColor.red,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: AppColor.red,
        ),
        spots: [...flSpotReluctanceScope],
      );

  // Объем выполнения дела
  LineChartBarData get executionScope => LineChartBarData(
        isCurved: true,
        color: AppColor.blk,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [...flSpotExecutionScope],
      );
}

class ArchiveLineChartStream extends StatefulWidget {
  final NPStream stream;

  const ArchiveLineChartStream({super.key, required this.stream});

  @override
  State<StatefulWidget> createState() => ArchiveLineChartStreamState();
}

class ArchiveLineChartStreamState extends State<ArchiveLineChartStream> {
  late NPStream stream;

  @override
  void initState() {
    stream = widget.stream;
    super.initState();
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
                child: _ArchiveLineChart(stream: stream),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
