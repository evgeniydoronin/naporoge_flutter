import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import '../../../../core/constants/app_theme.dart';
import '../utils/get_chart_stream.dart';

class _LineChart extends StatefulWidget {
  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> {
  late Future chartData;
  int weeks = 0;
  double days = 0;
  List resultsOfDaysData = [];
  List<FlSpot> flSpotExecutionScope = [];

  @override
  void initState() {
    chartData = getChartStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getChartStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data;
            weeks = data['weeks'];
            days = data['days'];
            resultsOfDaysData = data['resultsOfDaysData'];
            flSpotExecutionScope = [];

            for (int i = 0; i < resultsOfDaysData.length; i++) {
              DayResult dayResult = resultsOfDaysData[i];
              double index = i + 1;
              // Объем выполнения дела
              flSpotExecutionScope.add(FlSpot(index, dayResult.executionScope!.toDouble()));
              // Сила нежеланий
              // Сила желаний
            }

            return LineChart(
              streamData,
              swapAnimationDuration: const Duration(milliseconds: 250),
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

class LineChartStream extends StatefulWidget {
  const LineChartStream({super.key});

  @override
  State<StatefulWidget> createState() => LineChartStreamState();
}

class LineChartStreamState extends State<LineChartStream> {
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
                child: _LineChart(),
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
