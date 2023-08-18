import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_screen/home_screen_bloc.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/constants/app_theme.dart';

class WeekProgress extends StatelessWidget {
  const WeekProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 45),
        decoration: AppLayout.boxDecorationShadowBG,
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: CircularPercentIndicator(
                radius: 30,
                percent: 0 / 100,
                center: Text(
                  '10%',
                  style: TextStyle(color: AppColor.accentBOW, fontSize: AppFont.large, fontWeight: FontWeight.w800),
                ),
                progressColor: AppColor.accentBOW,
                backgroundColor: AppColor.grey1,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "title",
                    style: AppFont.largeExtraBold,
                  ),
                  Text(
                    "description",
                    style: AppFont.smallNormal,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
