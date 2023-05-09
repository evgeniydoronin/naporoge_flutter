import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';

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
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 18, right: 18),
              decoration: BoxDecoration(
                color: AppColor.lightBGItem,
                borderRadius: AppLayout.primaryRadius,
              ),
              child: Text(
                'Йога',
                style: TextStyle(
                    color: AppColor.accentBOW,
                    fontSize: AppFont.large,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const WeeksStatisticsPageView(),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: AppLayout.accentBTNStyle,
                          child: Text(
                            'Отметить достижения недели',
                            style: AppFont.regularSemibold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 18, right: 18),
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
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: AppLayout.primaryRadius),
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
                        decoration: BoxDecoration(
                            color: AppColor.red,
                            borderRadius: AppLayout.primaryRadius),
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
                        decoration: BoxDecoration(
                            color: AppColor.accent,
                            borderRadius: AppLayout.primaryRadius),
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
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: Column(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: AppFont.regular),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '6 из 6',
                          style: TextStyle(fontSize: AppFont.regular),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '2',
                          style: TextStyle(fontSize: AppFont.regular),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '4 из 6',
                          style: TextStyle(fontSize: AppFont.regular),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '3',
                          style: TextStyle(fontSize: AppFont.regular),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '0',
                          style: TextStyle(fontSize: AppFont.regular),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: AppColor.blk,
                                    fontSize: AppFont.regular),
                                text: 'Всего дело выполнялось',
                                children: [
                              TextSpan(
                                  text: ' 11 ',
                                  style: TextStyle(color: AppColor.red)),
                              TextSpan(text: 'дней'),
                            ])),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Запланировано - 18 дней',
                          style: TextStyle(fontSize: AppFont.regular),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class WeeksStatisticsPageView extends StatefulWidget {
  const WeeksStatisticsPageView({Key? key}) : super(key: key);

  @override
  State<WeeksStatisticsPageView> createState() =>
      _WeeksStatisticsPageViewState();
}

class _WeeksStatisticsPageViewState extends State<WeeksStatisticsPageView> {
  final PageController pageController = PageController(initialPage: 0);

  int activePage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: Stack(children: [
        PageView.builder(
            controller: pageController,
            itemCount: 3,
            onPageChanged: (int page) {
              setState(() {
                activePage = page;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Text(
                    'Неделя $index',
                    style: AppFont.scaffoldTitleDark,
                  ),
                  const SizedBox(height: 10),
                  Table(
                    columnWidths: const {1: FractionColumnWidth(.9)},
                    border: TableBorder(
                      horizontalInside:
                          BorderSide(width: 1, color: AppColor.grey1),
                      verticalInside:
                          BorderSide(width: 1, color: AppColor.grey1),
                      bottom: BorderSide(width: 1, color: AppColor.grey1),
                    ),
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Пн',
                              style: TextStyle(
                                  fontSize: AppFont.small,
                                  color: AppColor.grey2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '10 кругов',
                              style: TextStyle(fontSize: AppFont.small),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Вт',
                              style: TextStyle(
                                  fontSize: AppFont.small,
                                  color: AppColor.grey2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '10 кругов',
                              style: TextStyle(fontSize: AppFont.small),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Ср',
                              style: TextStyle(
                                  fontSize: AppFont.small,
                                  color: AppColor.grey2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '10 кругов',
                              style: TextStyle(fontSize: AppFont.small),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Чт',
                              style: TextStyle(
                                  fontSize: AppFont.small,
                                  color: AppColor.grey2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '10 кругов',
                              style: TextStyle(fontSize: AppFont.small),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Пт',
                              style: TextStyle(
                                  fontSize: AppFont.small,
                                  color: AppColor.grey2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'пропуск',
                              style: TextStyle(
                                  fontSize: AppFont.small,
                                  color: AppColor.grey2),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Сб',
                              style: TextStyle(
                                  fontSize: AppFont.small,
                                  color: AppColor.grey2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '',
                              style: TextStyle(fontSize: AppFont.small),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Вс',
                              style: TextStyle(
                                  fontSize: AppFont.small,
                                  color: AppColor.grey2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '',
                              style: TextStyle(fontSize: AppFont.small),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: TextStyle(fontSize: AppFont.small),
                    maxLines: 3,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.grey1,
                        hintText:
                            'Например: удалось пробежать 5 км, прочитать полкниги, сбросить 2 кг',
                        hintStyle: TextStyle(color: AppColor.grey3),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 10),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: AppLayout.smallRadius,
                            borderSide:
                                BorderSide(width: 1, color: AppColor.grey1))),
                  ),
                ],
              );
            }),
        Positioned(
          bottom: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                  3,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CircleAvatar(
                          maxRadius: 5,
                          backgroundColor: activePage == index
                              ? AppColor.accent
                              : AppColor.grey1,
                        ),
                      )),
            ),
          ),
        ),
      ]),
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
