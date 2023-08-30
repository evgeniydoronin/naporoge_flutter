import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';
import '../utils/get_chart_stream.dart';
import 'chart_widget.dart';

class StreamChartBox extends StatefulWidget {
  const StreamChartBox({super.key});

  @override
  State<StreamChartBox> createState() => _StreamChartBoxState();
}

class _StreamChartBoxState extends State<StreamChartBox> {
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
    );
  }
}
