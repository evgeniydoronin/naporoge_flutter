import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/week_data_constant.dart';
import '../../../planning/domain/entities/stream_entity.dart';

import '../../../../core/constants/app_theme.dart';
import '../bloc/home_screen/home_screen_bloc.dart';

class WeekStatusPoint extends StatelessWidget {
  const WeekStatusPoint({super.key, required this.stream});

  final NPStream stream;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {},
      builder: (context, state) {
        List weekStatusPoint = [];
        if (state.streamProgress != null) {
          // {status: opened, dayID: 718, title: 04:05, weekDay: Monday}
          weekStatusPoint = state.streamProgress!['weekStatusPoint'];
          // print('weekStatusPoint: $weekStatusPoint');
          // print('weekStatusPoint.length: ${weekStatusPoint.length}');
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 84,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 18),
            decoration: AppLayout.boxDecorationShadowBG,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Theme.of(context).primaryColor,
                  height: 3,
                  indent: 0,
                  endIndent: 12,
                );
              },
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: weekStatusPoint.length,
              itemBuilder: (context, index) {
                Container _container = Container();
                if (weekStatusPoint[index]['status'] == 'completed') {
                  _container = Container(
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: Center(
                            child: Text(
                              weekDay[index].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          padding: const EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: AppLayout.primaryRadius),
                          child: SvgPicture.asset(
                            'assets/icons/checked_day.svg',
                            height: 24,
                            clipBehavior: Clip.none,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (weekStatusPoint[index]['status'] == 'skipped') {
                  _container = Container(
                    decoration: BoxDecoration(
                        color: AppColor.blk,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.blk,
                              borderRadius: BorderRadius.circular(34)),
                          child: Center(
                            child: Text(
                              weekDay[index].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          padding: const EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                              color: AppColor.blk,
                              borderRadius: AppLayout.primaryRadius),
                          child: SvgPicture.asset(
                            'assets/icons/missed_day.svg',
                            height: 24,
                            clipBehavior: Clip.none,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (weekStatusPoint[index]['status'] == 'opened') {
                  _container = Container(
                    decoration: BoxDecoration(
                        color: AppColor.grey1,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: Center(
                            child: Text(
                              weekDay[index].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 34,
                          decoration: const BoxDecoration(
                            // color: AppColor.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(34),
                              bottomRight: Radius.circular(34),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              weekStatusPoint[index]['weekDay'] == 'Sunday'
                                  ? '-'
                                  : weekStatusPoint[index]['title'].toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _container;
              },
            ),
          ),
        );
      },
    );
  }
}
