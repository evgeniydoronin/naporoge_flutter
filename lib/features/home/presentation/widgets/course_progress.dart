import 'package:flutter/material.dart';
import '../../utils/get_course_progress.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/constants/app_theme.dart';

class CourseProgress extends StatelessWidget {
  const CourseProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCourseProgress(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 45),
                decoration: AppLayout.boxDecorationShadowBG,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: data['colored'] != null ? AppColor.primary : AppColor.grey1,
                        shape: BoxShape.circle,
                      ),
                      width: 55,
                      child: CircularPercentIndicator(
                        radius: 32,
                        percent: data['percent'] / 100,
                        center: Text(
                          '${data['percent']}%',
                          style: TextStyle(
                              color: data['colored'] != null ? Colors.white : AppColor.accentBOW,
                              fontSize: AppFont.regular,
                              fontWeight: FontWeight.w800),
                        ),
                        progressColor: AppColor.accentBOW,
                        animation: true,
                        backgroundColor: AppColor.grey1,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'] ?? '',
                            style: AppFont.largeExtraBold,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data['description'] ?? '',
                            style: AppFont.smallNormal,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
