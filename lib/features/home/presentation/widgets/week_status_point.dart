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
        // print('weekDay.length: ${weekDay.length}');
        // print('weekStatusPoint: ${weekStatusPoint.length}');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 84,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 18),
            decoration: AppLayout.boxDecorationShadowBG,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 10,
                childAspectRatio: 1 / 1.7,
              ),
              itemCount: 7,
              itemBuilder: (context, gridIndex) {
                Container _container = Container();
                // Результат дня НЕ сохранялся
                if (weekStatusPoint.isEmpty) {
                  _container = Container(
                    height: 110,
                    decoration: BoxDecoration(
                        color: AppColor.grey1,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 34,
                          height: 33,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: Center(
                            child: Text(
                              weekDay[gridIndex].toUpperCase(),
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
                          child: const Center(
                            child: Text(
                              '-',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // Результат дня сохранялся
                else if (weekStatusPoint[gridIndex]['status'] == 'completed') {
                  _container = Container(
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: Center(
                            child: Text(
                              weekDay[gridIndex].toUpperCase(),
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
                }
                // День пропущен
                else if (weekStatusPoint[gridIndex]['status'] == 'skipped') {
                  _container = Container(
                    decoration: BoxDecoration(
                        color: AppColor.blk,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.blk,
                              borderRadius: BorderRadius.circular(34)),
                          child: Center(
                            child: Text(
                              weekDay[gridIndex].toUpperCase(),
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
                }
                // Текущий день
                else if (weekStatusPoint[gridIndex]['status'] == 'opened') {
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
                              weekDay[gridIndex].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          decoration: const BoxDecoration(
                            // color: AppColor.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(34),
                              bottomRight: Radius.circular(34),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              weekStatusPoint[gridIndex]['weekDay'] == 'Sunday'
                                  ? '-'
                                  : weekStatusPoint[gridIndex]['title']
                                      .toString(),
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

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: Container(
        //     height: 84,
        //     padding: const EdgeInsets.only(
        //         top: 10, bottom: 10, left: 18, right: 18),
        //     decoration: AppLayout.boxDecorationShadowBG,
        //     child: ListView.separated(
        //       separatorBuilder: (context, index) {
        //         return Divider(
        //           color: Theme.of(context).primaryColor,
        //           height: 3,
        //           indent: 0,
        //           endIndent: 12,
        //         );
        //       },
        //       scrollDirection: Axis.horizontal,
        //       shrinkWrap: true,
        //       itemCount: weekDay.length,
        //       itemBuilder: (context, index) {
        //         Container _container = Container();
        //         // Результат дня НЕ сохранялся
        //         if (weekStatusPoint.isEmpty) {
        //           _container = Container(
        //             decoration: BoxDecoration(
        //                 color: AppColor.grey1,
        //                 borderRadius: BorderRadius.circular(34)),
        //             child: Column(
        //               children: [
        //                 Container(
        //                   width: 34,
        //                   height: 34,
        //                   decoration: BoxDecoration(
        //                       color: AppColor.primary,
        //                       borderRadius: BorderRadius.circular(34)),
        //                   child: Center(
        //                     child: Text(
        //                       weekDay[index].toUpperCase(),
        //                       style: const TextStyle(
        //                           fontSize: 12,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                   ),
        //                 ),
        //                 Container(
        //                   height: 28,
        //                   width: 34,
        //                   decoration: const BoxDecoration(
        //                     // color: AppColor.primary,
        //                     borderRadius: BorderRadius.only(
        //                       bottomLeft: Radius.circular(34),
        //                       bottomRight: Radius.circular(34),
        //                     ),
        //                   ),
        //                   child: const Center(
        //                     child: Text(
        //                       '-',
        //                       style: const TextStyle(fontSize: 10),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           );
        //         }
        //         // Результат дня сохранялся
        //         else if (weekStatusPoint[index]['status'] == 'completed') {
        //           _container = Container(
        //             decoration: BoxDecoration(
        //                 color: AppColor.primary,
        //                 borderRadius: BorderRadius.circular(34)),
        //             child: Column(
        //               children: [
        //                 Container(
        //                   width: 34,
        //                   height: 34,
        //                   decoration: BoxDecoration(
        //                       color: AppColor.primary,
        //                       borderRadius: BorderRadius.circular(34)),
        //                   child: Center(
        //                     child: Text(
        //                       weekDay[index].toUpperCase(),
        //                       style: const TextStyle(
        //                           fontSize: 12,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                   ),
        //                 ),
        //                 Container(
        //                   height: 24,
        //                   padding: const EdgeInsets.only(bottom: 3),
        //                   decoration: BoxDecoration(
        //                       color: AppColor.primary,
        //                       borderRadius: AppLayout.primaryRadius),
        //                   child: SvgPicture.asset(
        //                     'assets/icons/checked_day.svg',
        //                     height: 24,
        //                     clipBehavior: Clip.none,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           );
        //         }
        //         // День пропущен
        //         else if (weekStatusPoint[index]['status'] == 'skipped') {
        //           _container = Container(
        //             decoration: BoxDecoration(
        //                 color: AppColor.blk,
        //                 borderRadius: BorderRadius.circular(34)),
        //             child: Column(
        //               children: [
        //                 Container(
        //                   width: 34,
        //                   height: 34,
        //                   decoration: BoxDecoration(
        //                       color: AppColor.blk,
        //                       borderRadius: BorderRadius.circular(34)),
        //                   child: Center(
        //                     child: Text(
        //                       weekDay[index].toUpperCase(),
        //                       style: const TextStyle(
        //                           fontSize: 12,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                   ),
        //                 ),
        //                 Container(
        //                   height: 24,
        //                   padding: const EdgeInsets.only(bottom: 3),
        //                   decoration: BoxDecoration(
        //                       color: AppColor.blk,
        //                       borderRadius: AppLayout.primaryRadius),
        //                   child: SvgPicture.asset(
        //                     'assets/icons/missed_day.svg',
        //                     height: 24,
        //                     clipBehavior: Clip.none,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           );
        //         }
        //         // Текущий день
        //         else if (weekStatusPoint[index]['status'] == 'opened') {
        //           _container = Container(
        //             decoration: BoxDecoration(
        //                 color: AppColor.grey1,
        //                 borderRadius: BorderRadius.circular(34)),
        //             child: Column(
        //               children: [
        //                 Container(
        //                   width: 34,
        //                   height: 34,
        //                   decoration: BoxDecoration(
        //                       color: AppColor.primary,
        //                       borderRadius: BorderRadius.circular(34)),
        //                   child: Center(
        //                     child: Text(
        //                       weekDay[index].toUpperCase(),
        //                       style: const TextStyle(
        //                           fontSize: 12,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                   ),
        //                 ),
        //                 Container(
        //                   height: 28,
        //                   width: 34,
        //                   decoration: const BoxDecoration(
        //                     // color: AppColor.primary,
        //                     borderRadius: BorderRadius.only(
        //                       bottomLeft: Radius.circular(34),
        //                       bottomRight: Radius.circular(34),
        //                     ),
        //                   ),
        //                   child: Center(
        //                     child: Text(
        //                       weekStatusPoint[index]['weekDay'] == 'Sunday'
        //                           ? '-'
        //                           : weekStatusPoint[index]['title']
        //                           .toString(),
        //                       style: const TextStyle(fontSize: 10),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           );
        //         }
        //
        //         return _container;
        //       },
        //     ),
        //   ),
        // ),
      },
    );
  }
}
